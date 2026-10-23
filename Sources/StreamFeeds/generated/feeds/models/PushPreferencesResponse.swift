//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// The push preference details.
public final class PushPreferencesResponse: Sendable, Codable, JSONEncodable {
    /// If provided the notifications will be disabled until the set date.
    public let disabledUntil: Date?
    public let feedsLevel: String?
    public let feedsPreferences: FeedsPreferencesResponse?
    /// A recurring quiet-hours schedule: while any quiet window is active, push notifications for the user are suppressed. Suppressed notifications are dropped, not delayed.
    public let schedule: PushScheduleResponse?

    public init(disabledUntil: Date? = nil, feedsLevel: String? = nil, feedsPreferences: FeedsPreferencesResponse? = nil, schedule: PushScheduleResponse? = nil) {
        self.disabledUntil = disabledUntil
        self.feedsLevel = feedsLevel
        self.feedsPreferences = feedsPreferences
        self.schedule = schedule
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.disabledUntil = try container.decodeIfPresent(Date.self, forKey: .disabledUntil)
        self.feedsLevel = try container.decodeIfPresent(String.self, forKey: .feedsLevel)
        self.feedsPreferences = try container.decodeIfPresent(FeedsPreferencesResponse.self, forKey: .feedsPreferences)
        self.schedule = try container.decodeIfPresent(PushScheduleResponse.self, forKey: .schedule)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(disabledUntil, forKey: .disabledUntil)
        try container.encodeIfPresent(feedsLevel, forKey: .feedsLevel)
        try container.encodeIfPresent(feedsPreferences, forKey: .feedsPreferences)
        try container.encodeIfPresent(schedule, forKey: .schedule)
    }
}

extension PushPreferencesResponse: Hashable {
    public static func == (lhs: PushPreferencesResponse, rhs: PushPreferencesResponse) -> Bool {
        lhs.disabledUntil == rhs.disabledUntil &&
            lhs.feedsLevel == rhs.feedsLevel &&
            lhs.feedsPreferences == rhs.feedsPreferences &&
            lhs.schedule == rhs.schedule
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(disabledUntil)
        hasher.combine(feedsLevel)
        hasher.combine(feedsPreferences)
        hasher.combine(schedule)
    }
}
