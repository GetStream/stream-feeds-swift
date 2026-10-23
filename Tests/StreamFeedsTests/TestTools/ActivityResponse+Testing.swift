//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ActivityResponse {
    static func dummy(
        bookmarkCount: Int = 0,
        comments: [CommentResponse] = [],
        createdAt: Date = .fixed(),
        editedAt: Date? = nil,
        currentFeed: FeedResponse? = FeedResponse.dummy(),
        expiresAt: Date? = nil,
        feeds: [String] = ["user:test"],
        id: String = "activity-123",
        latestReactions: [FeedsReactionResponse]? = nil,
        ownBookmarks: [BookmarkResponse] = [],
        ownReactions: [FeedsReactionResponse]? = nil,
        poll: PollResponseData? = nil,
        reactionCount: Int = 0,
        reactionGroups: [String: FeedsReactionGroupResponse] = [:],
        text: String = "Test activity content",
        type: String = "post",
        user: UserResponse = .dummy()
    ) -> ActivityResponse {
        ActivityResponse(
            attachments: [],
            bookmarkCount: bookmarkCount,
            collections: [:],
            commentCount: 1,
            comments: comments,
            createdAt: createdAt,
            currentFeed: currentFeed,
            custom: [:],
            deletedAt: nil,
            editedAt: editedAt,
            expiresAt: expiresAt,
            feeds: feeds,
            filterTags: [],
            hidden: false,
            id: id,
            interestTags: [],
            latestReactions: latestReactions ?? [],
            location: nil,
            mentionedUsers: [UserResponse.dummy()],
            moderation: nil,
            notificationContext: nil,
            ownBookmarks: ownBookmarks,
            ownReactions: ownReactions ?? [],
            parent: nil,
            poll: poll,
            popularity: 100,
            preview: false,
            reactionCount: reactionCount,
            reactionGroups: reactionGroups,
            restrictReplies: .everyone,
            score: 1.0,
            searchData: [:],
            shareCount: 3,
            text: text,
            type: type,
            updatedAt: createdAt,
            user: user,
            visibility: .public,
            visibilityTag: nil
        )
    }
}
