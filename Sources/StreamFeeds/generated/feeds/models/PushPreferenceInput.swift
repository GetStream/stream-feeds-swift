//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PushPreferenceInput: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum PushPreferenceInputCallLevel: String, Sendable, Codable, CaseIterable {
        case all
        case `default`
        case none
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }
    
    public enum PushPreferenceInputChatLevel: String, Sendable, Codable, CaseIterable {
        case all
        case `default`
        case mentions
        case none
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }
    
    public enum PushPreferenceInputFeedsLevel: String, Sendable, Codable, CaseIterable {
        case all
        case `default`
        case none
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var callLevel: PushPreferenceInputCallLevel?
    public var channelCid: String?
    public var chatLevel: PushPreferenceInputChatLevel?
    public var disabledUntil: Date?
    public var feedsLevel: PushPreferenceInputFeedsLevel?
    public var feedsPreferences: FeedsPreferences?
    public var removeDisable: Bool?
    public var userId: String?

    public init(callLevel: PushPreferenceInputCallLevel? = nil, channelCid: String? = nil, chatLevel: PushPreferenceInputChatLevel? = nil, disabledUntil: Date? = nil, feedsLevel: PushPreferenceInputFeedsLevel? = nil, feedsPreferences: FeedsPreferences? = nil, removeDisable: Bool? = nil, userId: String? = nil) {
        self.callLevel = callLevel
        self.channelCid = channelCid
        self.chatLevel = chatLevel
        self.disabledUntil = disabledUntil
        self.feedsLevel = feedsLevel
        self.feedsPreferences = feedsPreferences
        self.removeDisable = removeDisable
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case callLevel = "call_level"
        case channelCid = "channel_cid"
        case chatLevel = "chat_level"
        case disabledUntil = "disabled_until"
        case feedsLevel = "feeds_level"
        case feedsPreferences = "feeds_preferences"
        case removeDisable = "remove_disable"
        case userId = "user_id"
    }

    public static func == (lhs: PushPreferenceInput, rhs: PushPreferenceInput) -> Bool {
        lhs.callLevel == rhs.callLevel &&
            lhs.channelCid == rhs.channelCid &&
            lhs.chatLevel == rhs.chatLevel &&
            lhs.disabledUntil == rhs.disabledUntil &&
            lhs.feedsLevel == rhs.feedsLevel &&
            lhs.feedsPreferences == rhs.feedsPreferences &&
            lhs.removeDisable == rhs.removeDisable &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(callLevel)
        hasher.combine(channelCid)
        hasher.combine(chatLevel)
        hasher.combine(disabledUntil)
        hasher.combine(feedsLevel)
        hasher.combine(feedsPreferences)
        hasher.combine(removeDisable)
        hasher.combine(userId)
    }
}
