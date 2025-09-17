//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationTrigger: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var text: String
    public var type: String

    public init(text: String, type: String) {
        self.text = text
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case text
        case type
    }

    public static func == (lhs: NotificationTrigger, rhs: NotificationTrigger) -> Bool {
        lhs.text == rhs.text &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(type)
    }
}
