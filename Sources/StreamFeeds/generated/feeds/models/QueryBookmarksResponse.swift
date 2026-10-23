//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryBookmarksResponse: Sendable, Codable, JSONEncodable {
    /// List of bookmarks matching the query
    public let bookmarks: [BookmarkResponse]
    public let duration: String
    /// Cursor for next page
    public let next: String?
    /// Cursor for previous page
    public let prev: String?

    public init(bookmarks: [BookmarkResponse], duration: String, next: String? = nil, prev: String? = nil) {
        self.bookmarks = bookmarks
        self.duration = duration
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.bookmarks = try container.decode([BookmarkResponse].self, forKey: .bookmarks)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(bookmarks, forKey: .bookmarks)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
    }
}

extension QueryBookmarksResponse: Hashable {
    public static func == (lhs: QueryBookmarksResponse, rhs: QueryBookmarksResponse) -> Bool {
        lhs.bookmarks == rhs.bookmarks &&
            lhs.duration == rhs.duration &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bookmarks)
        hasher.combine(duration)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
