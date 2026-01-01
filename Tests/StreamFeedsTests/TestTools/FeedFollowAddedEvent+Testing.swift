//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

// Type alias for FollowCreatedEvent to match test expectations
typealias FeedFollowAddedEvent = FollowCreatedEvent

extension FollowCreatedEvent {
    static func dummy(
        follow: FollowResponse = FollowResponse.dummy(),
        fid: String
    ) -> FollowCreatedEvent {
        FollowCreatedEvent(
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            follow: follow,
            receivedAt: Date.fixed()
        )
    }
}
