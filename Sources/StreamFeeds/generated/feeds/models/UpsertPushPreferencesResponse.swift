//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertPushPreferencesResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// Duration of the request in milliseconds
    public var duration: String
    /// The user preferences, always returned regardless if you edited it
    public var userPreferences: [String: PushPreferencesResponse]

    public init(duration: String, userPreferences: [String: PushPreferencesResponse]) {
        self.duration = duration
        self.userPreferences = userPreferences
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case userPreferences = "user_preferences"
    }
}

extension UpsertPushPreferencesResponse: Hashable {
    public static func == (lhs: UpsertPushPreferencesResponse, rhs: UpsertPushPreferencesResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.userPreferences == rhs.userPreferences
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(userPreferences)
    }
}
