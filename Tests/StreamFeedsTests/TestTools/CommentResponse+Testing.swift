//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentResponse {
    static func dummy(
        createdAt: Date = .fixed(),
        id: String = "comment-123",
        objectId: String = "activity-123",
        objectType: String = "activity",
        parentId: String? = nil,
        text: String = "Test comment"
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
            latestReactions: nil,
            mentionedUsers: [UserResponse.dummy()],
            moderation: nil,
            objectId: objectId,
            objectType: objectType,
            ownReactions: [],
            parentId: parentId,
            reactionCount: 5,
            reactionGroups: nil,
            replyCount: 2,
            score: 10,
            status: "active",
            text: text,
            updatedAt: Date(),
            upvoteCount: 3,
            user: UserResponse.dummy()
        )
    }
}
