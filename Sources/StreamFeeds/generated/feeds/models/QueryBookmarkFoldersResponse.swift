//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryBookmarkFoldersResponse: Sendable, Decodable {
    /// List of bookmark folders matching the query
    public let bookmarkFolders: [BookmarkFolderResponse]
    /// Cursor for next page
    public let next: String?
    /// Cursor for previous page
    public let prev: String?

    public init(bookmarkFolders: [BookmarkFolderResponse], next: String? = nil, prev: String? = nil) {
        self.bookmarkFolders = bookmarkFolders
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.bookmarkFolders = try container.decode([BookmarkFolderResponse].self, forKey: .bookmarkFolders)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }
}

extension QueryBookmarkFoldersResponse: Hashable {
    public static func == (lhs: QueryBookmarkFoldersResponse, rhs: QueryBookmarkFoldersResponse) -> Bool {
        lhs.bookmarkFolders == rhs.bookmarkFolders &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bookmarkFolders)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
