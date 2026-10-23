//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a feed group is deleted.
public final class FeedGroupDeletedEvent: Sendable, Event, Codable, JSONEncodable {
    /// Date/time of creation
    public let createdAt: Date
    public let custom: [String: RawJSON]
    public let feedVisibility: String?
    public let fid: String
    /// The ID of the feed group that was deleted
    public let groupId: String
    public let receivedAt: Date?
    /// The type of event: "feeds.feed_group.deleted" in this case
    public let type: String

    public init(createdAt: Date, custom: [String: RawJSON], feedVisibility: String? = nil, fid: String, groupId: String, receivedAt: Date? = nil, type: String = "feeds.feed_group.deleted") {
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.groupId = groupId
        self.receivedAt = receivedAt
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.feedVisibility = try container.decodeIfPresent(String.self, forKey: .feedVisibility)
        self.fid = try container.decode(String.self, forKey: .fid)
        self.groupId = try container.decode(String.self, forKey: .groupId)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(custom, forKey: .custom)
        try container.encodeIfPresent(feedVisibility, forKey: .feedVisibility)
        try container.encode(fid, forKey: .fid)
        try container.encode(groupId, forKey: .groupId)
        try container.encodeIfPresent(receivedAt, forKey: .receivedAt)
        try container.encode(type, forKey: .type)
    }
}

extension FeedGroupDeletedEvent: Hashable {
    public static func == (lhs: FeedGroupDeletedEvent, rhs: FeedGroupDeletedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.groupId == rhs.groupId &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(groupId)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
}
