//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when comment feedback is provided.
public final class CommentFeedbackEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    public var commentFeedback: CommentFeedbackEventPayload
    /// Date/time of creation
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var receivedAt: Date?
    /// The type of event: "feeds.comment.feedback" in this case
    public var type: String = "feeds.comment.feedback"
    public var user: UserResponseCommonFields?

    public init(
        commentFeedback: CommentFeedbackEventPayload,
        createdAt: Date,
        custom: [String: RawJSON],
        receivedAt: Date? = nil,
        user: UserResponseCommonFields? = nil
    ) {
        self.commentFeedback = commentFeedback
        self.createdAt = createdAt
        self.custom = custom
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case commentFeedback = "comment_feedback"
        case createdAt = "created_at"
        case custom
        case receivedAt = "received_at"
        case type
        case user
    }
}

extension CommentFeedbackEvent: Hashable {
    public static func == (lhs: CommentFeedbackEvent, rhs: CommentFeedbackEvent) -> Bool {
        lhs.commentFeedback == rhs.commentFeedback &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(commentFeedback)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
