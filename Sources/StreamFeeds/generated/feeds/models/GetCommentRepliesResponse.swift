//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetCommentRepliesResponse: Sendable, Decodable {
    /// Threaded listing of replies to the comment
    public let comments: [ThreadedCommentResponse]
    public let duration: String
    public let next: String?
    public let prev: String?

    public init(comments: [ThreadedCommentResponse], duration: String, next: String? = nil, prev: String? = nil) {
        self.comments = comments
        self.duration = duration
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comments = try container.decode([ThreadedCommentResponse].self, forKey: .comments)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }
}

extension GetCommentRepliesResponse: Hashable {
    public static func == (lhs: GetCommentRepliesResponse, rhs: GetCommentRepliesResponse) -> Bool {
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
