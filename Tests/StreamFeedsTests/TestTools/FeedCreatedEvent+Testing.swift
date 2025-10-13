//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedCreatedEvent {
    static func dummy(
        createdAt: Date = .fixed(),
        custom: [String: RawJSON] = [:],
        feed: FeedResponse = .dummy(),
        feedVisibility: String? = nil,
        fid: String = "user:test",
        members: [FeedMemberResponse] = [],
        receivedAt: Date? = nil,
        user: UserResponseCommonFields = .dummy()
    ) -> FeedCreatedEvent {
        FeedCreatedEvent(
            createdAt: createdAt,
            custom: custom,
            feed: feed,
            feedVisibility: feedVisibility,
            fid: fid,
            members: members,
            receivedAt: receivedAt,
            user: user
        )
    }
}
