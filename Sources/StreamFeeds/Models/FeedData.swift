//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FeedData: Identifiable, Equatable, Sendable {
    public let createdAt: Date
    public let createdBy: UserData
    public let custom: [String: RawJSON]?
    public let deletedAt: Date?
    public let description: String
    public let feed: FeedId
    public let filterTags: [String]?
    public let followerCount: Int
    public let followingCount: Int
    public let groupId: String
    public let id: String
    public let memberCount: Int
    public let name: String
    public let ownCapabilities: [FeedOwnCapability]?
    public let ownFollows: [FollowData]?
    public let ownMembership: FeedMemberData?
    public let pinCount: Int
    public let updatedAt: Date
    public let visibility: String?
}

// MARK: - Model Conversions

extension FeedResponse {
    func toModel() -> FeedData {
        FeedData(
            createdAt: createdAt,
            createdBy: createdBy.toModel(),
            custom: custom,
            deletedAt: deletedAt,
            description: description,
            feed: FeedId(rawValue: feed),
            filterTags: filterTags,
            followerCount: followerCount,
            followingCount: followingCount,
            groupId: groupId,
            id: id,
            memberCount: memberCount,
            name: name,
            ownCapabilities: ownCapabilities,
            ownFollows: ownFollows?.map { $0.toModel() },
            ownMembership: ownMembership?.toModel(),
            pinCount: pinCount,
            updatedAt: updatedAt,
            visibility: visibility
        )
    }
}
