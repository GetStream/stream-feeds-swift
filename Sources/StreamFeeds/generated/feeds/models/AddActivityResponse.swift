//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AddActivityResponse: Sendable, Codable, JSONEncodable {
    public let activity: ActivityResponse
    public let duration: String
    /// Number of mention notification activities created for mentioned users
    public let mentionNotificationsCreated: Int?

    public init(activity: ActivityResponse, duration: String, mentionNotificationsCreated: Int? = nil) {
        self.activity = activity
        self.duration = duration
        self.mentionNotificationsCreated = mentionNotificationsCreated
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.mentionNotificationsCreated = try container.decodeIfPresent(Int.self, forKey: .mentionNotificationsCreated)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activity, forKey: .activity)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(mentionNotificationsCreated, forKey: .mentionNotificationsCreated)
    }
}

extension AddActivityResponse: Hashable {
    public static func == (lhs: AddActivityResponse, rhs: AddActivityResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.duration == rhs.duration &&
            lhs.mentionNotificationsCreated == rhs.mentionNotificationsCreated
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(duration)
        hasher.combine(mentionNotificationsCreated)
    }
}
