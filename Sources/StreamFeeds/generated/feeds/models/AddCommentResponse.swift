//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var comment: CommentResponse
    public var duration: String
    /// Number of mention notification activities created for mentioned users
    public var mentionNotificationsCreated: Int?
    /// Whether a notification activity was successfully created
    public var notificationCreated: Bool?

    public init(comment: CommentResponse, duration: String, mentionNotificationsCreated: Int? = nil, notificationCreated: Bool? = nil) {
        self.comment = comment
        self.duration = duration
        self.mentionNotificationsCreated = mentionNotificationsCreated
        self.notificationCreated = notificationCreated
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comment
        case duration
        case mentionNotificationsCreated = "mention_notifications_created"
        case notificationCreated = "notification_created"
    }
}

extension AddCommentResponse: Hashable {
    public static func == (lhs: AddCommentResponse, rhs: AddCommentResponse) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.duration == rhs.duration &&
            lhs.mentionNotificationsCreated == rhs.mentionNotificationsCreated &&
            lhs.notificationCreated == rhs.notificationCreated
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(duration)
        hasher.combine(mentionNotificationsCreated)
        hasher.combine(notificationCreated)
    }
}
