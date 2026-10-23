//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationTrigger: Sendable, Codable, JSONEncodable {
    public let comment: NotificationComment?
    /// Custom data from the trigger object (comment, reaction, etc.)
    public let custom: [String: RawJSON]?
    /// Human-readable text describing the notification
    public let text: String
    /// The type of notification (mention, reaction, comment, follow, etc.)
    public let type: String

    public init(comment: NotificationComment? = nil, custom: [String: RawJSON]? = nil, text: String, type: String) {
        self.comment = comment
        self.custom = custom
        self.text = text
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.comment = try container.decodeIfPresent(NotificationComment.self, forKey: .comment)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.text = try container.decode(String.self, forKey: .text)
        self.type = try container.decode(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(comment, forKey: .comment)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encode(text, forKey: .text)
        try container.encode(type, forKey: .type)
    }
}

extension NotificationTrigger: Hashable {
    public static func == (lhs: NotificationTrigger, rhs: NotificationTrigger) -> Bool {
        lhs.comment == rhs.comment &&
            lhs.custom == rhs.custom &&
            lhs.text == rhs.text &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(comment)
        hasher.combine(custom)
        hasher.combine(text)
        hasher.combine(type)
    }
}
