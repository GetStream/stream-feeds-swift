//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedSuggestionResponse {
    static func dummy(
        feed: String = "user:feed-1"
    ) -> FeedSuggestionResponse {
        FeedSuggestionResponse(
            activityCount: 0,
            createdAt: .fixed(),
            createdBy: .dummy(),
            description: "Test feed description",
            feed: feed,
            followerCount: 0,
            followingCount: 0,
            groupId: "user",
            id: "feed-1",
            memberCount: 0,
            name: "Test Feed",
            pinCount: 0,
            updatedAt: .fixed()
        )
    }
}
