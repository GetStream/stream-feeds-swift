//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FollowResponse {
    static func dummy(
        createdAt: Date = .fixed(),
        custom: [String: RawJSON]? = nil,
        followerRole: String = "user",
        pushPreference: FollowResponsePushPreference = .all,
        requestAcceptedAt: Date? = nil,
        requestRejectedAt: Date? = nil,
        sourceFeed: FeedResponse = .dummy(),
        status: FollowResponseStatus = .accepted,
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
