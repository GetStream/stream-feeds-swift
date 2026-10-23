//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationParentActivity: @unchecked Sendable, Codable, JSONEncodable {
    public var attachments: [Attachment]?
    public var id: String
    public var text: String?
    public var type: String?
    public var userId: String?

    public init(
        attachments: [Attachment]? = nil,
        id: String,
        text: String? = nil,
        userId: String? = nil
    ) {
        self.attachments = attachments
        self.id = id
        self.text = text
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case id
        case text
        case type
        case userId = "user_id"
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
