//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FollowResponse {
    static func dummy() -> FollowResponse {
        FollowResponse(
            createdAt: Date(timeIntervalSince1970: 1_640_995_200),
            custom: nil,
            followerRole: "user",
            pushPreference: .all,
            requestAcceptedAt: nil,
            requestRejectedAt: nil,
            sourceFeed: FeedResponse.dummy(),
            status: .accepted,
            targetFeed: FeedResponse.dummy(),
            updatedAt: Date(timeIntervalSince1970: 1_640_995_200)
        )
    }
}
