//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ActivityResponse {
    static func dummy(
        id: String = "activity-123",
        text: String = "Test activity content"
    ) -> ActivityResponse {
        ActivityResponse(
            attachments: [],
            bookmarkCount: 0,
            commentCount: 1,
            comments: [CommentResponse.dummy()],
            createdAt: Date(timeIntervalSince1970: 1_640_995_200), // 2022-01-01
            currentFeed: FeedResponse.dummy(),
            custom: [:],
            deletedAt: nil,
            editedAt: nil,
            expiresAt: nil,
            feeds: ["user:test"],
            filterTags: [],
            id: id,
            interestTags: [],
            latestReactions: [],
            location: nil,
            mentionedUsers: [UserResponse.dummy()],
            moderation: nil,
            object: nil,
            ownBookmarks: [],
            ownReactions: [],
            parent: nil,
            poll: nil,
            popularity: 100,
            reactionCount: 25,
            reactionGroups: [:],
            score: 1.0,
            searchData: [:],
            shareCount: 3,
            text: text,
            type: "post",
            updatedAt: Date(timeIntervalSince1970: 1_640_995_200),
            user: UserResponse.dummy(),
            visibility: .public,
            visibilityTag: nil
        )
    }
}
