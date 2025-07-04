//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FeedData: Identifiable, Sendable {
    public let createdAt: Date
    public let createdBy: UserData
    public let custom: [String: RawJSON]?
    public let deletedAt: Date?
    public let fid: FeedId
    public let followerCount: Int
    public let followingCount: Int
    public let groupId: String
    public let id: String
    public let memberCount: Int
    public let pinCount: Int
    public let pinnedActivities: [ActivityPinData]
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
            fid: FeedId(rawValue: fid),
            followerCount: followerCount,
            followingCount: followingCount,
            groupId: groupId,
            id: id,
            memberCount: memberCount,
            pinCount: pinCount,
            pinnedActivities: [], // TODO: missing from codegen?
            updatedAt: updatedAt,
            visibility: visibility
        )
    }
}
