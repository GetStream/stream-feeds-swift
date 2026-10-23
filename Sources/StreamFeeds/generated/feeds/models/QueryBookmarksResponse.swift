//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryBookmarksResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// List of bookmarks matching the query
    public var bookmarks: [BookmarkResponse]
    public var duration: String
    /// Cursor for next page
    public var next: String?
    /// Cursor for previous page
    public var prev: String?

    public init(
        bookmarks: [BookmarkResponse],
        duration: String,
        next: String? = nil,
        prev: String? = nil
    ) {
        self.bookmarks = bookmarks
        self.duration = duration
        self.next = next
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case bookmarks
        case duration
        case next
        case prev
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
