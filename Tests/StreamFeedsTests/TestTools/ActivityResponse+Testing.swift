//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ActivityResponse {
    static func dummy(
        createdAt: Date = .fixed(),
        expiresAt: Date? = nil,
        feeds: [String] = ["user:test"],
        id: String = "activity-123",
        latestReactions: [FeedsReactionResponse]? = nil,
        ownReactions: [FeedsReactionResponse]? = nil,
        poll: PollResponseData? = nil,
        reactionCount: Int? = nil,
        reactionGroups: [String: ReactionGroupResponse]? = nil,
        text: String = "Test activity content"
    ) -> ActivityResponse {
        ActivityResponse(
            attachments: [],
            bookmarkCount: 0,
            commentCount: 1,
            comments: [CommentResponse.dummy()],
            createdAt: createdAt,
            currentFeed: FeedResponse.dummy(),
            custom: [:],
            deletedAt: nil,
            editedAt: nil,
            expiresAt: expiresAt,
            feeds: feeds,
            filterTags: [],
            id: id,
            interestTags: [],
            latestReactions: latestReactions ?? [],
            location: nil,
            mentionedUsers: [UserResponse.dummy()],
            moderation: nil,
            notificationContext: nil,
            ownBookmarks: [],
            ownReactions: ownReactions ?? [],
            parent: nil,
            poll: poll,
            popularity: 100,
            reactionCount: reactionCount ?? 25,
            reactionGroups: reactionGroups ?? [:],
            score: 1.0,
            searchData: [:],
            shareCount: 3,
            text: text,
            type: "post",
            updatedAt: createdAt,
            user: UserResponse.dummy(),
            visibility: .public,
            visibilityTag: nil
        )
    }
}
