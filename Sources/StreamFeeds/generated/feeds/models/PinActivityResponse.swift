//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PinActivityResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activity: ActivityResponse
    public var createdAt: Date
    public var duration: String
    public var feedId: String
    public var userId: String

    public init(activity: ActivityResponse, createdAt: Date, duration: String, feedId: String, userId: String) {
        self.activity = activity
        self.createdAt = createdAt
        self.duration = duration
        self.feedId = feedId
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case createdAt = "created_at"
        case duration
        case feedId = "feed_id"
        case userId = "user_id"
    }

    public static func == (lhs: PinActivityResponse, rhs: PinActivityResponse) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.createdAt == rhs.createdAt &&
            lhs.duration == rhs.duration &&
            lhs.feedId == rhs.feedId &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(createdAt)
        hasher.combine(duration)
        hasher.combine(feedId)
        hasher.combine(userId)
    }
}
