//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FollowResponse {
    static func dummy(
        createdAt: Date = .fixed(),
        custom: [String: RawJSON]? = nil,
        followerRole: String = "user",
        pushPreference: FollowPushPreference = .all,
        requestAcceptedAt: Date? = nil,
        requestRejectedAt: Date? = nil,
        sourceFeed: FeedResponse = .dummy(),
        status: FollowStatus = .accepted,
        targetFeed: FeedResponse = .dummy(),
        updatedAt: Date = .fixed()
    ) -> FollowResponse {
        FollowResponse(
            createdAt: createdAt,
            custom: custom,
            followerRole: followerRole,
            pushPreference: pushPreference,
            requestAcceptedAt: requestAcceptedAt,
            requestRejectedAt: requestRejectedAt,
            sourceFeed: sourceFeed,
            status: status,
            targetFeed: targetFeed,
            updatedAt: updatedAt
        )
    }
}
