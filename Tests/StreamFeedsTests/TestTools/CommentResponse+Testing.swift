//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentResponse {
    static func dummy(
        createdAt: Date = .fixed(),
        id: String = "comment-123",
        latestReactions: [FeedsReactionResponse]? = nil,
        objectId: String,
        objectType: String = "activity",
        ownReactions: [FeedsReactionResponse] = [],
        parentId: String? = nil,
        reactionCount: Int = 0,
        reactionGroups: [String: ReactionGroupResponse?]? = nil,
        text: String = "Test comment",
        user: UserResponse = .dummy(id: "current-user-id")
    ) -> CommentResponse {
        CommentResponse(
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
            moderation: nil,
            objectId: objectId,
            objectType: objectType,
            ownReactions: ownReactions,
            parentId: parentId,
            reactionCount: reactionCount,
            reactionGroups: reactionGroups,
            replyCount: 2,
            score: 10,
            status: "active",
            text: text,
            updatedAt: Date(),
            upvoteCount: 3,
            user: user
        )
    }
}
