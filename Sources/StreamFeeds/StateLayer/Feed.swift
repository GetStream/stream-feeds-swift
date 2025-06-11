//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Feed: Sendable {
    @MainActor private let stateBuilder: StateBuilder<FeedState>
    
    public let group: String
    public let id: String
    
    public var fid: String {
        "\(group):\(id)"
    }
    
    // TODO: Move?
    private let user: User
    
    private let activitiesRepository: ActivitiesRepository
    private let feedsRepository: FeedsRepository
    private let pollsRepository: PollsRepository
    
    internal init(
        group: String,
        id: String,
        user: User,
        activitiesRepository: ActivitiesRepository,
        feedsRepository: FeedsRepository,
        pollsRepository: PollsRepository,
        events: WSEventsSubscribing
    ) {
        self.group = group
        self.id = id
        self.user = user
        self.activitiesRepository = activitiesRepository
        self.feedsRepository = feedsRepository
        self.pollsRepository = pollsRepository
        let feedId = "\(group):\(id)"
        stateBuilder = StateBuilder { FeedState(feedId: feedId, events: events) }
    }
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the feed.
    @MainActor public var state: FeedState { stateBuilder.state }
    
    // MARK: - Creating and Fetching the Feed
    
    public func getOrCreate(request: GetOrCreateFeedRequest) async throws {
        let result = try await feedsRepository.getOrCreateFeed(feedGroupId: group, feedId: id, request: request)
        await state.update(with: result)
    }
    
    @discardableResult
    public func updateFeed(request: UpdateFeedRequest) async throws -> FeedData {
        let feed = try await feedsRepository.updateFeed(feedGroupId: group, feedId: id, request: request)
        await state.changeHandlers.feedUpdated(feed)
        return feed
    }
    
    public func deleteFeed(hardDelete: Bool = false) async throws {
        try await feedsRepository.deleteFeed(feedGroupId: group, feedId: id, hardDelete: hardDelete)
    }
    
    // MARK: - Activities
    
    @discardableResult
    public func addActivity(request: AddActivityRequest) async throws -> ActivityData {
        let activity = try await activitiesRepository.addActivity(
            request: request
        )
        await state.changeHandlers.activityAdded(activity)
        return activity
    }
    
    public func deleteActivity(id: String, hardDelete: Bool = false) async throws {
        try await activitiesRepository.deleteActivity(activityId: id, hardDelete: hardDelete)
        await state.update { $0.activities.removeAll(where: { $0.id == id }) }
    }
    
    @discardableResult
    public func updateActivity(id: String, request: UpdateActivityRequest) async throws -> ActivityData {
        let activity = try await activitiesRepository.updateActivity(activityId: id, request: request)
        await state.changeHandlers.activityUpdated(activity)
        return activity
    }
    
    // MARK: - Activity Interactions
    
    public func markActivity(request: MarkActivityRequest) async throws {
        try await activitiesRepository.markActivity(feedGroupId: group, feedId: id, request: request)
    }
    
    @discardableResult
    public func repost(activityId: String, text: String?) async throws -> ActivityData {
        let activity = try await activitiesRepository.addActivity(
            request: .init(fids: [fid], parentId: activityId, text: text, type: "post")
        )
        await state.changeHandlers.activityAdded(activity)
        return activity
    }
    
    // MARK: - Bookmarks
        
    @discardableResult
    public func addBookmark(activityId: String) async throws -> BookmarkData {
        try await activitiesRepository.addBookmark(activityId: activityId)
    }
    
    @discardableResult
    public func deleteBookmark(activityId: String, folderId: String? = nil) async throws -> BookmarkData {
        try await activitiesRepository.deleteBookmark(activityId: activityId, folderId: folderId)
    }
    
    // MARK: - Follows
    
    public func queryFollowSuggestions(limit: Int?) async throws -> [FeedData] {
        try await feedsRepository.queryFollowSuggestions(feedGroupId: group, limit: limit)
    }
    
    @discardableResult
    public func follow(request: SingleFollowRequest) async throws -> FollowData {
        let follow = try await feedsRepository.follow(request: request)
        await state.changeHandlers.followAdded(follow)
        return follow
    }
    
    public func unfollow(sourceFid: String? = nil, targetFid: String) async throws {
        try await feedsRepository.unfollow(source: sourceFid ?? self.fid, target: targetFid)
        // TODO: Review
        await state.update { state in
            state.followers.removeAll(where: { $0.sourceFeed.id == sourceFid && $0.targetFeed.id == targetFid })
            state.following.removeAll(where: { $0.sourceFeed.id == sourceFid && $0.targetFeed.id == targetFid })
        }
    }
    
    @discardableResult
    public func acceptFollow(request: AcceptFollowRequest) async throws -> FollowData {
        let follow = try await feedsRepository.acceptFollow(request: request)
        await state.update { $0.followRequests.removeAll(where: { $0.id == follow.id }) }
        await state.changeHandlers.followAdded(follow)
        return follow
    }
    
    @discardableResult
    public func rejectFollow(request: RejectFollowRequest) async throws -> FollowData {
        let follow = try await feedsRepository.rejectFollow(request: request)
        await state.update { $0.followRequests.removeAll(where: { $0.id == follow.id }) }
        return follow
    }
    
    // MARK: - Members
    
    public func queryFeedMembers(request: QueryFeedMembersRequest) async throws -> QueryFeedMembersResponse {
        try await feedsRepository.queryFeedMembers(feedGroupId: group, feedId: id, request: request)
    }

    public func updateFeedMembers(request: UpdateFeedMembersRequest) async throws {
        try await feedsRepository.updateFeedMembers(feedGroupId: group, feedId: id, request: request)
    }

    public func acceptFeedMember(feedId: String, feedGroupId: String) async throws -> FeedMemberData {
        let response = try await feedsRepository.acceptFeedMember(feedId: feedId, feedGroupId: feedGroupId)
        // TODO: update state
        return response
    }
    
    public func rejectFeedMember(feedId: String, feedGroupId: String) async throws -> FeedMemberData {
        try await feedsRepository.rejectFeedMember(feedGroupId: feedGroupId, feedId: feedId)
        // TODO: update state
    }
    
    // MARK: - Reactions
    
    @discardableResult
    public func addReaction(activityId: String, request: AddReactionRequest) async throws -> FeedsReactionData {
        let reaction = try await activitiesRepository.addReaction(activityId: activityId, request: request)
        await state.changeHandlers.reactionAdded(reaction)
        return reaction
    }
    
    @discardableResult
    public func deleteReaction(activityId: String, type: String) async throws -> FeedsReactionData {
        try await activitiesRepository.deleteReaction(activityId: activityId, type: type)
    }
    
    // MARK: - Polls
    
    @discardableResult
    public func createPoll(request: CreatePollRequest, activityType: String) async throws -> PollData {
        let poll = try await pollsRepository.createPoll(request: request)
        _ = try await activitiesRepository.addActivity(
            request: .init(fids: [fid], pollId: poll.id, type: activityType)
        )
        return poll
    }
}
