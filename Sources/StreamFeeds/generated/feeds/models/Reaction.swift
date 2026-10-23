//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Reaction: @unchecked Sendable, Codable, JSONEncodable {
    public var activityId: String
    public var childrenCounts: [String: RawJSON]?
    public var createdAt: Date
    public var data: [String: RawJSON]?
    public var deletedAt: Date?
    public var id: String?
    public var kind: String
    public var latestChildren: [String: [Reaction]]?
    public var moderation: [String: RawJSON]?
    public var ownChildren: [String: [Reaction]]?
    public var parent: String?
    public var score: Float?
    public var targetFeeds: [String]?
    public var targetFeedsExtraData: [String: RawJSON]?
    public var updatedAt: Date
    public var user: User?
    public var userId: String

    public init(
        activityId: String,
        childrenCounts: [String: RawJSON]? = nil,
        createdAt: Date,
        data: [String: RawJSON]? = nil,
        deletedAt: Date? = nil,
        id: String? = nil,
        kind: String,
        latestChildren: [String: [Reaction]]? = nil,
        moderation: [String: RawJSON]? = nil,
        ownChildren: [String: [Reaction]]? = nil,
        parent: String? = nil,
        score: Float? = nil,
        targetFeeds: [String]? = nil,
        targetFeedsExtraData: [String: RawJSON]? = nil,
        updatedAt: Date,
        user: User? = nil,
        userId: String
    ) {
        self.activityId = activityId
        self.childrenCounts = childrenCounts
        self.createdAt = createdAt
        self.data = data
        self.deletedAt = deletedAt
        self.id = id
        self.kind = kind
        self.latestChildren = latestChildren
        self.moderation = moderation
        self.ownChildren = ownChildren
        self.parent = parent
        self.score = score
        self.targetFeeds = targetFeeds
        self.targetFeedsExtraData = targetFeedsExtraData
        self.updatedAt = updatedAt
        self.user = user
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityId = "activity_id"
        case childrenCounts = "children_counts"
        case createdAt = "created_at"
        case data
        case deletedAt = "deleted_at"
        case id
        case kind
        case latestChildren = "latest_children"
        case moderation
        case ownChildren = "own_children"
        case parent
        case score
        case targetFeeds = "target_feeds"
        case targetFeedsExtraData = "target_feeds_extra_data"
        case updatedAt = "updated_at"
        case user
        case userId = "user_id"
    }
}

extension Reaction: Hashable {
    public static func == (lhs: Reaction, rhs: Reaction) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.childrenCounts == rhs.childrenCounts &&
            lhs.createdAt == rhs.createdAt &&
            lhs.data == rhs.data &&
            lhs.deletedAt == rhs.deletedAt &&
            lhs.id == rhs.id &&
            lhs.kind == rhs.kind &&
            lhs.latestChildren == rhs.latestChildren &&
            lhs.moderation == rhs.moderation &&
            lhs.ownChildren == rhs.ownChildren &&
            lhs.parent == rhs.parent &&
            lhs.score == rhs.score &&
            lhs.targetFeeds == rhs.targetFeeds &&
            lhs.targetFeedsExtraData == rhs.targetFeedsExtraData &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(childrenCounts)
        hasher.combine(createdAt)
        hasher.combine(data)
        hasher.combine(deletedAt)
        hasher.combine(id)
        hasher.combine(kind)
        hasher.combine(latestChildren)
        hasher.combine(moderation)
        hasher.combine(ownChildren)
        hasher.combine(parent)
        hasher.combine(score)
        hasher.combine(targetFeeds)
        hasher.combine(targetFeedsExtraData)
        hasher.combine(updatedAt)
        hasher.combine(user)
        hasher.combine(userId)
    }
}
