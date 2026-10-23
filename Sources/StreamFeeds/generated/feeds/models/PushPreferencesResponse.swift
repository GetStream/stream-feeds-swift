//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// The push preference details.
public final class PushPreferencesResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// If provided the notifications will be disabled until the set date.
    public var disabledUntil: Date?
    public var feedsLevel: String?
    public var feedsPreferences: FeedsPreferencesResponse?
    /// A recurring quiet-hours schedule: while any quiet window is active, push notifications for the user are suppressed. Suppressed notifications are dropped, not delayed.
    public var schedule: PushScheduleResponse?

    public init(
        disabledUntil: Date? = nil,
        feedsLevel: String? = nil,
        feedsPreferences: FeedsPreferencesResponse? = nil,
        schedule: PushScheduleResponse? = nil
    ) {
        self.disabledUntil = disabledUntil
        self.feedsLevel = feedsLevel
        self.feedsPreferences = feedsPreferences
        self.schedule = schedule
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case disabledUntil = "disabled_until"
        case feedsLevel = "feeds_level"
        case feedsPreferences = "feeds_preferences"
        case schedule
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
