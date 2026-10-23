//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PushPreferenceInput: @unchecked Sendable, Codable, JSONEncodable {
    public enum PushPreferenceInputFeedsLevel: String, Sendable, Codable, CaseIterable {
        case `default`
        case all
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

    /// Disable push notifications till a certain time
    public var disabledUntil: Date?
    /// Set the level of feeds push notifications for the user. One of: all, none, default
    public var feedsLevel: PushPreferenceInputFeedsLevel?
    public var feedsPreferences: FeedsPreferences?
    /// Remove the disabled until time. (IE stop snoozing notifications)
    public var removeDisable: Bool?
    /// The user id for which to set the push preferences. Required when using server side auths, defaults to current user with client side auth.
    public var userId: String?

    public init(disabledUntil: Date? = nil, feedsLevel: PushPreferenceInputFeedsLevel? = nil, feedsPreferences: FeedsPreferences? = nil, removeDisable: Bool? = nil, userId: String? = nil) {
        self.disabledUntil = disabledUntil
        self.feedsLevel = feedsLevel
        self.feedsPreferences = feedsPreferences
        self.removeDisable = removeDisable
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case disabledUntil = "disabled_until"
        case feedsLevel = "feeds_level"
        case feedsPreferences = "feeds_preferences"
        case removeDisable = "remove_disable"
        case userId = "user_id"
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
