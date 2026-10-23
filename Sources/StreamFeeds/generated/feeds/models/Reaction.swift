//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class Reaction: Sendable, Codable, JSONEncodable {
    public let activityId: String
    public let childrenCounts: [String: RawJSON]?
    public let createdAt: Date
    public let data: [String: RawJSON]?
    public let deletedAt: Date?
    public let id: String?
    public let kind: String
    public let latestChildren: [String: [Reaction]]?
    public let moderation: [String: RawJSON]?
    public let ownChildren: [String: [Reaction]]?
    public let parent: String?
    public let score: Double?
    public let targetFeeds: [String]?
    public let targetFeedsExtraData: [String: RawJSON]?
    public let updatedAt: Date
    public let user: User?
    public let userId: String

    public init(activityId: String, childrenCounts: [String: RawJSON]? = nil, createdAt: Date, data: [String: RawJSON]? = nil, deletedAt: Date? = nil, id: String? = nil, kind: String, latestChildren: [String: [Reaction]]? = nil, moderation: [String: RawJSON]? = nil, ownChildren: [String: [Reaction]]? = nil, parent: String? = nil, score: Double? = nil, targetFeeds: [String]? = nil, targetFeedsExtraData: [String: RawJSON]? = nil, updatedAt: Date, user: User? = nil, userId: String) {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activityId = try container.decode(String.self, forKey: .activityId)
        self.childrenCounts = try container.decodeIfPresent([String: RawJSON].self, forKey: .childrenCounts)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.data = try container.decodeIfPresent([String: RawJSON].self, forKey: .data)
        self.deletedAt = try container.decodeIfPresent(Date.self, forKey: .deletedAt)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.kind = try container.decode(String.self, forKey: .kind)
        self.latestChildren = try container.decodeIfPresent([String: [Reaction]].self, forKey: .latestChildren)
        self.moderation = try container.decodeIfPresent([String: RawJSON].self, forKey: .moderation)
        self.ownChildren = try container.decodeIfPresent([String: [Reaction]].self, forKey: .ownChildren)
        self.parent = try container.decodeIfPresent(String.self, forKey: .parent)
        self.score = try container.decodeIfPresent(Double.self, forKey: .score)
        self.targetFeeds = try container.decodeIfPresent([String].self, forKey: .targetFeeds)
        self.targetFeedsExtraData = try container.decodeIfPresent([String: RawJSON].self, forKey: .targetFeedsExtraData)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decodeIfPresent(User.self, forKey: .user)
        self.userId = try container.decode(String.self, forKey: .userId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activityId, forKey: .activityId)
        try container.encodeIfPresent(childrenCounts, forKey: .childrenCounts)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(data, forKey: .data)
        try container.encodeIfPresent(deletedAt, forKey: .deletedAt)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(kind, forKey: .kind)
        try container.encodeIfPresent(latestChildren, forKey: .latestChildren)
        try container.encodeIfPresent(moderation, forKey: .moderation)
        try container.encodeIfPresent(ownChildren, forKey: .ownChildren)
        try container.encodeIfPresent(parent, forKey: .parent)
        try container.encodeIfPresent(score, forKey: .score)
        try container.encodeIfPresent(targetFeeds, forKey: .targetFeeds)
        try container.encodeIfPresent(targetFeedsExtraData, forKey: .targetFeedsExtraData)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encode(userId, forKey: .userId)
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
