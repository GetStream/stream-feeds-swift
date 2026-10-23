//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationTarget: @unchecked Sendable, Codable, JSONEncodable {
    /// Attachments on the target activity (for activity targets)
    public var attachments: [Attachment]?
    public var comment: NotificationComment?
    /// Custom data from the target activity
    public var custom: [String: RawJSON]?
    /// The ID of the target (activity ID or user ID)
    public var id: String
    /// The name of the target user (for user targets like follows)
    public var name: String?
    public var parentActivity: NotificationParentActivity?
    /// The text content of the target activity (for activity targets)
    public var text: String?
    /// The type of the target activity (for activity targets)
    public var type: String?
    /// The ID of the user who created the target activity (for activity targets)
    public var userId: String?

    public init(
        attachments: [Attachment]? = nil,
        comment: NotificationComment? = nil,
        custom: [String: RawJSON]? = nil,
        id: String,
        name: String? = nil,
        parentActivity: NotificationParentActivity? = nil,
        text: String? = nil,
        userId: String? = nil
    ) {
        self.attachments = attachments
        self.comment = comment
        self.custom = custom
        self.id = id
        self.name = name
        self.parentActivity = parentActivity
        self.text = text
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case comment
        case custom
        case id
        case name
        case parentActivity = "parent_activity"
        case text
        case type
        case userId = "user_id"
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
