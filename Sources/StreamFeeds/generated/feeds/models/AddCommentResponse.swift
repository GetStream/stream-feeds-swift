//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddCommentResponse: Sendable, Codable, JSONEncodable {
    public let comment: CommentResponse
    public let duration: String
    /// Number of mention notification activities created for mentioned users
    public let mentionNotificationsCreated: Int?
    /// Whether a notification activity was successfully created
    public let notificationCreated: Bool?

    public init(comment: CommentResponse, duration: String, mentionNotificationsCreated: Int? = nil, notificationCreated: Bool? = nil) {
        self.comment = comment
        self.duration = duration
        self.mentionNotificationsCreated = mentionNotificationsCreated
        self.notificationCreated = notificationCreated
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comment = try container.decode(CommentResponse.self, forKey: .comment)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.mentionNotificationsCreated = try container.decodeIfPresent(Int.self, forKey: .mentionNotificationsCreated)
        self.notificationCreated = try container.decodeIfPresent(Bool.self, forKey: .notificationCreated)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(comment, forKey: .comment)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(mentionNotificationsCreated, forKey: .mentionNotificationsCreated)
        try container.encodeIfPresent(notificationCreated, forKey: .notificationCreated)
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
