//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryBookmarkFoldersResponse: Sendable, Decodable {
    /// List of bookmark folders matching the query
    public let bookmarkFolders: [BookmarkFolderResponse]
    public let duration: String
    /// Cursor for next page
    public let next: String?
    /// Cursor for previous page
    public let prev: String?

    public init(bookmarkFolders: [BookmarkFolderResponse], duration: String, next: String? = nil, prev: String? = nil) {
        self.bookmarkFolders = bookmarkFolders
        self.duration = duration
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.bookmarkFolders = try container.decode([BookmarkFolderResponse].self, forKey: .bookmarkFolders)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }
}

extension QueryBookmarkFoldersResponse: Hashable {
    public static func == (lhs: QueryBookmarkFoldersResponse, rhs: QueryBookmarkFoldersResponse) -> Bool {
        lhs.bookmarkFolders == rhs.bookmarkFolders &&
            lhs.duration == rhs.duration &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bookmarkFolders)
        hasher.combine(duration)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
