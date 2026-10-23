//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CommentFeedbackEventPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// The comment that received feedback
    public var commentId: String
    /// When the feedback was created
    public var createdAt: Date
    /// Whether the comment is hidden for the user
    public var hide: Bool
    /// When the feedback was last updated
    public var updatedAt: Date
    /// User response object
    public var user: UserResponse

    public init(commentId: String, createdAt: Date, hide: Bool, updatedAt: Date, user: UserResponse) {
        self.commentId = commentId
        self.createdAt = createdAt
        self.hide = hide
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case commentId = "comment_id"
        case createdAt = "created_at"
        case hide
        case updatedAt = "updated_at"
        case user
    }
}

extension CommentFeedbackEventPayload: Hashable {
    public static func == (lhs: CommentFeedbackEventPayload, rhs: CommentFeedbackEventPayload) -> Bool {
        lhs.commentId == rhs.commentId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.hide == rhs.hide &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(commentId)
        hasher.combine(createdAt)
        hasher.combine(hide)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
