import Foundation
import StreamCore

public final class FeedGroup: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activitySelectors: [ActivitySelectorConfig]?
    public var aggregation: AggregationConfig?
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var defaultVisibility: String?
    public var groupId: String
    public var id: String
    public var notification: NotificationConfig?
    public var ranking: RankingConfig?
    public var stories: StoriesConfig?
    public var updatedAt: Date

    public init(activitySelectors: [ActivitySelectorConfig]? = nil, aggregation: AggregationConfig? = nil, createdAt: Date, custom: [String: RawJSON]? = nil, defaultVisibility: String? = nil, groupId: String, id: String, notification: NotificationConfig? = nil, ranking: RankingConfig? = nil, stories: StoriesConfig? = nil, updatedAt: Date) {
        self.activitySelectors = activitySelectors
        self.aggregation = aggregation
        self.createdAt = createdAt
        self.custom = custom
        self.defaultVisibility = defaultVisibility
        self.groupId = groupId
        self.id = id
        self.notification = notification
        self.ranking = ranking
        self.stories = stories
        self.updatedAt = updatedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activitySelectors = "activity_selectors"
        case aggregation
        case createdAt = "created_at"
        case custom
        case defaultVisibility = "default_visibility"
        case groupId = "group_id"
        case id
        case notification
        case ranking
        case stories
        case updatedAt = "updated_at"
    }

    public static func == (lhs: FeedGroup, rhs: FeedGroup) -> Bool {
        lhs.activitySelectors == rhs.activitySelectors &&
            lhs.aggregation == rhs.aggregation &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.defaultVisibility == rhs.defaultVisibility &&
            lhs.groupId == rhs.groupId &&
            lhs.id == rhs.id &&
            lhs.notification == rhs.notification &&
            lhs.ranking == rhs.ranking &&
            lhs.stories == rhs.stories &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activitySelectors)
        hasher.combine(aggregation)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(defaultVisibility)
        hasher.combine(groupId)
        hasher.combine(id)
        hasher.combine(notification)
        hasher.combine(ranking)
        hasher.combine(stories)
        hasher.combine(updatedAt)
    }
}
