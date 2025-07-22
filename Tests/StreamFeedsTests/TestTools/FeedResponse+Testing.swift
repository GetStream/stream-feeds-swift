//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedResponse {
    static func dummy() -> FeedResponse {
        FeedResponse(
            createdAt: Date(timeIntervalSince1970: 1_640_995_200),
            createdBy: UserResponse.dummy(),
            custom: nil,
            deletedAt: nil,
            description: "Test feed description",
            fid: "user:test",
            filterTags: nil,
            followerCount: 50,
            followingCount: 25,
            groupId: "user",
            id: "feed-123",
            memberCount: 1,
            name: "Test Feed",
            pinCount: 2,
            updatedAt: Date(timeIntervalSince1970: 1_640_995_200),
            visibility: "public"
        )
    }
}
