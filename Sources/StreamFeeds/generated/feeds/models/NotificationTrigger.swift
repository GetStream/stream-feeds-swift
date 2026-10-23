//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationTrigger: @unchecked Sendable, Codable, JSONEncodable {
    public var comment: NotificationComment?
    /// Custom data from the trigger object (comment, reaction, etc.)
    public var custom: [String: RawJSON]?
    /// Human-readable text describing the notification
    public var text: String
    /// The type of notification (mention, reaction, comment, follow, etc.)
    public var type: String

    public init(
        comment: NotificationComment? = nil,
        custom: [String: RawJSON]? = nil,
        text: String,
        type: String
    ) {
        self.comment = comment
        self.custom = custom
        self.text = text
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case comment
        case custom
        case text
        case type
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
