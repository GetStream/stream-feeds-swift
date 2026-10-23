//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class MarkActivityRequest: Sendable, Codable, JSONEncodable {
    /// Whether to mark all activities as read
    public let markAllRead: Bool?
    /// Whether to mark all activities as seen
    public let markAllSeen: Bool?
    /// List of activity IDs to mark as read
    public let markRead: [String]?
    /// List of activity IDs to mark as seen
    public let markSeen: [String]?
    /// List of activity IDs to mark as watched (for stories)
    public let markWatched: [String]?

    public init(markAllRead: Bool? = nil, markAllSeen: Bool? = nil, markRead: [String]? = nil, markSeen: [String]? = nil, markWatched: [String]? = nil) {
        self.markAllRead = markAllRead
        self.markAllSeen = markAllSeen
        self.markRead = markRead
        self.markSeen = markSeen
        self.markWatched = markWatched
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.markAllRead = try container.decodeIfPresent(Bool.self, forKey: .markAllRead)
        self.markAllSeen = try container.decodeIfPresent(Bool.self, forKey: .markAllSeen)
        self.markRead = try container.decodeIfPresent([String].self, forKey: .markRead)
        self.markSeen = try container.decodeIfPresent([String].self, forKey: .markSeen)
        self.markWatched = try container.decodeIfPresent([String].self, forKey: .markWatched)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(markAllRead, forKey: .markAllRead)
        try container.encodeIfPresent(markAllSeen, forKey: .markAllSeen)
        try container.encodeIfPresent(markRead, forKey: .markRead)
        try container.encodeIfPresent(markSeen, forKey: .markSeen)
        try container.encodeIfPresent(markWatched, forKey: .markWatched)
    }
}

extension MarkActivityRequest: Hashable {
    public static func == (lhs: MarkActivityRequest, rhs: MarkActivityRequest) -> Bool {
        lhs.markAllRead == rhs.markAllRead &&
            lhs.markAllSeen == rhs.markAllSeen &&
            lhs.markRead == rhs.markRead &&
            lhs.markSeen == rhs.markSeen &&
            lhs.markWatched == rhs.markWatched
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(markAllRead)
        hasher.combine(markAllSeen)
        hasher.combine(markRead)
        hasher.combine(markSeen)
        hasher.combine(markWatched)
    }
}
