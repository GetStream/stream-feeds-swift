//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedResponse {
    static func dummy(
        createdAt: Date = Date(timeIntervalSince1970: 1_640_995_200),
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
        updatedAt: Date = Date(timeIntervalSince1970: 1_640_995_200),
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

    // Backward compatibility method for old parameter order
    static func dummy(
        custom: [String: RawJSON] = [:],
        createdAt: Date = Date(timeIntervalSince1970: 1_640_995_200),
        feed: String = "user:test",
        id: String = "feed-123",
        name: String = "Test Feed"
    ) -> FeedResponse {
        dummy(
            createdAt: createdAt,
            custom: custom,
            feed: feed,
            id: id,
            name: name
        )
    }
}
