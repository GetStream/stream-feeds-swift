//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension GetOrCreateFeedResponse {
    static func dummy(
        activities: [ActivityResponse] = [ActivityResponse.dummy()],
        aggregatedActivities: [AggregatedActivityResponse] = [AggregatedActivityResponse.dummy()],
        created: Bool = false,
        duration: String = "0.123s",
        feed: FeedResponse = .dummy(),
        followers: [FollowResponse] = [],
        followersPagination: PagerResponse? = nil,
        following: [FollowResponse] = [],
        followingPagination: PagerResponse? = nil,
        memberPagination: PagerResponse? = nil,
        members: [FeedMemberResponse] = [FeedMemberResponse.dummy(user: .dummy(id: "feed-member-1"))],
        next: String? = "next-cursor",
        notificationStatus: NotificationStatusResponse? = .dummy(),
        pinnedActivities: [ActivityPinResponse] = [],
        prev: String? = nil
    ) -> GetOrCreateFeedResponse {
        GetOrCreateFeedResponse(
            activities: activities,
            aggregatedActivities: aggregatedActivities,
            created: created,
            duration: duration,
            feed: feed,
            followers: followers,
            followersPagination: followersPagination,
            following: following,
            followingPagination: followingPagination,
            memberPagination: memberPagination,
            members: members,
            next: next,
            notificationStatus: notificationStatus,
            pinnedActivities: pinnedActivities,
            prev: prev
        )
    }
}
