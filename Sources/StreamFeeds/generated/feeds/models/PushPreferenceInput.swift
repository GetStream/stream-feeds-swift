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
    /// Remove the user's quiet-hours schedule, the counterpart of remove_disable. It is applied before schedule, so sending both in one item replaces the stored schedule instead of merging into it. Cannot be combined with channel_cid. To switch from a schedule to a snooze, send remove_schedule together with disabled_until.
    public let removeSchedule: Bool?
    /// A recurring quiet-hours schedule: while any quiet window is active, push notifications for the user are suppressed. Suppressed notifications are dropped, not delayed.
    public let schedule: PushScheduleInput?
    /// The user id for which to set the push preferences. Required when using server side auths, defaults to current user with client side auth.
    public let userId: String?

    public init(disabledUntil: Date? = nil, feedsLevel: PushPreferenceInputFeedsLevel? = nil, feedsPreferences: FeedsPreferences? = nil, removeDisable: Bool? = nil, removeSchedule: Bool? = nil, schedule: PushScheduleInput? = nil, userId: String? = nil) {
        self.disabledUntil = disabledUntil
        self.feedsLevel = feedsLevel
        self.feedsPreferences = feedsPreferences
        self.removeDisable = removeDisable
        self.removeSchedule = removeSchedule
        self.schedule = schedule
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.disabledUntil = try container.decodeIfPresent(Date.self, forKey: .disabledUntil)
        self.feedsLevel = try container.decodeIfPresent(PushPreferenceInputFeedsLevel.self, forKey: .feedsLevel)
        self.feedsPreferences = try container.decodeIfPresent(FeedsPreferences.self, forKey: .feedsPreferences)
        self.removeDisable = try container.decodeIfPresent(Bool.self, forKey: .removeDisable)
        self.removeSchedule = try container.decodeIfPresent(Bool.self, forKey: .removeSchedule)
        self.schedule = try container.decodeIfPresent(PushScheduleInput.self, forKey: .schedule)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(disabledUntil, forKey: .disabledUntil)
        try container.encodeIfPresent(feedsLevel, forKey: .feedsLevel)
        try container.encodeIfPresent(feedsPreferences, forKey: .feedsPreferences)
        try container.encodeIfPresent(removeDisable, forKey: .removeDisable)
        try container.encodeIfPresent(removeSchedule, forKey: .removeSchedule)
        try container.encodeIfPresent(schedule, forKey: .schedule)
        try container.encodeIfPresent(userId, forKey: .userId)
    }
}

extension PushPreferenceInput: Hashable {
    public static func == (lhs: PushPreferenceInput, rhs: PushPreferenceInput) -> Bool {
        lhs.disabledUntil == rhs.disabledUntil &&
            lhs.feedsLevel == rhs.feedsLevel &&
            lhs.feedsPreferences == rhs.feedsPreferences &&
            lhs.removeDisable == rhs.removeDisable &&
            lhs.removeSchedule == rhs.removeSchedule &&
            lhs.schedule == rhs.schedule &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(disabledUntil)
        hasher.combine(feedsLevel)
        hasher.combine(feedsPreferences)
        hasher.combine(removeDisable)
        hasher.combine(removeSchedule)
        hasher.combine(schedule)
        hasher.combine(userId)
    }
}
