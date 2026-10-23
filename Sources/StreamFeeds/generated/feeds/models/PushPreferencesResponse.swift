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

    public init(disabledUntil: Date? = nil, feedsLevel: String? = nil, feedsPreferences: FeedsPreferencesResponse? = nil) {
        self.disabledUntil = disabledUntil
        self.feedsLevel = feedsLevel
        self.feedsPreferences = feedsPreferences
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case disabledUntil = "disabled_until"
        case feedsLevel = "feeds_level"
        case feedsPreferences = "feeds_preferences"
    }
}

extension PushPreferencesResponse: Hashable {
    public static func == (lhs: PushPreferencesResponse, rhs: PushPreferencesResponse) -> Bool {
        lhs.disabledUntil == rhs.disabledUntil &&
            lhs.feedsLevel == rhs.feedsLevel &&
            lhs.feedsPreferences == rhs.feedsPreferences
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(disabledUntil)
        hasher.combine(feedsLevel)
        hasher.combine(feedsPreferences)
    }
}
