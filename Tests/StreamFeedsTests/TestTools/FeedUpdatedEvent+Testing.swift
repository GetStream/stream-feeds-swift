//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedUpdatedEvent {
    static func dummy(
        createdAt: Date = .fixed(),
        custom: [String: RawJSON] = [:],
        feed: FeedResponse = .dummy(),
        feedVisibility: String? = nil,
        fid: String = "user:test",
        receivedAt: Date? = nil,
        user: UserResponseCommonFields? = nil
    ) -> FeedUpdatedEvent {
        FeedUpdatedEvent(
            createdAt: createdAt,
            custom: custom,
            feed: feed,
            feedVisibility: feedVisibility,
            fid: fid,
            receivedAt: receivedAt,
            user: user
        )
    }
}
