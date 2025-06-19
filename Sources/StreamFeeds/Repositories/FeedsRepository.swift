//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

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
        try await getOrCreateFeed(fid: query.fid, request: query.toRequest())
    }
    
    private func getOrCreateFeed(fid: FeedId, request: GetOrCreateFeedRequest) async throws -> GetOrCreateInfo {
        let response = try await apiClient.getOrCreateFeed(
            feedGroupId: fid.groupId,
            feedId: fid.id,
            getOrCreateFeedRequest: request
        )
        let rawFollowers = response.followers.map { $0.toModel() }
        return GetOrCreateInfo(
            activities: response.activities.map { $0.toModel() }.sorted(by: ActivityData.defaultSorting),
            activitiesPagination: PaginationData(next: response.next, previous: response.prev),
            activitiesQueryConfig: QueryConfiguration(
                filter: request.filter?.toQueryFilter(),
                sort: [Sort(field: .createdAt, direction: .forward)]
            ),
            feed: response.feed.toModel(),
            followers: rawFollowers.filter { $0.isFollower(of: fid) },
            following: response.following.map { $0.toModel() }.filter { $0.isFollowing(fid) },
            followRequests: rawFollowers.filter(\.isFollowRequest),
            members: response.members.map { $0.toModel() },
            ownCapabilities: response.ownCapabilities
        )
    }
    
    // MARK: - Managing the Feed
    
    func deleteFeed(feedGroupId: String, feedId: String, hardDelete: Bool) async throws {
        _ = try await apiClient.deleteFeed(feedGroupId: feedGroupId, feedId: feedId, hardDelete: hardDelete)
    }
    
    func updateFeed(feedGroupId: String, feedId: String, request: UpdateFeedRequest) async throws -> FeedData {
        let response = try await apiClient.updateFeed(feedGroupId: feedGroupId, feedId: feedId, updateFeedRequest: request)
        return response.feed.toModel()
    }
    
    // MARK: - Follows
    
    func queryFollowSuggestions(feedGroupId: String, limit: Int?) async throws -> [FeedData] {
        let response = try await apiClient.getFollowSuggestions(feedGroupId: feedGroupId, limit: limit)
        return response.suggestions.map { $0.toModel() }
    }
    
    func follow(request: SingleFollowRequest) async throws -> FollowData {
        let response = try await apiClient.follow(singleFollowRequest: request)
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
    
    func updateFeedMembers(feedGroupId: String, feedId: String, request: UpdateFeedMembersRequest) async throws {
        _ = try await apiClient.updateFeedMembers(feedGroupId: feedGroupId, feedId: feedId, updateFeedMembersRequest: request)
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
        let activities: [ActivityData]
        let activitiesPagination: PaginationData
        let activitiesQueryConfig: QueryConfiguration<ActivityFilter, ActivitiesSortField>
        let feed: FeedData
        let followers: [FollowData]
        let following: [FollowData]
        let followRequests: [FollowData]
        let members: [FeedMemberData]
        let ownCapabilities: [FeedOwnCapability]
    }
}
