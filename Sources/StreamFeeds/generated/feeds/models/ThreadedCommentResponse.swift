//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A comment with an optional, depth‑limited slice of nested replies.
public final class ThreadedCommentResponse: @unchecked Sendable, Codable, JSONEncodable {
    public enum ThreadedCommentResponseStatus: String, Sendable, Codable, CaseIterable {
        case active
        case deleted
        case hidden
        case removed
        case shadowBlocked = "shadow_blocked"
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

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
    /// Cursor & depth information for a comment's direct replies. Mirrors Reddit's 'load more replies' semantics.
    public var meta: RepliesMeta?
    public var moderation: ModerationV2Response?
    public var objectId: String
    public var objectType: String
    public var ownReactions: [FeedsReactionResponse]
    public var parentId: String?
    public var reactionCount: Int
    public var reactionGroups: [String: FeedsReactionGroupResponse]?
    /// Slice of nested comments (may be empty).
    public var replies: [ThreadedCommentResponse]?
    public var replyCount: Int
    public var score: Int
    /// Status of the comment. One of: active, deleted, removed, hidden
    public var status: ThreadedCommentResponseStatus
    public var text: String?
    public var updatedAt: Date
    public var upvoteCount: Int
    /// User response object
    public var user: UserResponse

    public init(attachments: [Attachment]? = nil, confidenceScore: Float, controversyScore: Float? = nil, createdAt: Date, custom: [String: RawJSON]? = nil, deletedAt: Date? = nil, downvoteCount: Int, id: String, latestReactions: [FeedsReactionResponse]? = nil, mentionedUsers: [UserResponse], meta: RepliesMeta? = nil, moderation: ModerationV2Response? = nil, objectId: String, objectType: String, ownReactions: [FeedsReactionResponse], parentId: String? = nil, reactionCount: Int, reactionGroups: [String: FeedsReactionGroupResponse]? = nil, replies: [ThreadedCommentResponse]? = nil, replyCount: Int, score: Int, status: ThreadedCommentResponseStatus, text: String? = nil, updatedAt: Date, upvoteCount: Int, user: UserResponse) {
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
        self.ownReactions = ownReactions
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
        case ownReactions = "own_reactions"
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
}

extension ThreadedCommentResponse: Hashable {
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
            lhs.ownReactions == rhs.ownReactions &&
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
        hasher.combine(ownReactions)
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
