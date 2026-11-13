//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryBookmarksResponse: Sendable, Decodable {
    /// List of bookmarks matching the query
    public let bookmarks: [BookmarkResponse]
    /// Cursor for next page
    public let next: String?
    /// Cursor for previous page
    public let prev: String?

    public init(bookmarks: [BookmarkResponse], next: String? = nil, prev: String? = nil) {
        self.bookmarks = bookmarks
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.bookmarks = try container.decode([BookmarkResponse].self, forKey: .bookmarks)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }
}

extension QueryBookmarksResponse: Hashable {
    public static func == (lhs: QueryBookmarksResponse, rhs: QueryBookmarksResponse) -> Bool {
        lhs.bookmarks == rhs.bookmarks &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bookmarks)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
