//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CommentFeedbackEventPayload: Sendable, Decodable {
    /// The comment that received feedback
    public let commentId: String
    /// When the feedback was created
    public let createdAt: Date
    /// Whether the comment is hidden for the user
    public let hide: Bool
    /// When the feedback was last updated
    public let updatedAt: Date
    /// User response object
    public let user: UserResponse

    public init(commentId: String, createdAt: Date, hide: Bool, updatedAt: Date, user: UserResponse) {
        self.commentId = commentId
        self.createdAt = createdAt
        self.hide = hide
        self.updatedAt = updatedAt
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.commentId = try container.decode(String.self, forKey: .commentId)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.hide = try container.decode(Bool.self, forKey: .hide)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decode(UserResponse.self, forKey: .user)
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
