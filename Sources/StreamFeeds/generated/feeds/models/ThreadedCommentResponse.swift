//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ThreadedCommentResponseStatus: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let active = ThreadedCommentResponseStatus(rawValue: "active")
    public static let deleted = ThreadedCommentResponseStatus(rawValue: "deleted")
    public static let hidden = ThreadedCommentResponseStatus(rawValue: "hidden")
    public static let removed = ThreadedCommentResponseStatus(rawValue: "removed")
    public static let shadowBlocked = ThreadedCommentResponseStatus(rawValue: "shadow_blocked")
}

/// A comment with an optional, depth‑limited slice of nested replies.
public final class ThreadedCommentResponse: Sendable, Codable, JSONEncodable {
    public let attachments: [Attachment]?
    public let bookmarkCount: Int
    public let confidenceScore: Double
    public let controversyScore: Double?
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let deletedAt: Date?
    public let downvoteCount: Int
    public let editedAt: Date?
    public let hidden: Bool
    public let i18n: [String: String]?
    public let id: String
    public let latestReactions: [FeedsReactionResponse]?
    public let mentionedUsers: [UserResponse]
    /// Cursor & depth information for a comment's direct replies. Mirrors Reddit's 'load more replies' semantics.
    public let meta: RepliesMeta?
    public let moderation: ModerationV2Response?
    public let objectId: String
    public let objectType: String
    public let ownReactions: [FeedsReactionResponse]
    public let parentId: String?
    public let reactionCount: Int
    public let reactionGroups: [String: FeedsReactionGroupResponse]?
    /// Slice of nested comments (may be empty).
    public let replies: [ThreadedCommentResponse]?
    public let replyCount: Int
    public let score: Int
    /// Status of the comment. One of: active, deleted, removed, hidden
    public let status: ThreadedCommentResponseStatus
    public let text: String?
    public let updatedAt: Date
    public let upvoteCount: Int
    /// User response object
    public let user: UserResponse

    public init(attachments: [Attachment]? = nil, bookmarkCount: Int, confidenceScore: Double, controversyScore: Double? = nil, createdAt: Date, custom: [String: RawJSON]? = nil, deletedAt: Date? = nil, downvoteCount: Int, editedAt: Date? = nil, hidden: Bool, i18n: [String: String]? = nil, id: String, latestReactions: [FeedsReactionResponse]? = nil, mentionedUsers: [UserResponse], meta: RepliesMeta? = nil, moderation: ModerationV2Response? = nil, objectId: String, objectType: String, ownReactions: [FeedsReactionResponse], parentId: String? = nil, reactionCount: Int, reactionGroups: [String: FeedsReactionGroupResponse]? = nil, replies: [ThreadedCommentResponse]? = nil, replyCount: Int, score: Int, status: ThreadedCommentResponseStatus, text: String? = nil, updatedAt: Date, upvoteCount: Int, user: UserResponse) {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)
        self.bookmarkCount = try container.decode(Int.self, forKey: .bookmarkCount)
        self.confidenceScore = try container.decode(Double.self, forKey: .confidenceScore)
        self.controversyScore = try container.decodeIfPresent(Double.self, forKey: .controversyScore)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.deletedAt = try container.decodeIfPresent(Date.self, forKey: .deletedAt)
        self.downvoteCount = try container.decode(Int.self, forKey: .downvoteCount)
        self.editedAt = try container.decodeIfPresent(Date.self, forKey: .editedAt)
        self.hidden = try container.decode(Bool.self, forKey: .hidden)
        self.i18n = try container.decodeIfPresent([String: String].self, forKey: .i18n)
        self.id = try container.decode(String.self, forKey: .id)
        self.latestReactions = try container.decodeIfPresent([FeedsReactionResponse].self, forKey: .latestReactions)
        self.mentionedUsers = try container.decode([UserResponse].self, forKey: .mentionedUsers)
        self.meta = try container.decodeIfPresent(RepliesMeta.self, forKey: .meta)
        self.moderation = try container.decodeIfPresent(ModerationV2Response.self, forKey: .moderation)
        self.objectId = try container.decode(String.self, forKey: .objectId)
        self.objectType = try container.decode(String.self, forKey: .objectType)
        self.ownReactions = try container.decode([FeedsReactionResponse].self, forKey: .ownReactions)
        self.parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
        self.reactionCount = try container.decode(Int.self, forKey: .reactionCount)
        self.reactionGroups = try container.decodeIfPresent([String: FeedsReactionGroupResponse].self, forKey: .reactionGroups)
        self.replies = try container.decodeIfPresent([ThreadedCommentResponse].self, forKey: .replies)
        self.replyCount = try container.decode(Int.self, forKey: .replyCount)
        self.score = try container.decode(Int.self, forKey: .score)
        self.status = try container.decode(ThreadedCommentResponseStatus.self, forKey: .status)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.upvoteCount = try container.decode(Int.self, forKey: .upvoteCount)
        self.user = try container.decode(UserResponse.self, forKey: .user)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(attachments, forKey: .attachments)
        try container.encode(bookmarkCount, forKey: .bookmarkCount)
        try container.encode(confidenceScore, forKey: .confidenceScore)
        try container.encodeIfPresent(controversyScore, forKey: .controversyScore)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(deletedAt, forKey: .deletedAt)
        try container.encode(downvoteCount, forKey: .downvoteCount)
        try container.encodeIfPresent(editedAt, forKey: .editedAt)
        try container.encode(hidden, forKey: .hidden)
        try container.encodeIfPresent(i18n, forKey: .i18n)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(latestReactions, forKey: .latestReactions)
        try container.encode(mentionedUsers, forKey: .mentionedUsers)
        try container.encodeIfPresent(meta, forKey: .meta)
        try container.encodeIfPresent(moderation, forKey: .moderation)
        try container.encode(objectId, forKey: .objectId)
        try container.encode(objectType, forKey: .objectType)
        try container.encode(ownReactions, forKey: .ownReactions)
        try container.encodeIfPresent(parentId, forKey: .parentId)
        try container.encode(reactionCount, forKey: .reactionCount)
        try container.encodeIfPresent(reactionGroups, forKey: .reactionGroups)
        try container.encodeIfPresent(replies, forKey: .replies)
        try container.encode(replyCount, forKey: .replyCount)
        try container.encode(score, forKey: .score)
        try container.encode(status, forKey: .status)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(upvoteCount, forKey: .upvoteCount)
        try container.encode(user, forKey: .user)
    }
}

extension ThreadedCommentResponse: Hashable {
    public static func == (lhs: ThreadedCommentResponse, rhs: ThreadedCommentResponse) -> Bool {
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
