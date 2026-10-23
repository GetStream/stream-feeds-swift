//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetCommentRepliesResponse: Sendable, Codable, JSONEncodable {
    /// Threaded listing of replies to the comment
    public let comments: [ThreadedCommentResponse]
    public let duration: String
    public let next: String?
    public let prev: String?
    /// Sort order used for the replies (first, last, top, best, controversial)
    public let sort: String

    public init(comments: [ThreadedCommentResponse], duration: String, next: String? = nil, prev: String? = nil, sort: String) {
        self.comments = comments
        self.duration = duration
        self.next = next
        self.prev = prev
        self.sort = sort
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comments = try container.decode([ThreadedCommentResponse].self, forKey: .comments)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
        self.sort = try container.decode(String.self, forKey: .sort)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(comments, forKey: .comments)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
        try container.encode(sort, forKey: .sort)
    }
}

extension GetCommentRepliesResponse: Hashable {
    public static func == (lhs: GetCommentRepliesResponse, rhs: GetCommentRepliesResponse) -> Bool {
        lhs.comments == rhs.comments &&
            lhs.duration == rhs.duration &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.sort == rhs.sort
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comments)
        hasher.combine(duration)
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(sort)
    }
}
