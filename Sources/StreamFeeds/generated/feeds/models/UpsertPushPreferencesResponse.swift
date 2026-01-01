//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertPushPreferencesResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var userChannelPreferences: [String: [String: ChannelPushPreferences?]]
    public var userPreferences: [String: PushPreferences?]

    public init(duration: String, userChannelPreferences: [String: [String: ChannelPushPreferences?]], userPreferences: [String: PushPreferences?]) {
        self.duration = duration
        self.userChannelPreferences = userChannelPreferences
        self.userPreferences = userPreferences
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case userChannelPreferences = "user_channel_preferences"
        case userPreferences = "user_preferences"
    }

    public static func == (lhs: UpsertPushPreferencesResponse, rhs: UpsertPushPreferencesResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.userChannelPreferences == rhs.userChannelPreferences &&
            lhs.userPreferences == rhs.userPreferences
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(userChannelPreferences)
        hasher.combine(userPreferences)
    }
}
