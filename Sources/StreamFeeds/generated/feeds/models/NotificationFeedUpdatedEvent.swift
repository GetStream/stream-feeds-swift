//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class NotificationFeedUpdatedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var aggregatedActivities: [AggregatedActivityResponse]?
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var feedVisibility: String?
    public var fid: String
    public var notificationStatus: NotificationStatusResponse?
    public var receivedAt: Date?
    public var type: String = "feeds.notification_feed.updated"
    public var user: UserResponseCommonFields?

    public init(aggregatedActivities: [AggregatedActivityResponse]? = nil, createdAt: Date, custom: [String: RawJSON], feedVisibility: String? = nil, fid: String, notificationStatus: NotificationStatusResponse? = nil, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.aggregatedActivities = aggregatedActivities
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.notificationStatus = notificationStatus
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case aggregatedActivities = "aggregated_activities"
        case createdAt = "created_at"
        case custom
        case feedVisibility = "feed_visibility"
        case fid
        case notificationStatus = "notification_status"
        case receivedAt = "received_at"
        case type
        case user
    }

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
