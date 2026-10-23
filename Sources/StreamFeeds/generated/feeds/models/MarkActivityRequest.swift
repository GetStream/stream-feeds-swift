//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class MarkActivityRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Whether to mark all activities as read
    public var markAllRead: Bool?
    /// Whether to mark all activities as seen
    public var markAllSeen: Bool?
    /// List of activity IDs to mark as read
    public var markRead: [String]?
    /// List of activity IDs to mark as seen
    public var markSeen: [String]?
    /// List of activity IDs to mark as watched (for stories)
    public var markWatched: [String]?

    public init(
        markAllRead: Bool? = nil,
        markAllSeen: Bool? = nil,
        markRead: [String]? = nil,
        markSeen: [String]? = nil,
        markWatched: [String]? = nil
    ) {
        self.markAllRead = markAllRead
        self.markAllSeen = markAllSeen
        self.markRead = markRead
        self.markSeen = markSeen
        self.markWatched = markWatched
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case markAllRead = "mark_all_read"
        case markAllSeen = "mark_all_seen"
        case markRead = "mark_read"
        case markSeen = "mark_seen"
        case markWatched = "mark_watched"
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
