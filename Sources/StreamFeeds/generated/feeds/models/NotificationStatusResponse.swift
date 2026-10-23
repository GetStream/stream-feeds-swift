//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationStatusResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// When notifications were last read
    public var lastReadAt: Date?
    /// When notifications were last seen
    public var lastSeenAt: Date?
    /// Deprecated: use is_read on each activity/group instead. IDs of activities that have been read. Capped at ~101 entries for aggregated feeds.
    public var readActivities: [String]?
    /// Deprecated: use is_seen on each activity/group instead. IDs of activities that have been seen. Capped at ~101 entries for aggregated feeds.
    public var seenActivities: [String]?
    /// Number of unread notifications
    public var unread: Int
    /// Number of unseen notifications
    public var unseen: Int

    public init(lastReadAt: Date? = nil, lastSeenAt: Date? = nil, readActivities: [String]? = nil, seenActivities: [String]? = nil, unread: Int, unseen: Int) {
        self.lastReadAt = lastReadAt
        self.lastSeenAt = lastSeenAt
        self.readActivities = readActivities
        self.seenActivities = seenActivities
        self.unread = unread
        self.unseen = unseen
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case lastReadAt = "last_read_at"
        case lastSeenAt = "last_seen_at"
        case readActivities = "read_activities"
        case seenActivities = "seen_activities"
        case unread
        case unseen
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
