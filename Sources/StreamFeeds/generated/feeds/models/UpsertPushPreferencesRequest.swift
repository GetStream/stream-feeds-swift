//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertPushPreferencesRequest: Sendable, Encodable, JSONEncodable {
    /// A list of push preferences for channels, calls, or the user.
    public let preferences: [PushPreferenceInput]

    public init(preferences: [PushPreferenceInput]) {
        self.preferences = preferences
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(preferences, forKey: .preferences)
    }
}

extension UpsertPushPreferencesRequest: Hashable {
    public static func == (lhs: UpsertPushPreferencesRequest, rhs: UpsertPushPreferencesRequest) -> Bool {
        lhs.preferences == rhs.preferences
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(preferences)
    }
}
