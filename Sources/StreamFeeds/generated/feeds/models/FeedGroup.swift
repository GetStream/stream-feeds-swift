//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedGroup: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activityProcessors: [ActivityProcessorConfig]
    public var activitySelectors: [ActivitySelectorConfig]
    public var aggregation: AggregationConfig?
    public var aggregationVersion: Int
    public var appPK: Int
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var defaultVisibility: String
    public var deletedAt: Date?
    public var iD: String
    public var lastFeedGetAt: Date?
    public var notification: NotificationConfig?
    public var pushNotification: PushNotificationConfig?
    public var ranking: RankingConfig?
    public var stories: StoriesConfig?
    public var updatedAt: Date

    public init(activityProcessors: [ActivityProcessorConfig], activitySelectors: [ActivitySelectorConfig], aggregation: AggregationConfig? = nil, aggregationVersion: Int, appPK: Int, createdAt: Date, custom: [String: RawJSON], defaultVisibility: String, deletedAt: Date? = nil, iD: String, lastFeedGetAt: Date? = nil, notification: NotificationConfig? = nil, pushNotification: PushNotificationConfig? = nil, ranking: RankingConfig? = nil, stories: StoriesConfig? = nil, updatedAt: Date) {
        self.activityProcessors = activityProcessors
        self.activitySelectors = activitySelectors
        self.aggregation = aggregation
        self.aggregationVersion = aggregationVersion
        self.appPK = appPK
        self.createdAt = createdAt
        self.custom = custom
        self.defaultVisibility = defaultVisibility
        self.deletedAt = deletedAt
        self.iD = iD
        self.lastFeedGetAt = lastFeedGetAt
        self.notification = notification
        self.pushNotification = pushNotification
        self.ranking = ranking
        self.stories = stories
        self.updatedAt = updatedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityProcessors = "ActivityProcessors"
        case activitySelectors = "ActivitySelectors"
        case aggregation = "Aggregation"
        case aggregationVersion = "AggregationVersion"
        case appPK = "AppPK"
        case createdAt = "created_at"
        case custom = "Custom"
        case defaultVisibility = "DefaultVisibility"
        case deletedAt = "DeletedAt"
        case iD = "ID"
        case lastFeedGetAt = "LastFeedGetAt"
        case notification = "Notification"
        case pushNotification = "PushNotification"
        case ranking = "Ranking"
        case stories = "Stories"
        case updatedAt = "updated_at"
    }

    public static func == (lhs: FeedGroup, rhs: FeedGroup) -> Bool {
        lhs.activityProcessors == rhs.activityProcessors &&
            lhs.activitySelectors == rhs.activitySelectors &&
            lhs.aggregation == rhs.aggregation &&
            lhs.aggregationVersion == rhs.aggregationVersion &&
            lhs.appPK == rhs.appPK &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.defaultVisibility == rhs.defaultVisibility &&
            lhs.deletedAt == rhs.deletedAt &&
            lhs.iD == rhs.iD &&
            lhs.lastFeedGetAt == rhs.lastFeedGetAt &&
            lhs.notification == rhs.notification &&
            lhs.pushNotification == rhs.pushNotification &&
            lhs.ranking == rhs.ranking &&
            lhs.stories == rhs.stories &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityProcessors)
        hasher.combine(activitySelectors)
        hasher.combine(aggregation)
        hasher.combine(aggregationVersion)
        hasher.combine(appPK)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(defaultVisibility)
        hasher.combine(deletedAt)
        hasher.combine(iD)
        hasher.combine(lastFeedGetAt)
        hasher.combine(notification)
        hasher.combine(pushNotification)
        hasher.combine(ranking)
        hasher.combine(stories)
        hasher.combine(updatedAt)
    }
}
