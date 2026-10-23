//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetCommentsResponse: Sendable, Codable, JSONEncodable {
    /// Total number of comments on the object, including replies at every depth
    public let commentCount: Int
    /// Threaded listing for the activity
    public let comments: [ThreadedCommentResponse]
    public let duration: String
    public let next: String?
    public let prev: String?
    /// Sort order used for the comments (first, last, top, best, controversial)
    public let sort: String
    /// Number of comments directly on the object, excluding replies. Independent of depth, replies_limit and id_around, and not adjusted per viewer. Only present when include_top_level_comment_count is set
    public let topLevelCommentCount: Int?

    public init(commentCount: Int, comments: [ThreadedCommentResponse], duration: String, next: String? = nil, prev: String? = nil, sort: String, topLevelCommentCount: Int? = nil) {
        self.commentCount = commentCount
        self.comments = comments
        self.duration = duration
        self.next = next
        self.prev = prev
        self.sort = sort
        self.topLevelCommentCount = topLevelCommentCount
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.commentCount = try container.decode(Int.self, forKey: .commentCount)
        self.comments = try container.decode([ThreadedCommentResponse].self, forKey: .comments)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
        self.sort = try container.decode(String.self, forKey: .sort)
        self.topLevelCommentCount = try container.decodeIfPresent(Int.self, forKey: .topLevelCommentCount)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(commentCount, forKey: .commentCount)
        try container.encode(comments, forKey: .comments)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
        try container.encode(sort, forKey: .sort)
        try container.encodeIfPresent(topLevelCommentCount, forKey: .topLevelCommentCount)
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
