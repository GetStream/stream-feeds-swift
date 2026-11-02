//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when notification feed is updated.
public final class NotificationFeedUpdatedEvent: Sendable, Event, Decodable {
    /// Aggregated activities for notification feeds
    public let aggregatedActivities: [AggregatedActivityResponse]?
    /// Date/time of creation
    public let createdAt: Date
    public let custom: [String: RawJSON]
    /// Who can see and follow a feed.
    public let feedVisibility: FeedVisibility?
    /// The ID of the feed
    public let fid: String
    public let notificationStatus: NotificationStatusResponse?
    public let receivedAt: Date?
    /// The type of event: "feeds.notification_feed.updated" in this case
    public let type: String
    public let user: UserResponseCommonFields?

    public init(aggregatedActivities: [AggregatedActivityResponse]? = nil, createdAt: Date, custom: [String: RawJSON], feedVisibility: FeedVisibility? = nil, fid: String, notificationStatus: NotificationStatusResponse? = nil, receivedAt: Date? = nil, type: String = "feeds.notification_feed.updated", user: UserResponseCommonFields? = nil) {
        self.aggregatedActivities = aggregatedActivities
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.notificationStatus = notificationStatus
        self.receivedAt = receivedAt
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.aggregatedActivities = try container.decodeIfPresent([AggregatedActivityResponse].self, forKey: .aggregatedActivities)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.feedVisibility = try container.decodeIfPresent(FeedVisibility.self, forKey: .feedVisibility)
        self.fid = try container.decode(String.self, forKey: .fid)
        self.notificationStatus = try container.decodeIfPresent(NotificationStatusResponse.self, forKey: .notificationStatus)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decodeIfPresent(UserResponseCommonFields.self, forKey: .user)
    }
}

extension NotificationFeedUpdatedEvent: Hashable {
    public static func == (lhs: NotificationFeedUpdatedEvent, rhs: NotificationFeedUpdatedEvent) -> Bool {
        lhs.aggregatedActivities == rhs.aggregatedActivities &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.notificationStatus == rhs.notificationStatus &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(aggregatedActivities)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(notificationStatus)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
