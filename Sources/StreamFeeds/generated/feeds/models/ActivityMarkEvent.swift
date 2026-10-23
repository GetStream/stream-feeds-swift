//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when activities are marked as read, seen, or watched.
public final class ActivityMarkEvent: Sendable, Event, Decodable {
    /// Date/time of creation
    public let createdAt: Date
    public let custom: [String: RawJSON]
    public let feedVisibility: String?
    public let fid: String
    /// Whether all activities were marked as read
    public let markAllRead: Bool?
    /// Whether all activities were marked as seen
    public let markAllSeen: Bool?
    /// The IDs of activities marked as read
    public let markRead: [String]?
    /// The IDs of activities marked as seen
    public let markSeen: [String]?
    /// The IDs of activities marked as watched
    public let markWatched: [String]?
    public let receivedAt: Date?
    /// The type of event: "feeds.activity.marked" in this case
    public let type: String
    public let user: UserResponseCommonFields?

    public init(createdAt: Date, custom: [String: RawJSON], feedVisibility: String? = nil, fid: String, markAllRead: Bool? = nil, markAllSeen: Bool? = nil, markRead: [String]? = nil, markSeen: [String]? = nil, markWatched: [String]? = nil, receivedAt: Date? = nil, type: String = "feeds.activity.marked", user: UserResponseCommonFields? = nil) {
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
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.feedVisibility = try container.decodeIfPresent(String.self, forKey: .feedVisibility)
        self.fid = try container.decode(String.self, forKey: .fid)
        self.markAllRead = try container.decodeIfPresent(Bool.self, forKey: .markAllRead)
        self.markAllSeen = try container.decodeIfPresent(Bool.self, forKey: .markAllSeen)
        self.markRead = try container.decodeIfPresent([String].self, forKey: .markRead)
        self.markSeen = try container.decodeIfPresent([String].self, forKey: .markSeen)
        self.markWatched = try container.decodeIfPresent([String].self, forKey: .markWatched)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decodeIfPresent(UserResponseCommonFields.self, forKey: .user)
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
