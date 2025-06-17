//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Feed: Sendable {
    @MainActor private let stateBuilder: StateBuilder<FeedState>
    
    public var group: String { feedQuery.feedGroupId }
    public var id: String { feedQuery.feedId }
    
    public var fid: String {
        "\(group):\(id)"
    }
    
    private let feedQuery: FeedQuery
    
    // TODO: Move?
    private let user: User
    
    private let activitiesRepository: ActivitiesRepository
    private let feedsRepository: FeedsRepository
    private let pollsRepository: PollsRepository
    
    internal init(
        query: FeedQuery,
        user: User,
        client: FeedsClient
    ) {
        self.user = user
        self.activitiesRepository = client.activitiesRepository
        self.feedsRepository = client.feedsRepository
        self.pollsRepository = client.pollsRepository
        self.feedQuery = query
        let feedId = "\(feedQuery.feedGroupId):\(feedQuery.feedId)"
        let events = client.eventsMiddleware
        stateBuilder = StateBuilder { FeedState(feedId: feedId, feedQuery: query, events: events) }
    }
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the feed.
    @MainActor public var state: FeedState { stateBuilder.state }
    
    // MARK: - Creating and Fetching the Feed
    
    /// Fetches or creates the feed based on the current feed query.
    ///
    /// This method will either retrieve an existing feed or create a new one if it doesn't exist.
    /// The feed state will be updated with the fetched data including activities, followers, and other feed information.
    ///
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func get() async throws {
        let result = try await feedsRepository.getOrCreateFeed(with: feedQuery)
        await state.didQueryFeed(with: result)
    }
    
    // MARK: - Updating the Feed
    
    /// Updates the feed with the provided request data.
    ///
    /// - Parameter request: The update request containing the new feed data
    /// - Returns: The updated feed data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func updateFeed(request: UpdateFeedRequest) async throws -> FeedData {
        let feed = try await feedsRepository.updateFeed(feedGroupId: group, feedId: id, request: request)
        await state.changeHandlers.feedUpdated(feed)
        return feed
    }
    
    /// Deletes the feed.
    ///
    /// - Parameter hardDelete: If `true`, the feed will be permanently deleted. If `false`, it will be soft deleted.
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func deleteFeed(hardDelete: Bool = false) async throws {
        try await feedsRepository.deleteFeed(feedGroupId: group, feedId: id, hardDelete: hardDelete)
    }
    
    // MARK: - Activities
    
    /// Adds a new activity to the feed.
    ///
    /// - Parameter request: The request containing the activity data to add
    /// - Returns: The created activity data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func addActivity(request: AddActivityRequest) async throws -> ActivityData {
        let activity = try await activitiesRepository.addActivity(
            request: request
        )
        await state.changeHandlers.activityAdded(activity)
        return activity
    }
    
    /// Deletes an activity from the feed.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the activity to delete
    ///   - hardDelete: If `true`, the activity will be permanently deleted. If `false`, it will be soft deleted.
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func deleteActivity(id: String, hardDelete: Bool = false) async throws {
        try await activitiesRepository.deleteActivity(activityId: id, hardDelete: hardDelete)
        await state.access { $0.activities.removeAll(where: { $0.id == id }) }
    }
    
    /// Updates an existing activity in the feed.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the activity to update
    ///   - request: The request containing the updated activity data
    /// - Returns: The updated activity data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func updateActivity(id: String, request: UpdateActivityRequest) async throws -> ActivityData {
        let activity = try await activitiesRepository.updateActivity(activityId: id, request: request)
        await state.changeHandlers.activityUpdated(activity)
        return activity
    }
    
    // MARK: - Activity Interactions
    
    /// Marks an activity as read or unread.
    ///
    /// - Parameter request: The request containing the mark activity data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func markActivity(request: MarkActivityRequest) async throws {
        try await activitiesRepository.markActivity(feedGroupId: group, feedId: id, request: request)
    }
    
    /// Creates a repost of an existing activity.
    ///
    /// - Parameters:
    ///   - activityId: The unique identifier of the activity to repost
    ///   - text: Optional text to add to the repost
    /// - Returns: The created repost activity data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func repost(activityId: String, text: String?) async throws -> ActivityData {
        let activity = try await activitiesRepository.addActivity(
            request: .init(fids: [fid], parentId: activityId, text: text, type: "post")
        )
        await state.changeHandlers.activityAdded(activity)
        return activity
    }
    
    // MARK: - Activity Pagination
    
    /// Queries activities in the feed based on the provided query parameters.
    ///
    /// - Parameter query: The query configuration for filtering and sorting activities
    /// - Returns: An array of activity data matching the query criteria
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func queryActivities(with query: ActivitiesQuery) async throws -> [ActivityData] {
        let result = try await activitiesRepository.queryActivities(with: query)
        let queryConfig =  QueryConfiguration(filter: query.filter, sort: query.sort)
        await state.didPaginateActivities(with: result, for: queryConfig)
        return result.models
    }
    
    /// Loads more activities using the next page token from the previous query.
    ///
    /// - Parameter limit: Optional limit for the number of activities to load. If `nil`, uses the default limit.
    /// - Returns: An array of additional activity data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func queryMoreActivities(limit: Int? = nil) async throws -> [ActivityData] {
        let nextQuery: ActivitiesQuery? = await state.access { state in
            guard let next = state.activitiesPagination?.next else { return nil }
            return ActivitiesQuery(
                filter: state.activitiesQueryConfig?.filter,
                sort: state.activitiesQueryConfig?.sort ?? [],
                next: nil,
                previous: next,
                limit: limit
            )
        }
        guard let nextQuery else { return [] }
        return try await queryActivities(with: nextQuery)
    }
    
    // MARK: - Bookmarks
        
    /// Adds an activity to the user's bookmarks.
    ///
    /// - Parameter activityId: The unique identifier of the activity to bookmark
    /// - Returns: The created bookmark data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func addBookmark(activityId: String) async throws -> BookmarkData {
        try await activitiesRepository.addBookmark(activityId: activityId)
    }
    
    /// Removes an activity from the user's bookmarks.
    ///
    /// - Parameters:
    ///   - activityId: The unique identifier of the activity to remove from bookmarks
    ///   - folderId: Optional folder identifier. If provided, removes the bookmark from the specific folder.
    /// - Returns: The deleted bookmark data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func deleteBookmark(activityId: String, folderId: String? = nil) async throws -> BookmarkData {
        try await activitiesRepository.deleteBookmark(activityId: activityId, folderId: folderId)
    }
    
    // MARK: - Follows
    
    /// Queries for feed suggestions that the current user might want to follow.
    ///
    /// - Parameter limit: Optional limit for the number of suggestions to return. If `nil`, uses the default limit.
    /// - Returns: An array of feed data representing follow suggestions
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func queryFollowSuggestions(limit: Int?) async throws -> [FeedData] {
        try await feedsRepository.queryFollowSuggestions(feedGroupId: group, limit: limit)
    }
    
    /// Follows another feed.
    ///
    /// - Parameter request: The follow request containing the source and target feed information
    /// - Returns: The created follow data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func follow(request: SingleFollowRequest) async throws -> FollowData {
        let follow = try await feedsRepository.follow(request: request)
        await state.changeHandlers.followAdded(follow)
        return follow
    }
    
    /// Unfollows another feed.
    ///
    /// - Parameters:
    ///   - sourceFid: The source feed identifier. If `nil`, uses the current feed's identifier.
    ///   - targetFid: The target feed identifier to unfollow
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func unfollow(sourceFid: String? = nil, targetFid: String) async throws {
        try await feedsRepository.unfollow(source: sourceFid ?? self.fid, target: targetFid)
        // TODO: Review
        await state.access { state in
            state.followers.removeAll(where: { $0.sourceFeed.id == sourceFid && $0.targetFeed.id == targetFid })
            state.following.removeAll(where: { $0.sourceFeed.id == sourceFid && $0.targetFeed.id == targetFid })
        }
    }
    
    /// Accepts a follow request from another feed.
    ///
    /// - Parameter request: The accept follow request containing the follow request information
    /// - Returns: The updated follow data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func acceptFollow(request: AcceptFollowRequest) async throws -> FollowData {
        let follow = try await feedsRepository.acceptFollow(request: request)
        await state.access { $0.followRequests.removeAll(where: { $0.id == follow.id }) }
        await state.changeHandlers.followAdded(follow)
        return follow
    }
    
    /// Rejects a follow request from another feed.
    ///
    /// - Parameter request: The reject follow request containing the follow request information
    /// - Returns: The rejected follow data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func rejectFollow(request: RejectFollowRequest) async throws -> FollowData {
        let follow = try await feedsRepository.rejectFollow(request: request)
        await state.access { $0.followRequests.removeAll(where: { $0.id == follow.id }) }
        return follow
    }
    
    // MARK: - Members
    
    /// Queries feed members based on the provided request parameters.
    ///
    /// - Parameter request: The query request containing filtering and pagination parameters
    /// - Returns: A response containing the queried feed members
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func queryFeedMembers(request: QueryFeedMembersRequest) async throws -> QueryFeedMembersResponse {
        try await feedsRepository.queryFeedMembers(feedGroupId: group, feedId: id, request: request)
    }

    /// Updates feed members based on the provided request.
    ///
    /// - Parameter request: The update request containing the member changes to apply
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func updateFeedMembers(request: UpdateFeedMembersRequest) async throws {
        try await feedsRepository.updateFeedMembers(feedGroupId: group, feedId: id, request: request)
    }

    /// Accepts a feed member invitation.
    ///
    /// - Parameters:
    ///   - feedId: The feed identifier
    ///   - feedGroupId: The feed group identifier
    /// - Returns: The accepted feed member data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func acceptFeedMember(feedId: String, feedGroupId: String) async throws -> FeedMemberData {
        let response = try await feedsRepository.acceptFeedMember(feedId: feedId, feedGroupId: feedGroupId)
        // TODO: update state
        return response
    }
    
    /// Rejects a feed member invitation.
    ///
    /// - Parameters:
    ///   - feedId: The feed identifier
    ///   - feedGroupId: The feed group identifier
    /// - Returns: The rejected feed member data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func rejectFeedMember(feedId: String, feedGroupId: String) async throws -> FeedMemberData {
        try await feedsRepository.rejectFeedMember(feedGroupId: feedGroupId, feedId: feedId)
        // TODO: update state
    }
    
    // MARK: - Reactions
    
    /// Adds a reaction to an activity.
    ///
    /// - Parameters:
    ///   - activityId: The unique identifier of the activity to react to
    ///   - request: The request containing the reaction data
    /// - Returns: The created reaction data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func addReaction(activityId: String, request: AddReactionRequest) async throws -> FeedsReactionData {
        let reaction = try await activitiesRepository.addReaction(activityId: activityId, request: request)
        await state.changeHandlers.reactionAdded(reaction)
        return reaction
    }
    
    /// Deletes a reaction from an activity.
    ///
    /// - Parameters:
    ///   - activityId: The unique identifier of the activity
    ///   - type: The type of reaction to delete
    /// - Returns: The deleted reaction data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func deleteReaction(activityId: String, type: String) async throws -> FeedsReactionData {
        try await activitiesRepository.deleteReaction(activityId: activityId, type: type)
    }
    
    // MARK: - Polls
    
    /// Creates a new poll and adds it as an activity to the feed.
    ///
    /// - Parameters:
    ///   - request: The request containing the poll data to create
    ///   - activityType: The type of activity to create for the poll
    /// - Returns: The created poll data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func createPoll(request: CreatePollRequest, activityType: String) async throws -> PollData {
        let poll = try await pollsRepository.createPoll(request: request)
        _ = try await activitiesRepository.addActivity(
            request: .init(fids: [fid], pollId: poll.id, type: activityType)
        )
        return poll
    }
}
