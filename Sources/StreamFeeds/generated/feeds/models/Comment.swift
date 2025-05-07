import Foundation
import StreamCore

public final class Comment: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activityId: String
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var deletedAt: Date?
    public var id: String
    public var latestReactions: [ActivityReaction]?
    public var parentId: String?
    public var reactionCount: Int
    public var reactionGroups: [String: ReactionGroup]?
    public var replyCount: Int
    public var text: String?
    public var updatedAt: Date
    public var user: UserResponse

    public init(activityId: String, createdAt: Date, custom: [String: RawJSON]? = nil, deletedAt: Date? = nil, id: String, latestReactions: [ActivityReaction]? = nil, parentId: String? = nil, reactionCount: Int, reactionGroups: [String: ReactionGroup]? = nil, replyCount: Int, text: String? = nil, updatedAt: Date, user: UserResponse) {
        self.activityId = activityId
        self.createdAt = createdAt
        self.custom = custom
        self.deletedAt = deletedAt
        self.id = id
        self.latestReactions = latestReactions
        self.parentId = parentId
        self.reactionCount = reactionCount
        self.reactionGroups = reactionGroups
        self.replyCount = replyCount
        self.text = text
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityId = "activity_id"
        case createdAt = "created_at"
        case custom
        case deletedAt = "deleted_at"
        case id
        case latestReactions = "latest_reactions"
        case parentId = "parent_id"
        case reactionCount = "reaction_count"
        case reactionGroups = "reaction_groups"
        case replyCount = "reply_count"
        case text
        case updatedAt = "updated_at"
        case user
    }

    public static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.activityId == rhs.activityId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.deletedAt == rhs.deletedAt &&
            lhs.id == rhs.id &&
            lhs.latestReactions == rhs.latestReactions &&
            lhs.parentId == rhs.parentId &&
            lhs.reactionCount == rhs.reactionCount &&
            lhs.reactionGroups == rhs.reactionGroups &&
            lhs.replyCount == rhs.replyCount &&
            lhs.text == rhs.text &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityId)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(deletedAt)
        hasher.combine(id)
        hasher.combine(latestReactions)
        hasher.combine(parentId)
        hasher.combine(reactionCount)
        hasher.combine(reactionGroups)
        hasher.combine(replyCount)
        hasher.combine(text)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
