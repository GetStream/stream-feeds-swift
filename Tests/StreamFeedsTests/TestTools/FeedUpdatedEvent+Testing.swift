//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedUpdatedEvent {
    static func dummy(
        feed: FeedResponse = FeedResponse.dummy(),
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> FeedUpdatedEvent {
        FeedUpdatedEvent(
            createdAt: Date.fixed(),
            custom: [:],
            feed: feed,
            feedVisibility: nil,
            fid: feed.feed,
            receivedAt: Date.fixed(),
            user: user
        )
    }
}
