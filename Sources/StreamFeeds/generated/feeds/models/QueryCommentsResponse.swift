//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryCommentsResponse: Sendable, Codable, JSONEncodable {
    /// List of comments matching the query
    public let comments: [CommentResponse]
    public let duration: String
    /// Cursor for next page
    public let next: String?
    /// Cursor for previous page
    public let prev: String?

    public init(comments: [CommentResponse], duration: String, next: String? = nil, prev: String? = nil) {
        self.comments = comments
        self.duration = duration
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comments = try container.decode([CommentResponse].self, forKey: .comments)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(comments, forKey: .comments)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
    }
}

extension QueryCommentsResponse: Hashable {
    public static func == (lhs: QueryCommentsResponse, rhs: QueryCommentsResponse) -> Bool {
        lhs.comments == rhs.comments &&
            lhs.duration == rhs.duration &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comments)
        hasher.combine(duration)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
