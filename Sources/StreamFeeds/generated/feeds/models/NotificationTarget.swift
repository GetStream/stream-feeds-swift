//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationTarget: @unchecked Sendable, Codable, JSONEncodable {
    /// Attachments on the target activity (for activity targets)
    public var attachments: [Attachment]?
    /// The ID of the target (activity ID or user ID)
    public var id: String
    /// The name of the target user (for user targets like follows)
    public var name: String?
    /// The text content of the target activity (for activity targets)
    public var text: String?
    /// The type of the target activity (for activity targets)
    public var type: String?
    /// The ID of the user who created the target activity (for activity targets)
    public var userId: String?

    public init(attachments: [Attachment]? = nil, id: String, name: String? = nil, text: String? = nil, userId: String? = nil) {
        self.attachments = attachments
        self.id = id
        self.name = name
        self.text = text
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case id
        case name
        case text
        case type
        case userId = "user_id"
    }
}

extension NotificationTarget: Hashable {
    public static func == (lhs: NotificationTarget, rhs: NotificationTarget) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.text == rhs.text &&
            lhs.type == rhs.type &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(text)
        hasher.combine(type)
        hasher.combine(userId)
    }
}
