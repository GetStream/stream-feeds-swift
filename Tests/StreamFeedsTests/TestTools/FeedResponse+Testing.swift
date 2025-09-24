//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedResponse {
    static func dummy(
        createdAt: Date = Date.fixed(),
        createdBy: UserResponse = UserResponse.dummy(),
        custom: [String: RawJSON] = [:],
        deletedAt: Date? = nil,
        description: String = "Test feed description",
        feed: String = "user:test",
        filterTags: [String]? = nil,
        followerCount: Int = 50,
        followingCount: Int = 25,
        groupId: String = "user",
        id: String = "feed-123",
        memberCount: Int = 1,
        name: String = "Test Feed",
        ownFollows: [FollowResponse]? = nil,
        pinCount: Int = 2,
        updatedAt: Date = Date.fixed(),
        visibility: String? = "public"
    ) -> FeedResponse {
        FeedResponse(
            createdAt: createdAt,
            createdBy: createdBy,
            custom: custom,
            deletedAt: deletedAt,
            description: description,
            feed: feed,
            filterTags: filterTags,
            followerCount: followerCount,
            followingCount: followingCount,
            groupId: groupId,
            id: id,
            memberCount: memberCount,
            name: name,
            ownFollows: ownFollows,
            pinCount: pinCount,
            updatedAt: updatedAt,
            visibility: visibility
        )
    }
}
