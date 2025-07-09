//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryBookmarksResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var bookmarks: [BookmarkResponse]
    public var duration: String
    public var next: String?
    public var prev: String?

    public init(bookmarks: [BookmarkResponse], duration: String, next: String? = nil, prev: String? = nil) {
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
