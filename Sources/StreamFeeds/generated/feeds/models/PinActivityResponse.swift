//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PinActivityResponse: Sendable, Decodable {
    public let activity: ActivityResponse
    /// When the activity was pinned
    public let createdAt: Date
    /// Fully qualified ID of the feed the activity was pinned to
    public let feed: String
    /// ID of the user who pinned the activity
    public let userId: String

    public init(activity: ActivityResponse, createdAt: Date, feed: String, userId: String) {
        self.activity = activity
        self.createdAt = createdAt
        self.feed = feed
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.feed = try container.decode(String.self, forKey: .feed)
        self.userId = try container.decode(String.self, forKey: .userId)
    }
}

extension PinActivityResponse: Hashable {
    public static func == (lhs: PinActivityResponse, rhs: PinActivityResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.createdAt == rhs.createdAt &&
            lhs.feed == rhs.feed &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(createdAt)
        hasher.combine(feed)
        hasher.combine(userId)
    }
}
