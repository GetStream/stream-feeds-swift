//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertPushPreferencesRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// A list of push preferences for channels, calls, or the user.
    public var preferences: [PushPreferenceInput]

    public init(preferences: [PushPreferenceInput]) {
        self.preferences = preferences
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case preferences
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
