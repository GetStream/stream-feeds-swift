//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ThreadedCommentResponse {
    static func dummy(
        createdAt: Date = .fixed(),
        id: String = "comment-123",
        text: String = "Test comment",
        objectId: String = "activity-123",
        objectType: String = "activity",
        parentId: String? = nil,
        replies: [ThreadedCommentResponse]? = nil
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
            latestReactions: nil,
            mentionedUsers: [UserResponse.dummy()],
            meta: nil,
            moderation: nil,
            objectId: objectId,
            objectType: objectType,
            ownReactions: [],
            parentId: parentId,
            reactionCount: 5,
            reactionGroups: nil,
            replies: replies,
            replyCount: replies?.count ?? 0,
            score: 10,
            status: "active",
            text: text,
            updatedAt: Date(),
            upvoteCount: 3,
            user: UserResponse.dummy()
        )
    }
}
