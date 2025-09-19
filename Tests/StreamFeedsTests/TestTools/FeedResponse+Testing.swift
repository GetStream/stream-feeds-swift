//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedResponse {
    static func dummy(
        custom: [String: RawJSON] = [:],
        feed: String = "user:test",
        name: String = "Test Feed"
    ) -> FeedResponse {
        FeedResponse(
            createdAt: Date(timeIntervalSince1970: 1_640_995_200),
            createdBy: UserResponse.dummy(),
            custom: custom,
            deletedAt: nil,
            description: "Test feed description",
            feed: feed,
            filterTags: nil,
            followerCount: 50,
            followingCount: 25,
            groupId: "user",
            id: "feed-123",
            memberCount: 1,
            name: name,
            pinCount: 2,
            updatedAt: Date(timeIntervalSince1970: 1_640_995_200),
            visibility: "public"
        )
    }
}
