//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when activities are marked as read, seen, or watched.
public final class ActivityMarkEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    /// Date/time of creation
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var feedVisibility: String?
    public var fid: String
    /// Whether all activities were marked as read
    public var markAllRead: Bool?
    /// Whether all activities were marked as seen
    public var markAllSeen: Bool?
    /// The IDs of activities marked as read
    public var markRead: [String]?
    /// The IDs of activities marked as seen
    public var markSeen: [String]?
    /// The IDs of activities marked as watched
    public var markWatched: [String]?
    public var receivedAt: Date?
    /// The type of event: "feeds.activity.marked" in this case
    public var type: String = "feeds.activity.marked"
    public var user: UserResponseCommonFields?

    public init(createdAt: Date, custom: [String: RawJSON], feedVisibility: String? = nil, fid: String, markAllRead: Bool? = nil, markAllSeen: Bool? = nil, markRead: [String]? = nil, markSeen: [String]? = nil, markWatched: [String]? = nil, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.markAllRead = markAllRead
        self.markAllSeen = markAllSeen
        self.markRead = markRead
        self.markSeen = markSeen
        self.markWatched = markWatched
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case feedVisibility = "feed_visibility"
        case fid
        case markAllRead = "mark_all_read"
        case markAllSeen = "mark_all_seen"
        case markRead = "mark_read"
        case markSeen = "mark_seen"
        case markWatched = "mark_watched"
        case receivedAt = "received_at"
        case type
        case user
    }
}

extension ActivityMarkEvent: Hashable {
    public static func == (lhs: ActivityMarkEvent, rhs: ActivityMarkEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.markAllRead == rhs.markAllRead &&
            lhs.markAllSeen == rhs.markAllSeen &&
            lhs.markRead == rhs.markRead &&
            lhs.markSeen == rhs.markSeen &&
            lhs.markWatched == rhs.markWatched &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(markAllRead)
        hasher.combine(markAllSeen)
        hasher.combine(markRead)
        hasher.combine(markSeen)
        hasher.combine(markWatched)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
