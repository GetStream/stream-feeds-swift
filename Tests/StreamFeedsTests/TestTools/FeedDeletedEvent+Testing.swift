//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedDeletedEvent {
    static func dummy(
        feed: FeedResponse = FeedResponse.dummy(),
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> FeedDeletedEvent {
        FeedDeletedEvent(
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: feed.feed,
            receivedAt: Date.fixed(),
            user: user
        )
    }
}
