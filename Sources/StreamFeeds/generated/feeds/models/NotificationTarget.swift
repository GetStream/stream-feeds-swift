//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationTarget: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var attachments: [Attachment]?
    public var id: String
    public var name: String?
    public var text: String?
    public var type: String?
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
