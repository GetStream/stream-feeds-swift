//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UnpinActivityResponse: Sendable, Decodable {
    public let activity: ActivityResponse
    /// Fully qualified ID of the feed the activity was unpinned from
    public let feed: String
    /// ID of the user who unpinned the activity
    public let userId: String

    public init(activity: ActivityResponse, feed: String, userId: String) {
        self.activity = activity
        self.feed = feed
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.feed = try container.decode(String.self, forKey: .feed)
        self.userId = try container.decode(String.self, forKey: .userId)
    }
}

extension UnpinActivityResponse: Hashable {
    public static func == (lhs: UnpinActivityResponse, rhs: UnpinActivityResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.feed == rhs.feed &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(feed)
        hasher.combine(userId)
    }
}
