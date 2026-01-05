//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedResponse {
    static func dummy(
        id: String = "feed-1",
        name: String = "Test Feed",
        createdAt: Date = .fixed(),
        updatedAt: Date = .fixed(),
        createdBy: UserResponse = .dummy(),
        feed: String = "user:feed-1",
        custom: [String: RawJSON]? = nil,
        deletedAt: Date? = nil,
        description: String = "Test feed description",
        filterTags: [String]? = nil,
        followerCount: Int = 0,
        followingCount: Int = 0,
        groupId: String = "user",
        memberCount: Int = 0,
        ownCapabilities: [FeedOwnCapability]? = [.readFeed, .readActivities],
        pinCount: Int = 0,
        visibility: String? = nil
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
            ownCapabilities: ownCapabilities,
            ownFollows: nil,
            ownMembership: nil,
            pinCount: pinCount,
            updatedAt: updatedAt,
            visibility: visibility
        )
    }
}
