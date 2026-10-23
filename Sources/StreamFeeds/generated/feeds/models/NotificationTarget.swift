//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationTarget: Sendable, Codable, JSONEncodable {
    /// Attachments on the target activity (for activity targets)
    public let attachments: [Attachment]?
    public let comment: NotificationComment?
    /// Custom data from the target activity
    public let custom: [String: RawJSON]?
    /// The ID of the target (activity ID or user ID)
    public let id: String
    /// The name of the target user (for user targets like follows)
    public let name: String?
    public let parentActivity: NotificationParentActivity?
    /// The text content of the target activity (for activity targets)
    public let text: String?
    /// The type of the target activity (for activity targets)
    public let type: String?
    /// The ID of the user who created the target activity (for activity targets)
    public let userId: String?

    public init(attachments: [Attachment]? = nil, comment: NotificationComment? = nil, custom: [String: RawJSON]? = nil, id: String, name: String? = nil, parentActivity: NotificationParentActivity? = nil, text: String? = nil, type: String? = nil, userId: String? = nil) {
        self.attachments = attachments
        self.comment = comment
        self.custom = custom
        self.id = id
        self.name = name
        self.parentActivity = parentActivity
        self.text = text
        self.type = type
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)
        self.comment = try container.decodeIfPresent(NotificationComment.self, forKey: .comment)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.parentActivity = try container.decodeIfPresent(NotificationParentActivity.self, forKey: .parentActivity)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encodeIfPresent(comment, forKey: .comment)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(parentActivity, forKey: .parentActivity)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(userId, forKey: .userId)
    }
}

extension NotificationTarget: Hashable {
    public static func == (lhs: NotificationTarget, rhs: NotificationTarget) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.comment == rhs.comment &&
            lhs.custom == rhs.custom &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.parentActivity == rhs.parentActivity &&
            lhs.text == rhs.text &&
            lhs.type == rhs.type &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(comment)
        hasher.combine(custom)
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(parentActivity)
        hasher.combine(text)
        hasher.combine(type)
        hasher.combine(userId)
    }
}
