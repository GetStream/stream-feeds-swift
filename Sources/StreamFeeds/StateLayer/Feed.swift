//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A feed represents a collection of activities and provides methods to interact with them.
///
/// The `Feed` class is the primary interface for working with feeds in the Stream Feeds SDK.
/// It provides functionality for:
/// - Creating and managing feed data
/// - Adding, updating, and deleting activities
/// - Managing comments, reactions, and bookmarks
/// - Handling follows and feed memberships
/// - Creating polls and managing poll interactions
/// - Pagination and querying of feed content
///
/// Each feed instance is associated with a specific feed ID and maintains its own state
/// that can be observed for real-time updates. The feed state includes activities,
/// followers, members, and other feed-related data.
///
/// - Note: This class is thread-safe and can be used from any thread.
public final class Feed: Sendable {
    @MainActor private let stateBuilder: StateBuilder<FeedState>
    
    private let feedQuery: FeedQuery
    private let attachmentsUploader: StreamAttachmentUploader
    private let disposableBag = DisposableBag()
    private let eventPublisher: StateLayerEventPublisher
    
    private let activitiesRepository: ActivitiesRepository
    private let bookmarksRepository: BookmarksRepository
    private let commentsRepository: CommentsRepository
    private let feedsRepository: FeedsRepository
    private let memberList: MemberList
    private let ownCapabilitiesRepository: OwnCapabilitiesRepository
    private let pollsRepository: PollsRepository
    
    init(query: FeedQuery, client: FeedsClient) {
        activitiesRepository = client.activitiesRepository
        attachmentsUploader = client.attachmentsUploader
        bookmarksRepository = client.bookmarksRepository
        commentsRepository = client.commentsRepository
        feedQuery = query
        feedsRepository = client.feedsRepository
        eventPublisher = client.stateLayerEventPublisher
        memberList = client.memberList(for: .init(feed: query.feed))
        ownCapabilitiesRepository = client.ownCapabilitiesRepository
        pollsRepository = client.pollsRepository
        let currentUserId = client.user.id
        stateBuilder = StateBuilder { [eventPublisher, memberList] in
            FeedState(
                feedQuery: query,
                currentUserId: currentUserId,
                eventPublisher: eventPublisher,
                memberListState: memberList.state
            )
        }
        // Automatically refetch data on reconnection
        if feedQuery.watch {
            subscribeToReconnectionUpdates(client: client)
        }
    }
    
    /// The unique identifier for this feed.
    ///
    /// This property provides access to the feed's identifier, which is used to distinguish
    /// this feed from other feeds in the system. The feed ID is composed of a group and
    /// an ID component that together form a unique reference to this specific feed.
    public var feed: FeedId { feedQuery.feed }
    
    private var id: String { feed.id }
    private var group: String { feed.group }
    
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
    /// - Returns: `FeedData` containing the latest state of the feed.
    @discardableResult
    public func getOrCreate() async throws -> FeedData {
        let result = try await feedsRepository.getOrCreateFeed(with: feedQuery)
        await state.didQueryFeed(with: result)
        if let updated = ownCapabilitiesRepository.saveCapabilities(result.allOwnCapabilities) {
            await eventPublisher.sendEvent(.feedOwnCapabilitiesUpdated(updated))
        }
        return result.feed
    }
    
    /// Stops watching the feed.
    /// When this method is called, you will not receive any web socket events for the feed anymore.
    public func stopWatching() async throws {
        try await feedsRepository.stopWatching(feedGroupId: group, feedId: id)
    }
    
    // MARK: - Updating the Feed
    
    /// Updates the feed with the provided request data.
    ///
    /// - Parameter request: The update request containing the new feed data
    /// - Returns: The updated feed data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func updateFeed(request: UpdateFeedRequest) async throws -> FeedData {
        let feedData = try await feedsRepository.updateFeed(feedGroupId: group, feedId: id, request: request)
        await eventPublisher.sendEvent(.feedUpdated(feedData, feed))
        return feedData
    }
    
    /// Deletes the feed.
    ///
    /// - Parameter hardDelete: If `true`, the feed will be permanently deleted. If `false`, it will be soft deleted.
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func deleteFeed(hardDelete: Bool = false) async throws {
        try await feedsRepository.deleteFeed(feedGroupId: group, feedId: id, hardDelete: hardDelete)
        await eventPublisher.sendEvent(.feedDeleted(feed))
    }
    
    // MARK: - Activities
    
    /// Adds a new activity to the feed.
    ///
    /// - Parameter request: The request containing the activity data to add
    /// - Returns: The created activity data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func addActivity(request: FeedAddActivityRequest) async throws -> ActivityData {
        let activity = try await activitiesRepository.addActivity(request: request, in: feed)
        await eventPublisher.sendEvent(.activityAdded(activity, feed))
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
        await eventPublisher.sendEvent(.activityDeleted(id, feed))
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
        await eventPublisher.sendEvent(.activityUpdated(activity, feed))
        return activity
    }
    
    // MARK: - Activity Interactions
    
    /// Marks an activity as read or unread.
    ///
    /// - Parameter request: The request containing the mark activity data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func markActivity(request: MarkActivityRequest) async throws {
        let markData = try await activitiesRepository.markActivity(feedGroupId: group, feedId: id, request: request)
        await eventPublisher.sendEvent(.activityMarked(markData, feed))
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
            request: .init(feeds: [feed.rawValue], parentId: activityId, text: text, type: "post")
        )
        await eventPublisher.sendEvent(.activityAdded(activity, feed))
        return activity
    }
    
    // MARK: - Activity Pagination
    
    /// Loads more activities using the next page token from the previous query.
    ///
    /// - Parameter limit: Optional limit for the number of activities to load. If `nil`, uses the default limit.
    /// - Returns: An array of additional activity data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func queryMoreActivities(limit: Int? = nil) async throws -> [ActivityData] {
        let nextQuery: FeedQuery? = await state.access { _ in
            guard let next = state.activitiesPagination?.next else { return nil }
            var query = FeedQuery(
                feed: feedQuery.feed,
                activityFilter: state.activitiesQueryConfig?.filter,
                activityLimit: limit ?? feedQuery.activityLimit,
                activitySelectorOptions: nil,
                data: nil,
                externalRanking: nil,
                followerLimit: 0,
                followingLimit: 0,
                interestWeights: nil,
                memberLimit: 0,
                view: nil,
                watch: feedQuery.watch
            )
            query.activityNext = next
            return query
        }
        guard let nextQuery else { return [] }
        let response = try await feedsRepository.getOrCreateFeed(with: nextQuery)
        await state.didPaginateActivities(with: response.activities, for: response.activitiesQueryConfig)
        return response.activities.models
    }
    
    // MARK: - Bookmarks
        
    /// Adds an activity to the user's bookmarks.
    ///
    /// - Parameters:
    ///   - activityId: The unique identifier of the activity to bookmark
    ///   - request: Additional details of for the bookmark
    /// - Returns: The created bookmark data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func addBookmark(activityId: String, request: AddBookmarkRequest = .init()) async throws -> BookmarkData {
        let bookmark = try await bookmarksRepository.addBookmark(activityId: activityId, request: request)
        await eventPublisher.sendEvent(.bookmarkAdded(bookmark))
        return bookmark
    }
    
    /// Removes an activity from the user's bookmarks.
    ///
    /// - Parameters:
    ///   - activityId: The unique identifier of the activity to remove from bookmarks
    ///   - folderId: Optional folder identifier. If provided, removes the bookmark from the specific folder.
    /// - Returns: The removed bookmark data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func deleteBookmark(activityId: String, folderId: String? = nil) async throws -> BookmarkData {
        let bookmark = try await bookmarksRepository.deleteBookmark(activityId: activityId, folderId: folderId)
        await eventPublisher.sendEvent(.bookmarkDeleted(bookmark))
        return bookmark
    }
    
    /// Updates an existing bookmark for an activity.
    ///
    /// This method allows you to modify the properties of an existing bookmark, such as
    /// changing the folder it belongs to or updating custom data associated with the bookmark.
    ///
    /// - Parameters:
    ///   - activityId: The unique identifier of the activity whose bookmark should be updated
    ///   - request: The update request containing the new bookmark properties to apply
    /// - Returns: The updated bookmark data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    ///
    /// - Example:
    ///   ```swift
    ///   // Move a bookmark to a different folder
    ///   let updateRequest = UpdateBookmarkRequest(folderId: "new-folder-id")
    ///   let updatedBookmark = try await feed.updateBookmark(
    ///       activityId: "activity-123",
    ///       request: updateRequest
    ///   )
    ///
    ///   // Update bookmark with custom data
    ///   let customUpdateRequest = UpdateBookmarkRequest(
    ///       folderId: "favorites",
    ///       custom: ["note": "Important article"]
    ///   )
    ///   let bookmark = try await feed.updateBookmark(
    ///       activityId: "activity-456",
    ///       request: customUpdateRequest
    ///   )
    ///   ```
    @discardableResult
    public func updateBookmark(activityId: String, request: UpdateBookmarkRequest) async throws -> BookmarkData {
        let bookmark = try await bookmarksRepository.updateBookmark(activityId: activityId, request: request)
        await eventPublisher.sendEvent(.bookmarkUpdated(bookmark))
        return bookmark
    }
    
    // MARK: - Comments
    
    /// Gets a specific comment by its identifier.
    ///
    /// - Parameter commentId: The unique identifier of the comment to retrieve
    /// - Returns: The comment data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func getComment(commentId: String) async throws -> CommentData {
        let comment = try await commentsRepository.getComment(commentId: commentId)
        await eventPublisher.sendEvent(.commentUpdated(comment, comment.objectId, feed))
        return comment
    }
    
    /// Adds a new comment to activity with id.
    ///
    /// - Parameter request: The request containing the comment data to add
    /// - Returns: The created comment data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func addComment(request: AddCommentRequest) async throws -> CommentData {
        let comment = try await commentsRepository.addComment(request: request)
        if let activity = await state.activities.first(where: { $0.id == comment.objectId }) {
            await eventPublisher.sendEvent(.commentAdded(comment, activity, feed))
        }
        return comment
    }
    
    /// Removes a comment for id.
    ///
    /// - Parameter commentId: The unique identifier of the comment to remove
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func deleteComment(commentId: String, hardDelete: Bool? = false) async throws {
        let response = try await commentsRepository.deleteComment(commentId: commentId, hardDelete: hardDelete)
        await eventPublisher.sendEvent(.commentDeleted(response.comment, response.activityId, feed))
    }
    
    /// Updates an existing comment with the provided request data.
    ///
    /// This method allows you to modify the content and properties of an existing comment.
    /// You can update the comment text, attachments, or other comment-specific data.
    ///
    /// - Parameters:
    ///   - commentId: The unique identifier of the comment to update
    ///   - request: The request containing the updated comment data
    /// - Returns: The updated comment data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func updateComment(commentId: String, request: UpdateCommentRequest) async throws -> CommentData {
        let comment = try await commentsRepository.updateComment(commentId: commentId, request: request)
        await eventPublisher.sendEvent(.commentUpdated(comment, comment.objectId, feed))
        return comment
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
    /// - Parameters:
    ///   - targetFid: The target feed id.
    ///   - createNotificationActivity: Whether the action is added to the notification feed.
    ///   - custom: Additional data for the request.
    ///   - pushPreference: Push notification preferences for the follow request.
    /// - Throws: `APIError` if the network request fails or the server returns an error
    /// - Returns: The data of the follow request.
    @discardableResult
    public func follow(
        _ targetFid: FeedId,
        createNotificationActivity: Bool? = nil,
        custom: [String: RawJSON]? = nil,
        pushPreference: FollowRequest.FollowRequestPushPreference? = nil
    ) async throws -> FollowData {
        let request = FollowRequest(
            createNotificationActivity: createNotificationActivity,
            custom: custom,
            pushPreference: pushPreference,
            source: feed.rawValue,
            target: targetFid.rawValue
        )
        let follow = try await feedsRepository.follow(request: request)
        await eventPublisher.sendEvent(.feedFollowAdded(follow, feed))
        return follow
    }
    
    /// Unfollows another feed.
    ///
    /// - Parameters:
    ///   - targetFeed: The target feed identifier to unfollow
    /// - Returns: The data of the follow.
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult public func unfollow(_ targetFeed: FeedId) async throws -> FollowData {
        let follow = try await feedsRepository.unfollow(source: feed, target: targetFeed)
        await eventPublisher.sendEvent(.feedFollowDeleted(follow, feed))
        return follow
    }
    
    /// Accepts a follow request from another feed.
    ///
    /// - Parameters:
    ///   - sourceFid: The feed if of the requested feed.
    ///   - role: The role for the requesting feed.
    /// - Returns: The updated follow data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func acceptFollow(_ sourceFid: FeedId, role: String? = nil) async throws -> FollowData {
        let request = AcceptFollowRequest(followerRole: role, source: sourceFid.rawValue, target: feed.rawValue)
        let follow = try await feedsRepository.acceptFollow(request: request)
        await eventPublisher.sendEvent(.feedFollowAdded(follow, feed))
        return follow
    }
    
    /// Rejects a follow request from another feed.
    ///
    /// - Parameter sourceFid: The feed if of the requested feed.
    /// - Returns: The rejected follow data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func rejectFollow(_ sourceFid: FeedId) async throws -> FollowData {
        let request = RejectFollowRequest(source: sourceFid.rawValue, target: feed.rawValue)
        let follow = try await feedsRepository.rejectFollow(request: request)
        await eventPublisher.sendEvent(.feedFollowDeleted(follow, feed))
        return follow
    }
    
    // MARK: - Members
    
    /// Fetches the initial list of members based on the current query configuration.
    ///
    /// This method loads the first page of members according to the query's filters,
    /// sorting, and limit parameters. The results are stored in the state and can
    /// be accessed through the `state.members` property.
    ///
    /// - Returns: An array of `FeedMemberData` representing the fetched members.
    /// - Throws: An error if the network request fails or the response cannot be parsed.
    @discardableResult
    public func queryFeedMembers() async throws -> [FeedMemberData] {
        try await memberList.get()
    }
    
    /// Loads the next page of members if more are available.
    ///
    /// This method fetches additional members using the pagination information
    /// from the previous request. If no more members are available, an empty
    /// array is returned.
    ///
    /// - Parameter limit: Optional limit for the number of members to fetch.
    ///   If not specified, uses the limit from the original query.
    /// - Returns: An array of `FeedMemberData` representing the additional members.
    ///   Returns an empty array if no more members are available.
    /// - Throws: An error if the network request fails or the response cannot be parsed.
    @discardableResult
    public func queryMoreFeedMembers(limit: Int? = nil) async throws -> [FeedMemberData] {
        try await memberList.queryMoreMembers(limit: limit)
    }

    /// Updates feed members based on the provided request.
    ///
    /// - Parameter request: The update request containing the member changes to apply
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func updateFeedMembers(request: UpdateFeedMembersRequest) async throws -> ModelUpdates<FeedMemberData> {
        let updates = try await feedsRepository.updateFeedMembers(feedGroupId: group, feedId: id, request: request)
        await eventPublisher.sendEvent(.feedMemberBatchUpdate(updates, feed))
        return updates
    }

    /// Accepts a feed member invitation.
    ///
    /// - Returns: The accepted feed member data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func acceptFeedMember() async throws -> FeedMemberData {
        let member = try await feedsRepository.acceptFeedMember(feedId: id, feedGroupId: group)
        await eventPublisher.sendEvent(.feedMemberAdded(member, feed))
        return member
    }
    
    /// Rejects a feed member invitation.
    ///
    /// - Returns: The rejected feed member data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    public func rejectFeedMember() async throws -> FeedMemberData {
        let member = try await feedsRepository.rejectFeedMember(feedGroupId: group, feedId: id)
        await eventPublisher.sendEvent(.feedMemberDeleted(member.id, feed))
        return member
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
        let result = try await activitiesRepository.addReaction(activityId: activityId, request: request)
        await eventPublisher.sendEvent(.activityReactionAdded(result.reaction, result.activity, feed))
        return result.reaction
    }
    
    /// Removes a reaction from an activity.
    ///
    /// - Parameters:
    ///   - activityId: The unique identifier of the activity
    ///   - type: The type of reaction to remove
    /// - Returns: The removed reaction data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func deleteReaction(activityId: String, type: String) async throws -> FeedsReactionData {
        let result = try await activitiesRepository.deleteReaction(activityId: activityId, type: type)
        await eventPublisher.sendEvent(.activityReactionDeleted(result.reaction, result.activity, feed))
        return result.reaction
    }
    
    /// Adds a reaction to a comment.
    ///
    /// - Parameters:
    ///   - commentId: The unique identifier of the comment to react to
    ///   - request: The request containing the reaction data
    /// - Returns: The created reaction data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func addCommentReaction(commentId: String, request: AddCommentReactionRequest) async throws -> FeedsReactionData {
        let result = try await commentsRepository.addCommentReaction(commentId: commentId, request: request)
        await eventPublisher.sendEvent(.commentReactionAdded(result.reaction, result.comment, feed))
        return result.reaction
    }

    /// Removes a reaction from a comment.
    ///
    /// - Parameters:
    ///   - commentId: The unique identifier of the comment
    ///   - type: The type of reaction to remove
    /// - Returns: The removed reaction data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func deleteCommentReaction(commentId: String, type: String) async throws -> FeedsReactionData {
        let result = try await commentsRepository.deleteCommentReaction(commentId: commentId, type: type)
        await eventPublisher.sendEvent(.commentReactionDeleted(result.reaction, result.comment, feed))
        return result.reaction
    }
    
    // MARK: - Polls
    
    /// Creates a new poll and adds it as an activity to the feed.
    ///
    /// - Parameters:
    ///   - request: The request containing the poll data to create
    ///   - activityType: The type of activity to create for the poll
    /// - Returns: The created activity with poll
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func createPoll(request: CreatePollRequest, activityType: String) async throws -> ActivityData {
        let poll = try await pollsRepository.createPoll(request: request)
        let activity = try await activitiesRepository.addActivity(
            request: .init(feeds: [feed.rawValue], pollId: poll.id, type: activityType)
        )
        await eventPublisher.sendEvent(.activityAdded(activity, feed))
        return activity
    }
    
    // MARK: - private
    
    private func subscribeToReconnectionUpdates(client: FeedsClient) {
        client.reconnectionPublisher.asyncSink { [weak self] in
            guard let self else { return }
            log.debug("Re-watching feed \(feed) after WS reconnection")
            do {
                try await getOrCreate()
            } catch {
                log.error("Re-watching feed \(feed) failed", error: error)
            }
        }
        .store(in: disposableBag)
    }
}
