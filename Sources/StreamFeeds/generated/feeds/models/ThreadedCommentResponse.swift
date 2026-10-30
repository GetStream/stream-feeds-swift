//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A comment with an optional, depth‑limited slice of nested replies.
public final class ThreadedCommentResponse: Sendable, Decodable {
    public let comment: CommentResponse
    /// Cursor & depth information for a comment's direct replies. Mirrors Reddit's 'load more replies' semantics.
    public let meta: RepliesMeta?
    /// Slice of nested comments (may be empty).
    public let replies: [ThreadedCommentResponse]?

    public init(comment: CommentResponse, meta: RepliesMeta? = nil, replies: [ThreadedCommentResponse]? = nil) {
        self.comment = comment
        self.meta = meta
        self.replies = replies
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comment = try CommentResponse(from: decoder)
        self.meta = try container.decodeIfPresent(RepliesMeta.self, forKey: .meta)
        self.replies = try container.decodeIfPresent([ThreadedCommentResponse].self, forKey: .replies)
    }
}

extension ThreadedCommentResponse: Hashable {
    public static func == (lhs: ThreadedCommentResponse, rhs: ThreadedCommentResponse) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.meta == rhs.meta &&
            lhs.replies == rhs.replies
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(meta)
        hasher.combine(replies)
    }
}
