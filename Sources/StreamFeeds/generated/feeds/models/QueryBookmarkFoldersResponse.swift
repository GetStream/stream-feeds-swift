//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryBookmarkFoldersResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var bookmarkFolders: [BookmarkFolderResponse]
    public var duration: String
    public var next: String?
    public var prev: String?

    public init(bookmarkFolders: [BookmarkFolderResponse], duration: String, next: String? = nil, prev: String? = nil) {
        self.bookmarkFolders = bookmarkFolders
        self.duration = duration
        self.next = next
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case bookmarkFolders = "bookmark_folders"
        case duration
        case next
        case prev
    }

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
