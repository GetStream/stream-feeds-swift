//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ChannelPushPreferences: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var chatLevel: String?
    public var disabledUntil: Date?

    public init(chatLevel: String? = nil, disabledUntil: Date? = nil) {
        self.chatLevel = chatLevel
        self.disabledUntil = disabledUntil
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case chatLevel = "chat_level"
        case disabledUntil = "disabled_until"
    }

    public static func == (lhs: ChannelPushPreferences, rhs: ChannelPushPreferences) -> Bool {
        lhs.chatLevel == rhs.chatLevel &&
            lhs.disabledUntil == rhs.disabledUntil
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(chatLevel)
        hasher.combine(disabledUntil)
    }
}
