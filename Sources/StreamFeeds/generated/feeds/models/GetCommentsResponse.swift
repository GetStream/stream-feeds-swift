//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetCommentsResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// Total number of comments on the object, including replies at every depth
    public var commentCount: Int
    /// Threaded listing for the activity
    public var comments: [ThreadedCommentResponse]
    public var duration: String
    public var next: String?
    public var prev: String?
    /// Sort order used for the comments (first, last, top, best, controversial)
    public var sort: String
    /// Number of comments directly on the object, excluding replies. Independent of depth, replies_limit and id_around, and not adjusted per viewer. Only present when include_top_level_comment_count is set
    public var topLevelCommentCount: Int?

    public init(commentCount: Int, comments: [ThreadedCommentResponse], duration: String, next: String? = nil, prev: String? = nil, sort: String, topLevelCommentCount: Int? = nil) {
        self.commentCount = commentCount
        self.comments = comments
        self.duration = duration
        self.next = next
        self.prev = prev
        self.sort = sort
        self.topLevelCommentCount = topLevelCommentCount
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case commentCount = "comment_count"
        case comments
        case duration
        case next
        case prev
        case sort
        case topLevelCommentCount = "top_level_comment_count"
    }
}

extension GetCommentsResponse: Hashable {
    public static func == (lhs: GetCommentsResponse, rhs: GetCommentsResponse) -> Bool {
        lhs.commentCount == rhs.commentCount &&
            lhs.comments == rhs.comments &&
            lhs.duration == rhs.duration &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.sort == rhs.sort &&
            lhs.topLevelCommentCount == rhs.topLevelCommentCount
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(commentCount)
        hasher.combine(comments)
        hasher.combine(duration)
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(sort)
        hasher.combine(topLevelCommentCount)
    }
}
