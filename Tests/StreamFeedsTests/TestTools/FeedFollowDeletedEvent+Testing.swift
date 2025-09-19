//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

// Type alias for FollowDeletedEvent to match test expectations
typealias FeedFollowDeletedEvent = FollowDeletedEvent

extension FollowDeletedEvent {
    static func dummy(
        follow: FollowResponse = FollowResponse.dummy(),
        fid: String
    ) -> FollowDeletedEvent {
        FollowDeletedEvent(
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            follow: follow,
            receivedAt: Date.fixed()
        )
    }
}
