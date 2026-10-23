//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationStatusResponse: Sendable, Codable, JSONEncodable {
    /// When notifications were last read
    public let lastReadAt: Date?
    /// When notifications were last seen
    public let lastSeenAt: Date?
    /// Deprecated: use is_read on each activity/group instead. IDs of activities that have been read. Capped at ~101 entries for aggregated feeds.
    public let readActivities: [String]?
    /// Deprecated: use is_seen on each activity/group instead. IDs of activities that have been seen. Capped at ~101 entries for aggregated feeds.
    public let seenActivities: [String]?
    /// Number of unread notifications
    public let unread: Int
    /// Number of unseen notifications
    public let unseen: Int

    public init(lastReadAt: Date? = nil, lastSeenAt: Date? = nil, readActivities: [String]? = nil, seenActivities: [String]? = nil, unread: Int, unseen: Int) {
        self.lastReadAt = lastReadAt
        self.lastSeenAt = lastSeenAt
        self.readActivities = readActivities
        self.seenActivities = seenActivities
        self.unread = unread
        self.unseen = unseen
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.lastReadAt = try container.decodeIfPresent(Date.self, forKey: .lastReadAt)
        self.lastSeenAt = try container.decodeIfPresent(Date.self, forKey: .lastSeenAt)
        self.readActivities = try container.decodeIfPresent([String].self, forKey: .readActivities)
        self.seenActivities = try container.decodeIfPresent([String].self, forKey: .seenActivities)
        self.unread = try container.decode(Int.self, forKey: .unread)
        self.unseen = try container.decode(Int.self, forKey: .unseen)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(lastReadAt, forKey: .lastReadAt)
        try container.encodeIfPresent(lastSeenAt, forKey: .lastSeenAt)
        try container.encodeIfPresent(readActivities, forKey: .readActivities)
        try container.encodeIfPresent(seenActivities, forKey: .seenActivities)
        try container.encode(unread, forKey: .unread)
        try container.encode(unseen, forKey: .unseen)
    }
}

extension NotificationStatusResponse: Hashable {
    public static func == (lhs: NotificationStatusResponse, rhs: NotificationStatusResponse) -> Bool {
        lhs.lastReadAt == rhs.lastReadAt &&
            lhs.lastSeenAt == rhs.lastSeenAt &&
            lhs.readActivities == rhs.readActivities &&
            lhs.seenActivities == rhs.seenActivities &&
            lhs.unread == rhs.unread &&
            lhs.unseen == rhs.unseen
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(lastReadAt)
        hasher.combine(lastSeenAt)
        hasher.combine(readActivities)
        hasher.combine(seenActivities)
        hasher.combine(unread)
        hasher.combine(unseen)
    }
}
