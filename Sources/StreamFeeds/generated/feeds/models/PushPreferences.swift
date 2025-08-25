//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PushPreferences: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var callLevel: String?
    public var chatLevel: String?
    public var disabledUntil: Date?
    public var feedsEvents: FeedsEventPreferences?
    public var feedsLevel: String?

    public init(callLevel: String? = nil, chatLevel: String? = nil, disabledUntil: Date? = nil, feedsEvents: FeedsEventPreferences? = nil, feedsLevel: String? = nil) {
        self.callLevel = callLevel
        self.chatLevel = chatLevel
        self.disabledUntil = disabledUntil
        self.feedsEvents = feedsEvents
        self.feedsLevel = feedsLevel
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case callLevel = "call_level"
        case chatLevel = "chat_level"
        case disabledUntil = "disabled_until"
        case feedsEvents = "feeds_events"
        case feedsLevel = "feeds_level"
    }

    public static func == (lhs: PushPreferences, rhs: PushPreferences) -> Bool {
        lhs.callLevel == rhs.callLevel &&
            lhs.chatLevel == rhs.chatLevel &&
            lhs.disabledUntil == rhs.disabledUntil &&
            lhs.feedsEvents == rhs.feedsEvents &&
            lhs.feedsLevel == rhs.feedsLevel
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(callLevel)
        hasher.combine(chatLevel)
        hasher.combine(disabledUntil)
        hasher.combine(feedsEvents)
        hasher.combine(feedsLevel)
    }
}
