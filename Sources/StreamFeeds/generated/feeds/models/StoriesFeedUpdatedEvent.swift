//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when stories feed is updated.
public final class StoriesFeedUpdatedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    /// Individual activities for stories feeds
    public var activities: [ActivityResponse]?
    /// Aggregated activities for stories feeds
    public var aggregatedActivities: [AggregatedActivityResponse]?
    /// Date/time of creation
    public var createdAt: Date
    public var custom: [String: RawJSON]
    /// Who can see and follow a feed.
    public var feedVisibility: FeedVisibility?
    /// The ID of the feed
    public var fid: String
    public var receivedAt: Date?
    /// The type of event: "feeds.stories_feed.updated" in this case
    public var type: String = "feeds.stories_feed.updated"
    public var user: UserResponseCommonFields?

    public init(activities: [ActivityResponse]? = nil, aggregatedActivities: [AggregatedActivityResponse]? = nil, createdAt: Date, custom: [String: RawJSON], feedVisibility: FeedVisibility? = nil, fid: String, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.activities = activities
        self.aggregatedActivities = aggregatedActivities
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activities
        case aggregatedActivities = "aggregated_activities"
        case createdAt = "created_at"
        case custom
        case feedVisibility = "feed_visibility"
        case fid
        case receivedAt = "received_at"
        case type
        case user
    }
}

extension StoriesFeedUpdatedEvent: Hashable {
    public static func == (lhs: StoriesFeedUpdatedEvent, rhs: StoriesFeedUpdatedEvent) -> Bool {
        lhs.activities == rhs.activities &&
            lhs.aggregatedActivities == rhs.aggregatedActivities &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activities)
        hasher.combine(aggregatedActivities)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
