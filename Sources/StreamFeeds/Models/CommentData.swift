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
    
    init(from response: CommentResponse) {
        self.attachments = response.attachments
        self.confidenceScore = response.confidenceScore
        self.controversyScore = response.controversyScore
        self.createdAt = response.createdAt
        self.custom = response.custom
        self.deletedAt = response.deletedAt
        self.downvoteCount = response.downvoteCount
        self.id = response.id
        self.latestReactions = response.latestReactions?.map(FeedsReactionData.init(from:))
        self.meta = nil
        self.mentionedUsers = response.mentionedUsers.map(UserData.init(from:))
        self.objectId = response.objectId
        self.objectType = response.objectType
        self.parentId = response.parentId
        self.reactionCount = response.reactionCount
        self.reactionGroups = response.reactionGroups?.mapValues(ReactionGroupData.init(from:))
        self.replies = nil
        self.replyCount = response.replyCount
        self.score = response.score
        self.status = response.status
        self.text = response.text
        self.updatedAt = response.updatedAt
        self.upvoteCount = response.upvoteCount
        self.user = UserData(from: response.user)
    }
    
    init(from response: ThreadedCommentResponse) {
        self.attachments = response.attachments
        self.confidenceScore = response.confidenceScore
        self.controversyScore = response.controversyScore
        self.createdAt = response.createdAt
        self.custom = response.custom
        self.deletedAt = response.deletedAt
        self.downvoteCount = response.downvoteCount
        self.id = response.id
        self.latestReactions = response.latestReactions?.map(FeedsReactionData.init(from:))
        self.mentionedUsers = response.mentionedUsers.map(UserData.init(from:))
        self.meta = response.meta
        self.objectId = response.objectId
        self.objectType = response.objectType
        self.parentId = response.parentId
        self.reactionCount = response.reactionCount
        self.reactionGroups = response.reactionGroups?.mapValues(ReactionGroupData.init(from:))
        self.replies = response.replies?.map(CommentData.init(from:))
        self.replyCount = response.replyCount
        self.score = response.score
        self.status = response.status
        self.text = response.text
        self.updatedAt = response.updatedAt
        self.upvoteCount = response.upvoteCount
        self.user = UserData(from: response.user)
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
