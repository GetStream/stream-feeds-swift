//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AggregatedActivityResponse: Sendable, Decodable {
    /// List of activities in this aggregation
    public let activities: [ActivityResponse]
    /// Number of activities in this aggregation
    public let activityCount: Int
    /// When the aggregation was created
    public let createdAt: Date
    /// Grouping identifier
    public let group: String
    public let isWatched: Bool?
    /// Ranking score for this aggregation
    public let score: Double
    /// When the aggregation was last updated
    public let updatedAt: Date
    /// Number of unique users in this aggregation
    public let userCount: Int
    /// Whether this activity group has been truncated due to exceeding the group size limit
    public let userCountTruncated: Bool

    public init(activities: [ActivityResponse], activityCount: Int, createdAt: Date, group: String, isWatched: Bool? = nil, score: Double, updatedAt: Date, userCount: Int, userCountTruncated: Bool) {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activities = try container.decode([ActivityResponse].self, forKey: .activities)
        self.activityCount = try container.decode(Int.self, forKey: .activityCount)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.group = try container.decode(String.self, forKey: .group)
        self.isWatched = try container.decodeIfPresent(Bool.self, forKey: .isWatched)
        self.score = try container.decode(Double.self, forKey: .score)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.userCount = try container.decode(Int.self, forKey: .userCount)
        self.userCountTruncated = try container.decode(Bool.self, forKey: .userCountTruncated)
    }
}

extension AggregatedActivityResponse: Hashable {
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
