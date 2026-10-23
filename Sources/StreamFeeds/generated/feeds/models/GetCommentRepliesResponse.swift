//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetCommentRepliesResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// Threaded listing of replies to the comment
    public var comments: [ThreadedCommentResponse]
    public var duration: String
    public var next: String?
    public var prev: String?
    /// Sort order used for the replies (first, last, top, best, controversial)
    public var sort: String

    public init(
        comments: [ThreadedCommentResponse],
        duration: String,
        next: String? = nil,
        prev: String? = nil,
        sort: String
    ) {
        self.comments = comments
        self.duration = duration
        self.next = next
        self.prev = prev
        self.sort = sort
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comments
        case duration
        case next
        case prev
        case sort
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
