//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a user bookmarks an activity.
public final class BookmarkAddedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    public var bookmark: BookmarkResponse
    /// Date/time of creation
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var receivedAt: Date?
    /// The type of event: "feeds.bookmark.added" in this case
    public var type: String = "feeds.bookmark.added"
    public var user: UserResponseCommonFields?

    public init(bookmark: BookmarkResponse, createdAt: Date, custom: [String: RawJSON], receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.bookmark = bookmark
        self.createdAt = createdAt
        self.custom = custom
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case bookmark
        case createdAt = "created_at"
        case custom
        case receivedAt = "received_at"
        case type
        case user
    }
}

extension BookmarkAddedEvent: Hashable {
    public static func == (lhs: BookmarkAddedEvent, rhs: BookmarkAddedEvent) -> Bool {
        lhs.bookmark == rhs.bookmark &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bookmark)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
