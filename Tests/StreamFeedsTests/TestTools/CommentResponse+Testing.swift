//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension CommentResponse {
    static func dummy(id: String = "comment-123") -> CommentResponse {
        CommentResponse(
            attachments: nil,
            confidenceScore: 0.95,
            controversyScore: nil,
            createdAt: Date(timeIntervalSince1970: 1_640_995_200),
            custom: nil,
            deletedAt: nil,
            downvoteCount: 0,
            id: id,
            latestReactions: nil,
            mentionedUsers: [UserResponse.dummy()],
            moderation: nil,
            objectId: "activity-123",
            objectType: "activity",
            ownReactions: [],
            parentId: nil,
            reactionCount: 5,
            reactionGroups: nil,
            replyCount: 2,
            score: 10,
            status: "active",
            text: "Test comment",
            updatedAt: Date(timeIntervalSince1970: 1_640_995_200),
            upvoteCount: 3,
            user: UserResponse.dummy()
        )
    }
}
