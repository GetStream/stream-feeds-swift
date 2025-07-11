//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UnpinActivityResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activity: ActivityResponse
    public var duration: String
    public var feedId: String
    public var userId: String

    public init(activity: ActivityResponse, duration: String, feedId: String, userId: String) {
        self.activity = activity
        self.duration = duration
        self.feedId = feedId
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case duration
        case feedId = "feed_id"
        case userId = "user_id"
    }

    public static func == (lhs: UnpinActivityResponse, rhs: UnpinActivityResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.duration == rhs.duration &&
            lhs.feedId == rhs.feedId &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(duration)
        hasher.combine(feedId)
        hasher.combine(userId)
    }
}
