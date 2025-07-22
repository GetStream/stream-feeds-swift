//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension GetOrCreateFeedResponse {
    static func dummy(
        activities: [ActivityResponse] = [ActivityResponse.dummy()]
    ) -> GetOrCreateFeedResponse {
        GetOrCreateFeedResponse(
            activities: activities,
            aggregatedActivities: [],
            created: false,
            duration: "0.123s",
            feed: FeedResponse.dummy(),
            followers: [FollowResponse.dummy()],
            followersPagination: PagerResponse.dummy(),
            following: [FollowResponse.dummy()],
            followingPagination: PagerResponse.dummy(),
            memberPagination: PagerResponse.dummy(),
            members: [FeedMemberResponse.dummy()],
            next: "next-cursor",
            notificationStatus: nil,
            ownCapabilities: FeedOwnCapability.allCases,
            ownFollows: [FollowResponse.dummy()],
            ownMembership: FeedMemberResponse.dummy(),
            pinnedActivities: [],
            prev: nil
        )
    }
}
