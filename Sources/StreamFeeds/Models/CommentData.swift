//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct CommentData: Identifiable, Sendable {
    public let attachments: [Attachment]?
    public let confidenceScore: Float
    public let controversyScore: Float?
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let deletedAt: Date?
    public let downvoteCount: Int
    public let id: String
    public let latestReactions: [FeedsReactionData]?
    public let mentionedUsers: [UserData]
    public let meta: RepliesMeta?
    public let objectId: String
    public let objectType: String
    public let parentId: String?
    public let reactionCount: Int
    public let reactionGroups: [String: ReactionGroupData]?
    public private(set) var replies: [CommentData]?
    public private(set) var replyCount: Int
    public let score: Int
    public let status: String
    public let text: String?
    public let updatedAt: Date
    public let upvoteCount: Int
    public let user: UserData
    
    // Additional
    public var isThreaded: Bool {
        replies != nil
    }
}

// MARK: - Mutating the Data

extension CommentData {
    mutating func addReply(_ comment: CommentData) {
        var replies = self.replies ?? []
        replies.insert(byId: comment)
        self.replies = replies
        replyCount += 1
    }
    
    mutating func removeReply(_ comment: CommentData) {
        var replies = self.replies ?? []
        replies.remove(byId: comment)
        self.replies = replies
        replyCount = max(0, replyCount - 1)
    }
    
    mutating func replaceReply(_ comment: CommentData) {
        var replies = self.replies ?? []
        replies.replace(byId: comment)
        self.replies = replies
    }
}

// MARK: - Sorting

extension CommentData {
    static let defaultSorting: @Sendable (CommentData, CommentData) -> Bool = { $0.createdAt > $1.createdAt }
}

// MARK: - Model Conversions

extension CommentResponse {
    func toModel() -> CommentData {
        CommentData(
            attachments: attachments,
            confidenceScore: confidenceScore,
            controversyScore: controversyScore,
            createdAt: createdAt,
            custom: custom,
            deletedAt: deletedAt,
            downvoteCount: downvoteCount,
            id: id,
            latestReactions: latestReactions?.map { $0.toModel() },
            mentionedUsers: mentionedUsers.map { $0.toModel() },
            meta: nil,
            objectId: objectId,
            objectType: objectType,
            parentId: parentId,
            reactionCount: reactionCount,
            reactionGroups: reactionGroups?.mapValues { $0.toModel() },
            replies: nil,
            replyCount: replyCount,
            score: score,
            status: status,
            text: text,
            updatedAt: updatedAt,
            upvoteCount: upvoteCount,
            user: user.toModel()
        )
    }
}

extension ThreadedCommentResponse {
    func toModel() -> CommentData {
        CommentData(
            attachments: attachments,
            confidenceScore: confidenceScore,
            controversyScore: controversyScore,
            createdAt: createdAt,
            custom: custom,
            deletedAt: deletedAt,
            downvoteCount: downvoteCount,
            id: id,
            latestReactions: latestReactions?.map { $0.toModel() },
            mentionedUsers: mentionedUsers.map { $0.toModel() },
            meta: meta,
            objectId: objectId,
            objectType: objectType,
            parentId: parentId,
            reactionCount: reactionCount,
            reactionGroups: reactionGroups?.mapValues { $0.toModel() },
            replies: replies?.map { $0.toModel() },
            replyCount: replyCount,
            score: score,
            status: status,
            text: text,
            updatedAt: updatedAt,
            upvoteCount: upvoteCount,
            user: user.toModel()
        )
    }
}
