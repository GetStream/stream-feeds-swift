//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ThreadedCommentResponse {
    static func dummy(
        createdAt: Date = .fixed(),
        id: String,
        latestReactions: [FeedsReactionResponse]? = nil,
        objectId: String,
        objectType: String = "activity",
        ownReactions: [FeedsReactionResponse] = [],
        parentId: String? = nil,
        reactionCount: Int = 0,
        reactionGroups: [String: ReactionGroupResponse?]? = nil,
        replies: [ThreadedCommentResponse]? = nil,
        text: String = "Test comment",
        user: UserResponse = .dummy()
    ) -> ThreadedCommentResponse {
        ThreadedCommentResponse(
            attachments: nil,
            confidenceScore: 0.95,
            controversyScore: nil,
            createdAt: createdAt,
            custom: nil,
            deletedAt: nil,
            downvoteCount: 0,
            id: id,
            latestReactions: latestReactions,
            mentionedUsers: [UserResponse.dummy()],
            meta: nil,
            moderation: nil,
            objectId: objectId,
            objectType: objectType,
            ownReactions: ownReactions,
            parentId: parentId,
            reactionCount: reactionCount,
            reactionGroups: reactionGroups,
            replies: replies,
            replyCount: replies?.count ?? 0,
            score: 10,
            status: "active",
            text: text,
            updatedAt: Date(),
            upvoteCount: 3,
            user: user
        )
    }
}
