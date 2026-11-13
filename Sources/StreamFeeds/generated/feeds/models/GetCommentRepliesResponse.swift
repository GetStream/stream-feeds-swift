//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetCommentRepliesResponse: Sendable, Decodable {
    /// Threaded listing of replies to the comment
    public let comments: [ThreadedCommentResponse]
    public let next: String?
    public let prev: String?

    public init(comments: [ThreadedCommentResponse], next: String? = nil, prev: String? = nil) {
        self.comments = comments
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comments = try container.decode([ThreadedCommentResponse].self, forKey: .comments)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }
}

extension GetCommentRepliesResponse: Hashable {
    public static func == (lhs: GetCommentRepliesResponse, rhs: GetCommentRepliesResponse) -> Bool {
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
