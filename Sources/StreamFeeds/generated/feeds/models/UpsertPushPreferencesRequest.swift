//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertPushPreferencesRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var preferences: [PushPreferenceInput]

    public init(preferences: [PushPreferenceInput]) {
        self.preferences = preferences
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case preferences
    }

    public static func == (lhs: UpsertPushPreferencesRequest, rhs: UpsertPushPreferencesRequest) -> Bool {
        lhs.preferences == rhs.preferences
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(preferences)
    }
}
