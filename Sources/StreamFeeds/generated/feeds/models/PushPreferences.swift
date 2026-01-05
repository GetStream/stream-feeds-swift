//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PushPreferences: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var callLevel: String?
    public var chatLevel: String?
    public var disabledUntil: Date?
    public var feedsLevel: String?
    public var feedsPreferences: FeedsPreferences?

    public init(callLevel: String? = nil, chatLevel: String? = nil, disabledUntil: Date? = nil, feedsLevel: String? = nil, feedsPreferences: FeedsPreferences? = nil) {
        self.callLevel = callLevel
        self.chatLevel = chatLevel
        self.disabledUntil = disabledUntil
        self.feedsLevel = feedsLevel
        self.feedsPreferences = feedsPreferences
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case callLevel = "call_level"
        case chatLevel = "chat_level"
        case disabledUntil = "disabled_until"
        case feedsLevel = "feeds_level"
        case feedsPreferences = "feeds_preferences"
    }

    public static func == (lhs: PushPreferences, rhs: PushPreferences) -> Bool {
        lhs.callLevel == rhs.callLevel &&
            lhs.chatLevel == rhs.chatLevel &&
            lhs.disabledUntil == rhs.disabledUntil &&
            lhs.feedsLevel == rhs.feedsLevel &&
            lhs.feedsPreferences == rhs.feedsPreferences
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(callLevel)
        hasher.combine(chatLevel)
        hasher.combine(disabledUntil)
        hasher.combine(feedsLevel)
        hasher.combine(feedsPreferences)
    }
}
