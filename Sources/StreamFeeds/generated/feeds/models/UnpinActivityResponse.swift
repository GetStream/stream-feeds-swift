//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UnpinActivityResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var activity: ActivityResponse
    public var duration: String
    /// Fully qualified ID of the feed the activity was unpinned from
    public var feed: String
    /// ID of the user who unpinned the activity
    public var userId: String

    public init(activity: ActivityResponse, duration: String, feed: String, userId: String) {
        self.activity = activity
        self.duration = duration
        self.feed = feed
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case duration
        case feed
        case userId = "user_id"
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
