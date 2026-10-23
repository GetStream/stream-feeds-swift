//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UnpinActivityResponse: Sendable, Codable, JSONEncodable {
    public let activity: ActivityResponse
    public let duration: String
    /// Fully qualified ID of the feed the activity was unpinned from
    public let feed: String
    /// ID of the user who unpinned the activity
    public let userId: String

    public init(activity: ActivityResponse, duration: String, feed: String, userId: String) {
        self.activity = activity
        self.duration = duration
        self.feed = feed
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.feed = try container.decode(String.self, forKey: .feed)
        self.userId = try container.decode(String.self, forKey: .userId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activity, forKey: .activity)
        try container.encode(duration, forKey: .duration)
        try container.encode(feed, forKey: .feed)
        try container.encode(userId, forKey: .userId)
    }
}

extension UnpinActivityResponse: Hashable {
    public static func == (lhs: UnpinActivityResponse, rhs: UnpinActivityResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.duration == rhs.duration &&
            lhs.feed == rhs.feed &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(duration)
        hasher.combine(feed)
        hasher.combine(userId)
    }
}
