//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PushPreferenceInputFeedsLevel: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let `default` = PushPreferenceInputFeedsLevel(rawValue: "default")
    public static let all = PushPreferenceInputFeedsLevel(rawValue: "all")
    public static let none = PushPreferenceInputFeedsLevel(rawValue: "none")
}

public final class PushPreferenceInput: Sendable, Codable, JSONEncodable {
    /// Disable push notifications till a certain time
    public let disabledUntil: Date?
    /// Set the level of feeds push notifications for the user. One of: all, none, default
    public let feedsLevel: PushPreferenceInputFeedsLevel?
    public let feedsPreferences: FeedsPreferences?
    /// Remove the disabled until time. (IE stop snoozing notifications)
    public let removeDisable: Bool?
    /// The user id for which to set the push preferences. Required when using server side auths, defaults to current user with client side auth.
    public let userId: String?

    public init(disabledUntil: Date? = nil, feedsLevel: PushPreferenceInputFeedsLevel? = nil, feedsPreferences: FeedsPreferences? = nil, removeDisable: Bool? = nil, userId: String? = nil) {
        self.disabledUntil = disabledUntil
        self.feedsLevel = feedsLevel
        self.feedsPreferences = feedsPreferences
        self.removeDisable = removeDisable
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.disabledUntil = try container.decodeIfPresent(Date.self, forKey: .disabledUntil)
        self.feedsLevel = try container.decodeIfPresent(PushPreferenceInputFeedsLevel.self, forKey: .feedsLevel)
        self.feedsPreferences = try container.decodeIfPresent(FeedsPreferences.self, forKey: .feedsPreferences)
        self.removeDisable = try container.decodeIfPresent(Bool.self, forKey: .removeDisable)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(disabledUntil, forKey: .disabledUntil)
        try container.encodeIfPresent(feedsLevel, forKey: .feedsLevel)
        try container.encodeIfPresent(feedsPreferences, forKey: .feedsPreferences)
        try container.encodeIfPresent(removeDisable, forKey: .removeDisable)
        try container.encodeIfPresent(userId, forKey: .userId)
    }
}

extension PushPreferenceInput: Hashable {
    public static func == (lhs: PushPreferenceInput, rhs: PushPreferenceInput) -> Bool {
        lhs.disabledUntil == rhs.disabledUntil &&
            lhs.feedsLevel == rhs.feedsLevel &&
            lhs.feedsPreferences == rhs.feedsPreferences &&
            lhs.removeDisable == rhs.removeDisable &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(disabledUntil)
        hasher.combine(feedsLevel)
        hasher.combine(feedsPreferences)
        hasher.combine(removeDisable)
        hasher.combine(userId)
    }
}
