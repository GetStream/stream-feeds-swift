//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A repository for managing feeds.
///
/// Action methods make API requests and transform API responses to local models.
final class FeedsRepository: Sendable {
    private let apiClient: DefaultAPI
    
    init(apiClient: DefaultAPI) {
        self.apiClient = apiClient
    }
    
    // MARK: - Creating or Getting the State of the Feed
    
    func getOrCreateFeed(with query: FeedQuery) async throws -> GetOrCreateInfo {
        let feed = query.feed
        let request = query.toRequest()
        let response = try await apiClient.getOrCreateFeed(
            feedGroupId: feed.group,
            feedId: feed.id,
            getOrCreateFeedRequest: request
        )
        let rawFollowers = response.followers.map { $0.toModel() }
        return GetOrCreateInfo(
            activities: PaginationResult(
                models: response.activities.map { $0.toModel() }.sorted(using: Sort<ActivitiesSortField>.defaultSorting),
                pagination: PaginationData(next: response.next, previous: response.prev)
            ),
            activitiesQueryConfig: QueryConfiguration(
                filter: query.activityFilter,
                sort: Sort<ActivitiesSortField>.defaultSorting
            ),
            feed: response.feed.toModel(),
            followers: rawFollowers.filter { $0.isFollower(of: feed) },
            following: response.following.map { $0.toModel() }.filter { $0.isFollowing(feed) },
            followRequests: rawFollowers.filter(\.isFollowRequest),
            members: PaginationResult(
                models: response.members.map { $0.toModel() },
                pagination: response.memberPagination?.toModel() ?? .empty
            ),
            ownCapabilities: response.ownCapabilities,
            pinnedActivities: response.pinnedActivities.map { $0.toModel() },
            aggregatedActivities: response.aggregatedActivities.map { $0.toModel() },
            notificationStatus: response.notificationStatus
        )
    }
    
    func stopWatching(feedGroupId: String, feedId: String) async throws -> Response {
        try await apiClient.stopWatchingFeed(
            feedGroupId: feedGroupId,
            feedId: feedId
        )
    }
    
    // MARK: - Managing the Feed
    
    func deleteFeed(feedGroupId: String, feedId: String, hardDelete: Bool) async throws {
        _ = try await apiClient.deleteFeed(
            feedGroupId: feedGroupId,
            feedId: feedId,
            hardDelete: hardDelete
        )
    }
    
    func updateFeed(feedGroupId: String, feedId: String, request: UpdateFeedRequest) async throws -> FeedData {
        let response = try await apiClient.updateFeed(feedGroupId: feedGroupId, feedId: feedId, updateFeedRequest: request)
        return response.feed.toModel()
    }
    
    // MARK: - Feed Lists
    
    func queryFeeds(with query: FeedsQuery) async throws -> PaginationResult<FeedData> {
        let response = try await apiClient.queryFeeds(queryFeedsRequest: query.toRequest())
        let feeds = response.feeds.map { $0.toModel() }
        let pagination = PaginationData(next: response.next, previous: response.prev)
        return PaginationResult(models: feeds, pagination: pagination)
    }
    
    // MARK: - Follows
    
    func queryFollowSuggestions(feedGroupId: String, limit: Int?) async throws -> [FeedData] {
        let response = try await apiClient.getFollowSuggestions(feedGroupId: feedGroupId, limit: limit)
        return response.suggestions.map { $0.toModel() }
    }
    
    func queryFollows(request: QueryFollowsRequest) async throws -> PaginationResult<FollowData> {
        let response = try await apiClient.queryFollows(queryFollowsRequest: request)
        let follows = response.follows.map { $0.toModel() }
        let pagination = PaginationData(next: response.next, previous: response.prev)
        return PaginationResult(models: follows, pagination: pagination)
    }
    
    func follow(request: FollowRequest) async throws -> FollowData {
        let response = try await apiClient.follow(followRequest: request)
        return response.follow.toModel()
    }
    
    func unfollow(source: FeedId, target: FeedId) async throws {
        _ = try await apiClient.unfollow(source: source.rawValue, target: target.rawValue)
    }
    
    func acceptFollow(request: AcceptFollowRequest) async throws -> FollowData {
        let response = try await apiClient.acceptFollow(acceptFollowRequest: request)
        return response.follow.toModel()
    }
    
    func rejectFollow(request: RejectFollowRequest) async throws -> FollowData {
        let response = try await apiClient.rejectFollow(rejectFollowRequest: request)
        return response.follow.toModel()
    }
    
    // MARK: - Members
    
    func updateFeedMembers(feedGroupId: String, feedId: String, request: UpdateFeedMembersRequest) async throws -> ModelUpdates<FeedMemberData> {
        let response = try await apiClient.updateFeedMembers(feedGroupId: feedGroupId, feedId: feedId, updateFeedMembersRequest: request)
        return ModelUpdates(
            added: response.added.map { $0.toModel() },
            removedIds: response.removedIds,
            updated: response.updated.map { $0.toModel() }
        )
    }
    
    func acceptFeedMember(feedId: String, feedGroupId: String) async throws -> FeedMemberData {
        let response = try await apiClient.acceptFeedMemberInvite(feedId: feedId, feedGroupId: feedGroupId)
        return response.member.toModel()
    }
    
    func queryFeedMembers(feedGroupId: String, feedId: String, request: QueryFeedMembersRequest) async throws -> QueryFeedMembersResponse {
        try await apiClient.queryFeedMembers(feedGroupId: feedGroupId, feedId: feedId, queryFeedMembersRequest: request)
    }
    
    func rejectFeedMember(feedGroupId: String, feedId: String) async throws -> FeedMemberData {
        let response = try await apiClient.rejectFeedMemberInvite(feedGroupId: feedGroupId, feedId: feedId)
        return response.member.toModel()
    }
}

extension FeedsRepository {
    struct GetOrCreateInfo {
        let activities: PaginationResult<ActivityData>
        let activitiesQueryConfig: QueryConfiguration<ActivitiesFilter, ActivitiesSortField>
        let feed: FeedData
        let followers: [FollowData]
        let following: [FollowData]
        let followRequests: [FollowData]
        let members: PaginationResult<FeedMemberData>
        let ownCapabilities: [FeedOwnCapability]
        let pinnedActivities: [ActivityPinData]
        let aggregatedActivities: [AggregatedActivityData]
        let notificationStatus: NotificationStatusResponse?
    }
}
