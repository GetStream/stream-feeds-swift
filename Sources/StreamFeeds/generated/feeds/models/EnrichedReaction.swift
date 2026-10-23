//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class EnrichedReaction: Sendable, Codable, JSONEncodable {
    public let activityId: String
    public let childrenCounts: [String: Int]?
    public let data: [String: RawJSON]?
    public let id: String?
    public let kind: String
    public let latestChildren: [String: [EnrichedReaction]]?
    public let ownChildren: [String: [EnrichedReaction]]?
    public let parent: String?
    public let targetFeeds: [String]?
    public let user: StreamData?
    public let userId: String

    public init(activityId: String, childrenCounts: [String: Int]? = nil, data: [String: RawJSON]? = nil, id: String? = nil, kind: String, latestChildren: [String: [EnrichedReaction]]? = nil, ownChildren: [String: [EnrichedReaction]]? = nil, parent: String? = nil, targetFeeds: [String]? = nil, user: StreamData? = nil, userId: String) {
        self.activityId = activityId
        self.childrenCounts = childrenCounts
        self.data = data
        self.id = id
        self.kind = kind
        self.latestChildren = latestChildren
        self.ownChildren = ownChildren
        self.parent = parent
        self.targetFeeds = targetFeeds
        self.user = user
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activityId = try container.decode(String.self, forKey: .activityId)
        self.childrenCounts = try container.decodeIfPresent([String: Int].self, forKey: .childrenCounts)
        self.data = try container.decodeIfPresent([String: RawJSON].self, forKey: .data)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.kind = try container.decode(String.self, forKey: .kind)
        self.latestChildren = try container.decodeIfPresent([String: [EnrichedReaction]].self, forKey: .latestChildren)
        self.ownChildren = try container.decodeIfPresent([String: [EnrichedReaction]].self, forKey: .ownChildren)
        self.parent = try container.decodeIfPresent(String.self, forKey: .parent)
        self.targetFeeds = try container.decodeIfPresent([String].self, forKey: .targetFeeds)
        self.user = try container.decodeIfPresent(StreamData.self, forKey: .user)
        self.userId = try container.decode(String.self, forKey: .userId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activityId, forKey: .activityId)
        try container.encodeIfPresent(childrenCounts, forKey: .childrenCounts)
        try container.encodeIfPresent(data, forKey: .data)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(kind, forKey: .kind)
        try container.encodeIfPresent(latestChildren, forKey: .latestChildren)
        try container.encodeIfPresent(ownChildren, forKey: .ownChildren)
        try container.encodeIfPresent(parent, forKey: .parent)
        try container.encodeIfPresent(targetFeeds, forKey: .targetFeeds)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encode(userId, forKey: .userId)
    }
}

extension EnrichedReaction: Hashable {
    public static func == (lhs: EnrichedReaction, rhs: EnrichedReaction) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.childrenCounts == rhs.childrenCounts &&
            lhs.data == rhs.data &&
            lhs.id == rhs.id &&
            lhs.kind == rhs.kind &&
            lhs.latestChildren == rhs.latestChildren &&
            lhs.ownChildren == rhs.ownChildren &&
            lhs.parent == rhs.parent &&
            lhs.targetFeeds == rhs.targetFeeds &&
            lhs.user == rhs.user &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(childrenCounts)
        hasher.combine(data)
        hasher.combine(id)
        hasher.combine(kind)
        hasher.combine(latestChildren)
        hasher.combine(ownChildren)
        hasher.combine(parent)
        hasher.combine(targetFeeds)
        hasher.combine(user)
        hasher.combine(userId)
    }
}
