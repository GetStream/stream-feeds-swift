//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationTrigger: @unchecked Sendable, Codable, JSONEncodable {
    /// Human-readable text describing the notification
    public var text: String
    /// The type of notification (mention, reaction, comment, follow, etc.)
    public var type: String

    public init(text: String, type: String) {
        self.text = text
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case text
        case type
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
