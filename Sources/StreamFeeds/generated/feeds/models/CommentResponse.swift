//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CommentResponse: @unchecked Sendable, Codable, JSONEncodable {
    public enum CommentResponseStatus: String, Sendable, Codable, CaseIterable {
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

    /// Attachments associated with the comment
    public var attachments: [Attachment]?
    public var bookmarkCount: Int
    /// Confidence score of the comment
    public var confidenceScore: Float
    /// Controversy score of the comment
    public var controversyScore: Float?
    /// When the comment was created
    public var createdAt: Date
    /// Custom data for the comment
    public var custom: [String: RawJSON]?
    /// When the comment was deleted
    public var deletedAt: Date?
    /// Number of downvotes for this comment
    public var downvoteCount: Int
    /// When the comment was last edited
    public var editedAt: Date?
    /// Only true in QueryComments results filtered with hidden: true
    public var hidden: Bool
    public var i18n: [String: String]?
    /// Unique identifier for the comment
    public var id: String
    /// Recent reactions to the comment
    public var latestReactions: [FeedsReactionResponse]?
    /// Users mentioned in the comment
    public var mentionedUsers: [UserResponse]
    public var moderation: ModerationV2Response?
    /// ID of the object this comment is associated with
    public var objectId: String
    /// Type of the object this comment is associated with
    public var objectType: String
    /// Current user's reactions to this activity
    public var ownReactions: [FeedsReactionResponse]
    /// ID of parent comment for nested replies
    public var parentId: String?
    /// Number of reactions to this comment
    public var reactionCount: Int
    /// Grouped reactions by type
    public var reactionGroups: [String: FeedsReactionGroupResponse]?
    /// Number of replies to this comment
    public var replyCount: Int
    /// Score of the comment based on reactions
    public var score: Int
    /// Status of the comment. One of: active, deleted, removed, hidden
    public var status: CommentResponseStatus
    /// Text content of the comment
    public var text: String?
    /// When the comment was last updated
    public var updatedAt: Date
    /// Number of upvotes for this comment
    public var upvoteCount: Int
    /// User response object
    public var user: UserResponse

    public init(attachments: [Attachment]? = nil, bookmarkCount: Int, confidenceScore: Float, controversyScore: Float? = nil, createdAt: Date, custom: [String: RawJSON]? = nil, deletedAt: Date? = nil, downvoteCount: Int, editedAt: Date? = nil, hidden: Bool, i18n: [String: String]? = nil, id: String, latestReactions: [FeedsReactionResponse]? = nil, mentionedUsers: [UserResponse], moderation: ModerationV2Response? = nil, objectId: String, objectType: String, ownReactions: [FeedsReactionResponse], parentId: String? = nil, reactionCount: Int, reactionGroups: [String: FeedsReactionGroupResponse]? = nil, replyCount: Int, score: Int, status: CommentResponseStatus, text: String? = nil, updatedAt: Date, upvoteCount: Int, user: UserResponse) {
        self.attachments = attachments
        self.bookmarkCount = bookmarkCount
        self.confidenceScore = confidenceScore
        self.controversyScore = controversyScore
        self.createdAt = createdAt
        self.custom = custom
        self.deletedAt = deletedAt
        self.downvoteCount = downvoteCount
        self.editedAt = editedAt
        self.hidden = hidden
        self.i18n = i18n
        self.id = id
        self.latestReactions = latestReactions
        self.mentionedUsers = mentionedUsers
        self.moderation = moderation
        self.objectId = objectId
        self.objectType = objectType
        self.ownReactions = ownReactions
        self.parentId = parentId
        self.reactionCount = reactionCount
        self.reactionGroups = reactionGroups
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
        case bookmarkCount = "bookmark_count"
        case confidenceScore = "confidence_score"
        case controversyScore = "controversy_score"
        case createdAt = "created_at"
        case custom
        case deletedAt = "deleted_at"
        case downvoteCount = "downvote_count"
        case editedAt = "edited_at"
        case hidden
        case i18n
        case id
        case latestReactions = "latest_reactions"
        case mentionedUsers = "mentioned_users"
        case moderation
        case objectId = "object_id"
        case objectType = "object_type"
        case ownReactions = "own_reactions"
        case parentId = "parent_id"
        case reactionCount = "reaction_count"
        case reactionGroups = "reaction_groups"
        case replyCount = "reply_count"
        case score
        case status
        case text
        case updatedAt = "updated_at"
        case upvoteCount = "upvote_count"
        case user
    }
}

extension CommentResponse: Hashable {
    public static func == (lhs: CommentResponse, rhs: CommentResponse) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.bookmarkCount == rhs.bookmarkCount &&
            lhs.confidenceScore == rhs.confidenceScore &&
            lhs.controversyScore == rhs.controversyScore &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.deletedAt == rhs.deletedAt &&
            lhs.downvoteCount == rhs.downvoteCount &&
            lhs.editedAt == rhs.editedAt &&
            lhs.hidden == rhs.hidden &&
            lhs.i18n == rhs.i18n &&
            lhs.id == rhs.id &&
            lhs.latestReactions == rhs.latestReactions &&
            lhs.mentionedUsers == rhs.mentionedUsers &&
            lhs.moderation == rhs.moderation &&
            lhs.objectId == rhs.objectId &&
            lhs.objectType == rhs.objectType &&
            lhs.ownReactions == rhs.ownReactions &&
            lhs.parentId == rhs.parentId &&
            lhs.reactionCount == rhs.reactionCount &&
            lhs.reactionGroups == rhs.reactionGroups &&
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
        hasher.combine(bookmarkCount)
        hasher.combine(confidenceScore)
        hasher.combine(controversyScore)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(deletedAt)
        hasher.combine(downvoteCount)
        hasher.combine(editedAt)
        hasher.combine(hidden)
        hasher.combine(i18n)
        hasher.combine(id)
        hasher.combine(latestReactions)
        hasher.combine(mentionedUsers)
        hasher.combine(moderation)
        hasher.combine(objectId)
        hasher.combine(objectType)
        hasher.combine(ownReactions)
        hasher.combine(parentId)
        hasher.combine(reactionCount)
        hasher.combine(reactionGroups)
        hasher.combine(replyCount)
        hasher.combine(score)
        hasher.combine(status)
        hasher.combine(text)
        hasher.combine(updatedAt)
        hasher.combine(upvoteCount)
        hasher.combine(user)
    }
}
