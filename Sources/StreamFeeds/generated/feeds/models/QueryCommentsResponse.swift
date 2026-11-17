//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryCommentsResponse: Sendable, Decodable {
    /// List of comments matching the query
    public let comments: [CommentResponse]
    /// Cursor for next page
    public let next: String?
    /// Cursor for previous page
    public let prev: String?

    public init(comments: [CommentResponse], next: String? = nil, prev: String? = nil) {
        self.comments = comments
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comments = try container.decode([CommentResponse].self, forKey: .comments)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }
}

extension QueryCommentsResponse: Hashable {
    public static func == (lhs: QueryCommentsResponse, rhs: QueryCommentsResponse) -> Bool {
        lhs.comments == rhs.comments &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comments)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
