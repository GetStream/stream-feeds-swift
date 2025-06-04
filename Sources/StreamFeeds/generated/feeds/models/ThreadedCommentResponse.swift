import Foundation
import StreamCore

public final class ThreadedCommentResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var attachments: [Attachment]?
    public var confidenceScore: Float
    public var controversyScore: Float?
    public var createdAt: Date
    public var custom: [String: RawJSON]?
    public var deletedAt: Date?
    public var downvoteCount: Int
    public var id: String
    public var latestReactions: [FeedsReactionResponse]?
    public var mentionedUsers: [UserResponse]
    public var meta: RepliesMeta?
    public var moderation: ModerationV2Response?
    public var objectId: String
    public var objectType: String
    public var parentId: String?
    public var reactionCount: Int
    public var reactionGroups: [String: ReactionGroupResponse]?
    public var replies: [ThreadedCommentResponse]?
    public var replyCount: Int
    public var score: Int
    public var status: String
    public var text: String?
    public var updatedAt: Date
    public var upvoteCount: Int
    public var user: UserResponse

    public init(attachments: [Attachment]? = nil, confidenceScore: Float, controversyScore: Float? = nil, createdAt: Date, custom: [String: RawJSON]? = nil, deletedAt: Date? = nil, downvoteCount: Int, id: String, latestReactions: [FeedsReactionResponse]? = nil, mentionedUsers: [UserResponse], meta: RepliesMeta? = nil, moderation: ModerationV2Response? = nil, objectId: String, objectType: String, parentId: String? = nil, reactionCount: Int, reactionGroups: [String: ReactionGroupResponse]? = nil, replies: [ThreadedCommentResponse]? = nil, replyCount: Int, score: Int, status: String, text: String? = nil, updatedAt: Date, upvoteCount: Int, user: UserResponse) {
        self.attachments = attachments
        self.confidenceScore = confidenceScore
        self.controversyScore = controversyScore
        self.createdAt = createdAt
        self.custom = custom
        self.deletedAt = deletedAt
        self.downvoteCount = downvoteCount
        self.id = id
        self.latestReactions = latestReactions
        self.mentionedUsers = mentionedUsers
        self.meta = meta
        self.moderation = moderation
        self.objectId = objectId
        self.objectType = objectType
        self.parentId = parentId
        self.reactionCount = reactionCount
        self.reactionGroups = reactionGroups
        self.replies = replies
        self.replyCount = replyCount
        self.score = score
        self.status = status
        self.text = text
        self.updatedAt = updatedAt
        self.upvoteCount = upvoteCount
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case confidenceScore = "confidence_score"
        case controversyScore = "controversy_score"
        case createdAt = "created_at"
        case custom
        case deletedAt = "deleted_at"
        case downvoteCount = "downvote_count"
        case id
        case latestReactions = "latest_reactions"
        case mentionedUsers = "mentioned_users"
        case meta
        case moderation
        case objectId = "object_id"
        case objectType = "object_type"
        case parentId = "parent_id"
        case reactionCount = "reaction_count"
        case reactionGroups = "reaction_groups"
        case replies
        case replyCount = "reply_count"
        case score
        case status
        case text
        case updatedAt = "updated_at"
        case upvoteCount = "upvote_count"
        case user
    }

    public static func == (lhs: ThreadedCommentResponse, rhs: ThreadedCommentResponse) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.confidenceScore == rhs.confidenceScore &&
            lhs.controversyScore == rhs.controversyScore &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.deletedAt == rhs.deletedAt &&
            lhs.downvoteCount == rhs.downvoteCount &&
            lhs.id == rhs.id &&
            lhs.latestReactions == rhs.latestReactions &&
            lhs.mentionedUsers == rhs.mentionedUsers &&
            lhs.meta == rhs.meta &&
            lhs.moderation == rhs.moderation &&
            lhs.objectId == rhs.objectId &&
            lhs.objectType == rhs.objectType &&
            lhs.parentId == rhs.parentId &&
            lhs.reactionCount == rhs.reactionCount &&
            lhs.reactionGroups == rhs.reactionGroups &&
            lhs.replies == rhs.replies &&
            lhs.replyCount == rhs.replyCount &&
            lhs.score == rhs.score &&
            lhs.status == rhs.status &&
            lhs.text == rhs.text &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.upvoteCount == rhs.upvoteCount &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(confidenceScore)
        hasher.combine(controversyScore)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(deletedAt)
        hasher.combine(downvoteCount)
        hasher.combine(id)
        hasher.combine(latestReactions)
        hasher.combine(mentionedUsers)
        hasher.combine(meta)
        hasher.combine(moderation)
        hasher.combine(objectId)
        hasher.combine(objectType)
        hasher.combine(parentId)
        hasher.combine(reactionCount)
        hasher.combine(reactionGroups)
        hasher.combine(replies)
        hasher.combine(replyCount)
        hasher.combine(score)
        hasher.combine(status)
        hasher.combine(text)
        hasher.combine(updatedAt)
        hasher.combine(upvoteCount)
        hasher.combine(user)
    }
}
