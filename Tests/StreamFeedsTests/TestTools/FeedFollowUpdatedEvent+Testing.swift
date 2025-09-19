//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

// Type alias for FollowUpdatedEvent to match test expectations
typealias FeedFollowUpdatedEvent = FollowUpdatedEvent

extension FollowUpdatedEvent {
    static func dummy(
        follow: FollowResponse = FollowResponse.dummy(),
        fid: String
    ) -> FollowUpdatedEvent {
        FollowUpdatedEvent(
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            follow: follow,
            receivedAt: Date.fixed()
        )
    }
}
