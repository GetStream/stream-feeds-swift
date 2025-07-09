//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class MarkActivityRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var markAllRead: Bool?
    public var markAllSeen: Bool?
    public var markRead: [String]?
    public var markWatched: [String]?

    public init(markAllRead: Bool? = nil, markAllSeen: Bool? = nil, markRead: [String]? = nil, markWatched: [String]? = nil) {
        self.markAllRead = markAllRead
        self.markAllSeen = markAllSeen
        self.markRead = markRead
        self.markWatched = markWatched
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case markAllRead = "mark_all_read"
        case markAllSeen = "mark_all_seen"
        case markRead = "mark_read"
        case markWatched = "mark_watched"
    }

    public static func == (lhs: MarkActivityRequest, rhs: MarkActivityRequest) -> Bool {
        lhs.markAllRead == rhs.markAllRead &&
            lhs.markAllSeen == rhs.markAllSeen &&
            lhs.markRead == rhs.markRead &&
            lhs.markWatched == rhs.markWatched
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(markAllRead)
        hasher.combine(markAllSeen)
        hasher.combine(markRead)
        hasher.combine(markWatched)
    }
}
