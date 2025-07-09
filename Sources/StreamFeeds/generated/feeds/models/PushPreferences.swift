//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PushPreferences: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var callLevel: String?
    public var chatLevel: String?
    public var disabledUntil: Date?

    public init(callLevel: String? = nil, chatLevel: String? = nil, disabledUntil: Date? = nil) {
        self.callLevel = callLevel
        self.chatLevel = chatLevel
        self.disabledUntil = disabledUntil
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case callLevel = "call_level"
        case chatLevel = "chat_level"
        case disabledUntil = "disabled_until"
    }

    public static func == (lhs: PushPreferences, rhs: PushPreferences) -> Bool {
        lhs.callLevel == rhs.callLevel &&
            lhs.chatLevel == rhs.chatLevel &&
            lhs.disabledUntil == rhs.disabledUntil
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(callLevel)
        hasher.combine(chatLevel)
        hasher.combine(disabledUntil)
    }
}
