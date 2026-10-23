//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AggregatedActivityResponse: Sendable, Codable, JSONEncodable {
    /// List of activities in this aggregation
    public let activities: [ActivityResponse]
    /// Number of activities in this aggregation
    public let activityCount: Int
    /// When the aggregation was created
    public let createdAt: Date
    /// Grouping identifier
    public let group: String
    /// Whether this aggregated group has been read. Only set for feed groups with notification config (track_seen/track_read enabled).
    public let isRead: Bool?
    /// Whether this aggregated group has been seen. Only set for feed groups with notification config (track_seen/track_read enabled).
    public let isSeen: Bool?
    public let isWatched: Bool?
    /// Ranking score for this aggregation
    public let score: Double
    /// When the aggregation was last updated
    public let updatedAt: Date
    /// Number of unique users in this aggregation
    public let userCount: Int
    /// Whether this activity group has been truncated due to exceeding the group size limit
    public let userCountTruncated: Bool

    public init(activities: [ActivityResponse], activityCount: Int, createdAt: Date, group: String, isRead: Bool? = nil, isSeen: Bool? = nil, isWatched: Bool? = nil, score: Double, updatedAt: Date, userCount: Int, userCountTruncated: Bool) {
        self.activities = activities
        self.activityCount = activityCount
        self.createdAt = createdAt
        self.group = group
        self.isRead = isRead
        self.isSeen = isSeen
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
        self.isRead = try container.decodeIfPresent(Bool.self, forKey: .isRead)
        self.isSeen = try container.decodeIfPresent(Bool.self, forKey: .isSeen)
        self.isWatched = try container.decodeIfPresent(Bool.self, forKey: .isWatched)
        self.score = try container.decode(Double.self, forKey: .score)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.userCount = try container.decode(Int.self, forKey: .userCount)
        self.userCountTruncated = try container.decode(Bool.self, forKey: .userCountTruncated)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activities, forKey: .activities)
        try container.encode(activityCount, forKey: .activityCount)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(group, forKey: .group)
        try container.encodeIfPresent(isRead, forKey: .isRead)
        try container.encodeIfPresent(isSeen, forKey: .isSeen)
        try container.encodeIfPresent(isWatched, forKey: .isWatched)
        try container.encode(score, forKey: .score)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(userCount, forKey: .userCount)
        try container.encode(userCountTruncated, forKey: .userCountTruncated)
    }
}

extension AggregatedActivityResponse: Hashable {
    public static func == (lhs: AggregatedActivityResponse, rhs: AggregatedActivityResponse) -> Bool {
        lhs.activities == rhs.activities &&
            lhs.activityCount == rhs.activityCount &&
            lhs.createdAt == rhs.createdAt &&
            lhs.group == rhs.group &&
            lhs.isRead == rhs.isRead &&
            lhs.isSeen == rhs.isSeen &&
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
        hasher.combine(isRead)
        hasher.combine(isSeen)
        hasher.combine(isWatched)
        hasher.combine(score)
        hasher.combine(updatedAt)
        hasher.combine(userCount)
        hasher.combine(userCountTruncated)
    }
}
