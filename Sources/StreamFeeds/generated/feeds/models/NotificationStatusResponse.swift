//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationStatusResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var lastReadAt: Date?
    public var lastSeenAt: Date?
    public var readActivities: [String]?
    public var seenActivities: [String]?
    public var unread: Int
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
