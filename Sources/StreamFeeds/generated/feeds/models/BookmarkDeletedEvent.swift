//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a user deletes a bookmark from an activity.
public final class BookmarkDeletedEvent: Sendable, Event, Decodable {
    public let bookmark: BookmarkResponse
    /// Date/time of creation
    public let createdAt: Date
    public let custom: [String: RawJSON]
    public let receivedAt: Date?
    /// The type of event: "feeds.bookmark.deleted" in this case
    public let type: String
    public let user: UserResponseCommonFields?

    public init(bookmark: BookmarkResponse, createdAt: Date, custom: [String: RawJSON], receivedAt: Date? = nil, type: String = "feeds.bookmark.deleted", user: UserResponseCommonFields? = nil) {
        self.bookmark = bookmark
        self.createdAt = createdAt
        self.custom = custom
        self.receivedAt = receivedAt
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.bookmark = try container.decode(BookmarkResponse.self, forKey: .bookmark)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decodeIfPresent(UserResponseCommonFields.self, forKey: .user)
    }
}

extension BookmarkDeletedEvent: Hashable {
    public static func == (lhs: BookmarkDeletedEvent, rhs: BookmarkDeletedEvent) -> Bool {
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
