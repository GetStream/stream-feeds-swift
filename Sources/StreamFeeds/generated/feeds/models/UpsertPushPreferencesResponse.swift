//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertPushPreferencesResponse: Sendable, Decodable {
    /// Duration of the request in milliseconds
    public let duration: String
    /// The user preferences, always returned regardless if you edited it
    public let userPreferences: [String: PushPreferencesResponse]

    public init(duration: String, userPreferences: [String: PushPreferencesResponse]) {
        self.duration = duration
        self.userPreferences = userPreferences
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.userPreferences = try container.decode([String: PushPreferencesResponse].self, forKey: .userPreferences)
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
