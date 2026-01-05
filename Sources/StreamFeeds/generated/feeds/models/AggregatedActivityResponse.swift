//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AggregatedActivityResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activities: [ActivityResponse]
    public var activityCount: Int
    public var createdAt: Date
    public var group: String
    public var isWatched: Bool?
    public var score: Float
    public var updatedAt: Date
    public var userCount: Int
    public var userCountTruncated: Bool

    public init(activities: [ActivityResponse], activityCount: Int, createdAt: Date, group: String, isWatched: Bool? = nil, score: Float, updatedAt: Date, userCount: Int, userCountTruncated: Bool) {
        self.activities = activities
        self.activityCount = activityCount
        self.createdAt = createdAt
        self.group = group
        self.isWatched = isWatched
        self.score = score
        self.updatedAt = updatedAt
        self.userCount = userCount
        self.userCountTruncated = userCountTruncated
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activities
        case activityCount = "activity_count"
        case createdAt = "created_at"
        case group
        case isWatched = "is_watched"
        case score
        case updatedAt = "updated_at"
        case userCount = "user_count"
        case userCountTruncated = "user_count_truncated"
    }

    public static func == (lhs: AggregatedActivityResponse, rhs: AggregatedActivityResponse) -> Bool {
        lhs.activities == rhs.activities &&
        lhs.activityCount == rhs.activityCount &&
        lhs.createdAt == rhs.createdAt &&
        lhs.group == rhs.group &&
        lhs.isWatched == rhs.isWatched &&
        lhs.score == rhs.score &&
        lhs.updatedAt == rhs.updatedAt &&
        lhs.userCount == rhs.userCount &&
        lhs.userCountTruncated == rhs.userCountTruncated
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activities)
        hasher.combine(activityCount)
        hasher.combine(createdAt)
        hasher.combine(group)
        hasher.combine(isWatched)
        hasher.combine(score)
        hasher.combine(updatedAt)
        hasher.combine(userCount)
        hasher.combine(userCountTruncated)
    }
}
