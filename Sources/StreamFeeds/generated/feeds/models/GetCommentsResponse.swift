//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetCommentsResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// Threaded listing for the activity
    public var comments: [ThreadedCommentResponse]
    public var duration: String
    public var next: String?
    public var prev: String?

    public init(comments: [ThreadedCommentResponse], duration: String, next: String? = nil, prev: String? = nil) {
        self.comments = comments
        self.duration = duration
        self.next = next
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comments
        case duration
        case next
        case prev
    }
}

extension GetCommentsResponse: Hashable {
    public static func == (lhs: GetCommentsResponse, rhs: GetCommentsResponse) -> Bool {
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
