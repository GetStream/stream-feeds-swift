//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationTarget: Sendable, Decodable {
    /// Attachments on the target activity (for activity targets)
    public let attachments: [Attachment]?
    /// The ID of the target (activity ID or user ID)
    public let id: String
    /// The name of the target user (for user targets like follows)
    public let name: String?
    /// The text content of the target activity (for activity targets)
    public let text: String?
    /// The type of the target activity (for activity targets)
    public let type: String?
    /// The ID of the user who created the target activity (for activity targets)
    public let userId: String?

    public init(attachments: [Attachment]? = nil, id: String, name: String? = nil, text: String? = nil, type: String? = nil, userId: String? = nil) {
        self.attachments = attachments
        self.id = id
        self.name = name
        self.text = text
        self.type = type
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
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
