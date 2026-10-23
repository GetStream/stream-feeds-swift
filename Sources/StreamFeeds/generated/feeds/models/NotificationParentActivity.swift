//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationParentActivity: Sendable, Codable, JSONEncodable {
    public let attachments: [Attachment]?
    public let id: String
    public let text: String?
    public let type: String?
    public let userId: String?

    public init(attachments: [Attachment]? = nil, id: String, text: String? = nil, type: String? = nil, userId: String? = nil) {
        self.attachments = attachments
        self.id = id
        self.text = text
        self.type = type
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)
        self.id = try container.decode(String.self, forKey: .id)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(userId, forKey: .userId)
    }
}

extension NotificationParentActivity: Hashable {
    public static func == (lhs: NotificationParentActivity, rhs: NotificationParentActivity) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.id == rhs.id &&
            lhs.text == rhs.text &&
            lhs.type == rhs.type &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(id)
        hasher.combine(text)
        hasher.combine(type)
        hasher.combine(userId)
    }
}
