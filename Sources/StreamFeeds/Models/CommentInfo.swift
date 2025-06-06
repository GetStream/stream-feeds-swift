//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct CommentInfo: Identifiable, Sendable {
    public let attachments: [Attachment]?
    public let confidenceScore: Float
    public let controversyScore: Float?
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let deletedAt: Date?
    public let downvoteCount: Int
    public let id: String
    public let latestReactions: [ActivityReactionInfo]?
    public let mentionedUsers: [UserInfo]
    public let objectId: String
    public let objectType: String
    public let parentId: String?
    public let reactionCount: Int
    public let reactionGroups: [String: ReactionGroupInfo]?
    public let replyCount: Int
    public let score: Int
    public let status: String
    public let text: String?
    public let updatedAt: Date
    public let upvoteCount: Int
    public let user: UserInfo
    
    init(from response: CommentResponse) {
        self.attachments = response.attachments
        self.confidenceScore = response.confidenceScore
        self.controversyScore = response.controversyScore
        self.createdAt = response.createdAt
        self.custom = response.custom
        self.deletedAt = response.deletedAt
        self.downvoteCount = response.downvoteCount
        self.id = response.id
        self.latestReactions = response.latestReactions?.map(ActivityReactionInfo.init(from:))
        self.mentionedUsers = response.mentionedUsers.map(UserInfo.init(from:))
        self.objectId = response.objectId
        self.objectType = response.objectType
        self.parentId = response.parentId
        self.reactionCount = response.reactionCount
        self.reactionGroups = response.reactionGroups?.mapValues(ReactionGroupInfo.init(from:))
        self.replyCount = response.replyCount
        self.score = response.score
        self.status = response.status
        self.text = response.text
        self.updatedAt = response.updatedAt
        self.upvoteCount = response.upvoteCount
        self.user = UserInfo(from: response.user)
    }
} 
