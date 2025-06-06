//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Feed {
    private let stateBuilder: StateBuilder<FeedState>
    
    public let group: String
    public let id: String
    
    public var fid: String {
        "\(group):\(id)"
    }
    
    var user: User
    
    private let repository: FeedsRepository
    
    internal init(
        group: String,
        id: String,
        user: User,
        repository: FeedsRepository,
        events: WSEventsSubscribing
    ) {
        self.group = group
        self.id = id
        self.user = user
        self.repository = repository
        let feedId = "\(group):\(id)"
        stateBuilder = StateBuilder { FeedState(feedId: feedId, events: events) }
    }
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the feed.
    @MainActor public lazy private(set) var state: FeedState = stateBuilder.build()
    
    // MARK: - Creating and Fetching the Feed
    
    public func getOrCreate(request: GetOrCreateFeedRequest) async throws {
        let result = try await repository.getOrCreateFeed(feedGroupId: group, feedId: id, request: request)
        await state.update(with: result)
    }
    
    @discardableResult
    public func updateFeed(request: UpdateFeedRequest) async throws -> FeedInfo {
        let feed = try await repository.updateFeed(feedGroupId: group, feedId: id, request: request)
        await state.changeHandlers.feedUpdated(feed)
        return feed
    }
    
    public func deleteFeed(hardDelete: Bool = false) async throws {
        try await repository.deleteFeed(feedGroupId: group, feedId: id, hardDelete: hardDelete)
    }
    
    // MARK: - Activities
    
    @discardableResult
    public func addActivity(request: AddActivityRequest) async throws -> ActivityInfo {
        let activity = try await repository.addActivity(
            request: request
        )
        await state.changeHandlers.activityAdded(activity)
        return activity
    }
    
    public func deleteActivity(id: String, hardDelete: Bool = false) async throws {
        try await repository.deleteActivity(activityId: id, hardDelete: hardDelete)
        await state.update { $0.activities.removeAll(where: { $0.id == id }) }
    }
    
    @discardableResult
    public func updateActivity(id: String, request: UpdateActivityRequest) async throws -> ActivityInfo {
        let activity = try await repository.updateActivity(activityId: id, request: request)
        await state.changeHandlers.activityUpdated(activity)
        return activity
    }
    
    // MARK: - Activity Interactions
    
    public func markActivity(request: MarkActivityRequest) async throws {
        try await repository.markActivity(feedGroupId: group, feedId: id, request: request)
    }
    
    @discardableResult
    public func repost(activityId: String, text: String?) async throws -> ActivityInfo {
        let activity = try await repository.addActivity(
            request: .init(fids: [fid], parentId: activityId, text: text, type: "post")
        )
        await state.changeHandlers.activityAdded(activity)
        return activity
    }
    
    // MARK: - Bookmarks
        
    @discardableResult
    public func addBookmark(activityId: String) async throws -> BookmarkInfo {
        try await repository.addBookmark(activityId: activityId)
    }
    
    @discardableResult
    public func deleteBookmark(activityId: String) async throws -> BookmarkInfo {
        try await repository.deleteBookmark(activityId: activityId)
    }
    
    // MARK: - Follows
    
    @discardableResult
    public func follow(request: SingleFollowRequest) async throws -> FollowInfo {
        let follow = try await repository.follow(request: request)
        await state.changeHandlers.followAdded(follow)
        return follow
    }
    
    public func unfollow(sourceFid: String? = nil, targetFid: String) async throws {
        try await repository.unfollow(source: sourceFid ?? self.fid, target: targetFid)
        // TODO: Review
        await state.update { state in
            state.followers.removeAll(where: { $0.sourceFeed.id == sourceFid && $0.targetFeed.id == targetFid })
            state.following.removeAll(where: { $0.sourceFeed.id == sourceFid && $0.targetFeed.id == targetFid })
        }
    }
    
    @discardableResult
    public func acceptFollow(request: AcceptFollowRequest) async throws -> FollowInfo {
        let follow = try await repository.acceptFollow(request: request)
        await state.update { $0.followRequests.removeAll(where: { $0.id == follow.id }) }
        await state.changeHandlers.followAdded(follow)
        return follow
    }
    
    @discardableResult
    public func rejectFollow(request: RejectFollowRequest) async throws -> FollowInfo {
        let follow = try await repository.rejectFollow(request: request)
        await state.update { $0.followRequests.removeAll(where: { $0.id == follow.id }) }
        return follow
    }
    
    // MARK: - Members
    
    public func queryFeedMembers(request: QueryFeedMembersRequest) async throws -> QueryFeedMembersResponse {
        try await repository.queryFeedMembers(feedGroupId: group, feedId: id, request: request)
    }

    public func updateFeedMembers(request: UpdateFeedMembersRequest) async throws {
        try await repository.updateFeedMembers(feedGroupId: group, feedId: id, request: request)
    }

    public func acceptFeedMember(feedId: String, feedGroupId: String) async throws -> FeedMemberInfo {
        let response = try await repository.acceptFeedMember(feedId: feedId, feedGroupId: feedGroupId)
        // TODO: update state
        return response
    }
    
    public func rejectFeedMember(feedId: String, feedGroupId: String) async throws -> FeedMemberInfo {
        try await repository.rejectFeedMember(feedGroupId: feedGroupId, feedId: feedId)
        // TODO: update state
    }
    
    // MARK: - Reactions
    
    @discardableResult
    public func addReaction(activityId: String, request: AddReactionRequest) async throws -> ActivityReactionInfo {
        let reaction = try await repository.addReaction(activityId: activityId, request: request)
        await state.changeHandlers.reactionAdded(reaction)
        return reaction
    }
    
    @discardableResult
    public func deleteReaction(activityId: String, type: String) async throws -> ActivityReactionInfo {
        try await repository.deleteReaction(activityId: activityId, type: type)
    }
    
    // MARK: - Polls
    
    @discardableResult
    public func createPoll(request: CreatePollRequest, activityType: String) async throws -> PollResponse {
        let response = try await repository.apiClient.createPoll(createPollRequest: request)
        _ = try await repository.addActivity(
            request: .init(fids: [fid], pollId: response.poll.id, type: activityType)
        )
        return response
    }
}
