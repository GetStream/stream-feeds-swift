//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PinActivityResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activity: ActivityResponse
    public var createdAt: Date
    public var duration: String
    public var feed: String
    public var userId: String

    public init(activity: ActivityResponse, createdAt: Date, duration: String, feed: String, userId: String) {
        self.activity = activity
        self.createdAt = createdAt
        self.duration = duration
        self.feed = feed
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case createdAt = "created_at"
        case duration
        case feed
        case userId = "user_id"
    }

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
