//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PinActivityResponse: Sendable, Codable, JSONEncodable {
    public let activity: ActivityResponse
    /// When the activity was pinned
    public let createdAt: Date
    public let duration: String
    /// Fully qualified ID of the feed the activity was pinned to
    public let feed: String
    /// ID of the user who pinned the activity
    public let userId: String

    public init(activity: ActivityResponse, createdAt: Date, duration: String, feed: String, userId: String) {
        self.activity = activity
        self.createdAt = createdAt
        self.duration = duration
        self.feed = feed
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.feed = try container.decode(String.self, forKey: .feed)
        self.userId = try container.decode(String.self, forKey: .userId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activity, forKey: .activity)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(duration, forKey: .duration)
        try container.encode(feed, forKey: .feed)
        try container.encode(userId, forKey: .userId)
    }
}

extension PinActivityResponse: Hashable {
    public static func == (lhs: PinActivityResponse, rhs: PinActivityResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.createdAt == rhs.createdAt &&
            lhs.duration == rhs.duration &&
            lhs.feed == rhs.feed &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(createdAt)
        hasher.combine(duration)
        hasher.combine(feed)
        hasher.combine(userId)
    }
}
