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
    
    func getOrCreateFeed(feedGroupId: String, feedId: String, request: GetOrCreateFeedRequest) async throws -> GetOrCreateInfo {
        let response = try await apiClient.getOrCreateFeed(
            feedGroupId: feedGroupId,
            feedId: feedId,
            getOrCreateFeedRequest: request
        )
        let rawFollowers = response.followers.map(FollowInfo.init(from:))
        return GetOrCreateInfo(
            activities: response.activities.map(ActivityInfo.init(from:)).sorted(by: ActivityInfo.defaultSorting),
            feed: FeedInfo(from: response.feed),
            followers: rawFollowers.filter { $0.isFollower(of: feedId) },
            following: response.following.map(FollowInfo.init(from:)).filter { $0.isFollowing(feedId: feedId) },
            followRequests: rawFollowers.filter(\.isFollowRequest),
            members: response.members,
            ownCapabilities: response.ownCapabilities ?? []
        )
    }
    
    // MARK: - Managing the Feed
    
    func deleteFeed(feedGroupId: String, feedId: String, hardDelete: Bool) async throws {
        _ = try await apiClient.deleteFeed(feedGroupId: feedGroupId, feedId: feedId, hardDelete: hardDelete)
    }
    
    func updateFeed(feedGroupId: String, feedId: String, request: UpdateFeedRequest) async throws -> FeedInfo {
        let response = try await apiClient.updateFeed(feedGroupId: feedGroupId, feedId: feedId, updateFeedRequest: request)
        return FeedInfo(from: response.feed)
    }
    
    // MARK: - Follows
    
    func follow(request: SingleFollowRequest) async throws -> FollowInfo {
        let response = try await apiClient.follow(singleFollowRequest: request)
        return FollowInfo(from: response.follow)
    }
    
    func unfollow(source: String, target: String) async throws {
        _ = try await apiClient.unfollow(source: source, target: target)
    }
    
    func acceptFollow(request: AcceptFollowRequest) async throws -> FollowInfo {
        let response = try await apiClient.acceptFollow(acceptFollowRequest: request)
        return FollowInfo(from: response.follow)
    }
    
    func rejectFollow(request: RejectFollowRequest) async throws -> FollowInfo {
        let response = try await apiClient.rejectFollow(rejectFollowRequest: request)
        return FollowInfo(from: response.follow)
    }
    
    // MARK: - Members
    
    func updateFeedMembers(feedGroupId: String, feedId: String, request: UpdateFeedMembersRequest) async throws {
        _ = try await apiClient.updateFeedMembers(feedGroupId: feedGroupId, feedId: feedId, updateFeedMembersRequest: request)
    }
    
    func acceptFeedMember(feedId: String, feedGroupId: String) async throws -> FeedMemberInfo {
        let response = try await apiClient.acceptFeedMemberInvite(feedId: feedId, feedGroupId: feedGroupId)
        return FeedMemberInfo(from: response.member)
    }
    
    func queryFeedMembers(feedGroupId: String, feedId: String, request: QueryFeedMembersRequest) async throws -> QueryFeedMembersResponse {
        try await apiClient.queryFeedMembers(feedGroupId: feedGroupId, feedId: feedId, queryFeedMembersRequest: request)
    }
    
    func rejectFeedMember(feedGroupId: String, feedId: String) async throws -> FeedMemberInfo {
        let response = try await apiClient.rejectFeedMemberInvite(feedGroupId: feedGroupId, feedId: feedId)
        return FeedMemberInfo(from: response.member)
    }
}

extension FeedsRepository {
    struct GetOrCreateInfo {
        let activities: [ActivityInfo]
        let feed: FeedInfo
        let followers: [FollowInfo]
        let following: [FollowInfo]
        let followRequests: [FollowInfo]
        let members: [FeedMemberResponse]
        let ownCapabilities: [FeedOwnCapability]
    }
}
