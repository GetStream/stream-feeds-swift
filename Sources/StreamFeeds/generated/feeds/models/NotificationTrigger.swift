//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationTrigger: Sendable, Decodable {
    /// Human-readable text describing the notification
    public let text: String
    /// The type of notification (mention, reaction, comment, follow, etc.)
    public let type: String

    public init(text: String, type: String) {
        self.text = text
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.type = try container.decode(String.self, forKey: .type)
    }
}

extension NotificationTrigger: Hashable {
    public static func == (lhs: NotificationTrigger, rhs: NotificationTrigger) -> Bool {
        lhs.text == rhs.text &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(type)
    }
}
