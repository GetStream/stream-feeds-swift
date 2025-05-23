import Foundation
import StreamCore

public final class ThreadedCommentResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var attachments: [Attachment]?
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var deletedAt: Date?
    public var id: String
    public var latestReactions: [ActivityReactionResponse]
    public var mentionedUserIds: [String]?
    public var meta: RepliesMeta?
    public var objectId: String
    public var objectType: String
    public var parentId: String?
    public var reactionCount: Int
    public var reactionGroups: [String: ReactionGroupResponse]?
    public var replies: [ThreadedCommentResponse]?
    public var replyCount: Int
    public var text: String?
    public var updatedAt: Date
    public var user: UserResponse

    public init(attachments: [Attachment]? = nil, createdAt: Date, custom: [String: RawJSON]? = nil, deletedAt: Date? = nil, id: String, latestReactions: [ActivityReactionResponse], mentionedUserIds: [String]? = nil, meta: RepliesMeta? = nil, objectId: String, objectType: String, parentId: String? = nil, reactionCount: Int, reactionGroups: [String: ReactionGroupResponse]? = nil, replies: [ThreadedCommentResponse]? = nil, replyCount: Int, text: String? = nil, updatedAt: Date, user: UserResponse) {
        self.attachments = attachments
        self.createdAt = createdAt
        self.custom = custom
        self.deletedAt = deletedAt
        self.id = id
        self.latestReactions = latestReactions
        self.mentionedUserIds = mentionedUserIds
        self.meta = meta
        self.objectId = objectId
        self.objectType = objectType
        self.parentId = parentId
        self.reactionCount = reactionCount
        self.reactionGroups = reactionGroups
        self.replies = replies
        self.replyCount = replyCount
        self.text = text
        self.updatedAt = updatedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case createdAt = "created_at"
        case custom
        case deletedAt = "deleted_at"
        case id
        case latestReactions = "LatestReactions"
        case mentionedUserIds = "mentioned_user_ids"
        case meta
        case objectId = "object_id"
        case objectType = "object_type"
        case parentId = "parent_id"
        case reactionCount = "reaction_count"
        case reactionGroups = "reaction_groups"
        case replies
        case replyCount = "reply_count"
        case text
        case updatedAt = "updated_at"
        case user
    }

    public static func == (lhs: ThreadedCommentResponse, rhs: ThreadedCommentResponse) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.deletedAt == rhs.deletedAt &&
            lhs.id == rhs.id &&
            lhs.latestReactions == rhs.latestReactions &&
            lhs.mentionedUserIds == rhs.mentionedUserIds &&
            lhs.meta == rhs.meta &&
            lhs.objectId == rhs.objectId &&
            lhs.objectType == rhs.objectType &&
            lhs.parentId == rhs.parentId &&
            lhs.reactionCount == rhs.reactionCount &&
            lhs.reactionGroups == rhs.reactionGroups &&
            lhs.replies == rhs.replies &&
            lhs.replyCount == rhs.replyCount &&
            lhs.text == rhs.text &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(deletedAt)
        hasher.combine(id)
        hasher.combine(latestReactions)
        hasher.combine(mentionedUserIds)
        hasher.combine(meta)
        hasher.combine(objectId)
        hasher.combine(objectType)
        hasher.combine(parentId)
        hasher.combine(reactionCount)
        hasher.combine(reactionGroups)
        hasher.combine(replies)
        hasher.combine(replyCount)
        hasher.combine(text)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
