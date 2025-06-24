import Foundation
import StreamCore

public final class EnrichedReaction: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activityId: String
    public var childrenCounts: [String: Int]?
    public var data: [String: RawJSON]?
    public var id: String?
    public var kind: String
    public var latestChildren: [String: [EnrichedReaction]]?
    public var ownChildren: [String: [EnrichedReaction]]?
    public var parent: String?
    public var targetFeeds: [String]?
    public var user: StreamData?
    public var userId: String

    public init(activityId: String, childrenCounts: [String: Int]? = nil, data: [String: RawJSON]? = nil, id: String? = nil, kind: String, latestChildren: [String: [EnrichedReaction]]? = nil, ownChildren: [String: [EnrichedReaction]]? = nil, parent: String? = nil, targetFeeds: [String]? = nil, user: StreamData? = nil, userId: String) {
        self.activityId = activityId
        self.childrenCounts = childrenCounts
        self.data = data
        self.id = id
        self.kind = kind
        self.latestChildren = latestChildren
        self.ownChildren = ownChildren
        self.parent = parent
        self.targetFeeds = targetFeeds
        self.user = user
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityId = "activity_id"
        case childrenCounts = "children_counts"
        case data
        case id
        case kind
        case latestChildren = "latest_children"
        case ownChildren = "own_children"
        case parent
        case targetFeeds = "target_feeds"
        case user
        case userId = "user_id"
    }

    public static func == (lhs: EnrichedReaction, rhs: EnrichedReaction) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.childrenCounts == rhs.childrenCounts &&
            lhs.data == rhs.data &&
            lhs.id == rhs.id &&
            lhs.kind == rhs.kind &&
            lhs.latestChildren == rhs.latestChildren &&
            lhs.ownChildren == rhs.ownChildren &&
            lhs.parent == rhs.parent &&
            lhs.targetFeeds == rhs.targetFeeds &&
            lhs.user == rhs.user &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(childrenCounts)
        hasher.combine(data)
        hasher.combine(id)
        hasher.combine(kind)
        hasher.combine(latestChildren)
        hasher.combine(ownChildren)
        hasher.combine(parent)
        hasher.combine(targetFeeds)
        hasher.combine(user)
        hasher.combine(userId)
    }
}
