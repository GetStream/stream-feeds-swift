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
        let activities = response.activities.map { $0.toModel() }
        let pinnedActivities = response.pinnedActivities.map { $0.toModel() }
        let ownCapabilities = response.feed.ownCapabilities.map(Set.init) ?? Set()
        let allOwnCapabilities = (activities + pinnedActivities.map(\.activity))
            .reduce(into: [feed: ownCapabilities], { all, activityData in
                guard let currentFeed = activityData.currentFeed else { return }
                guard let capabilities = currentFeed.ownCapabilities, !capabilities.isEmpty else { return }
                all[currentFeed.feed] = capabilities
            })
        return GetOrCreateInfo(
            activities: PaginationResult(
                models: activities.sorted(using: Sort<ActivitiesSortField>.defaultSorting),
                pagination: PaginationData(next: response.next, previous: response.prev)
            ),
            activitiesQueryConfig: QueryConfiguration(
                filter: query.activityFilter,
                sort: Sort<ActivitiesSortField>.defaultSorting
            ),
            aggregatedActivities: response.aggregatedActivities.map { $0.toModel() },
            allOwnCapabilities: allOwnCapabilities,
            feed: response.feed.toModel(),
            followRequests: rawFollowers.filter(\.isFollowRequest),
            followers: rawFollowers.filter { $0.isFollower(of: feed) },
            following: response.following.map { $0.toModel() }.filter { $0.isFollowing(feed) },
            members: PaginationResult(
                models: response.members.map { $0.toModel() },
                pagination: response.memberPagination?.toModel() ?? .empty
            ),
            notificationStatus: response.notificationStatus?.toModel(),
            ownCapabilities: ownCapabilities,
            pinnedActivities: pinnedActivities
        )
    }
    
    func stopWatching(feedGroupId: String, feedId: String) async throws {
        _ = try await apiClient.stopWatchingFeed(
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
    
    func unfollow(source: FeedId, target: FeedId) async throws -> FollowData {
        let response = try await apiClient.unfollow(source: source.rawValue, target: target.rawValue)
        return response.follow.toModel()
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
        let aggregatedActivities: [AggregatedActivityData]
        let allOwnCapabilities: [FeedId: Set<FeedOwnCapability>]
        let feed: FeedData
        let followRequests: [FollowData]
        let followers: [FollowData]
        let following: [FollowData]
        let members: PaginationResult<FeedMemberData>
        let notificationStatus: NotificationStatusData?
        let ownCapabilities: Set<FeedOwnCapability>
        let pinnedActivities: [ActivityPinData]
    }
}
