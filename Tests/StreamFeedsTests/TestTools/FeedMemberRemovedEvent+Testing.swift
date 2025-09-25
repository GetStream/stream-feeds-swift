//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedMemberRemovedEvent {
    static func dummy(
        createdAt: Date = .fixed(),
        custom: [String: RawJSON] = [:],
        feedVisibility: String? = nil,
        fid: String,
        memberId: String,
        receivedAt: Date? = nil,
        user: UserResponseCommonFields? = nil
    ) -> FeedMemberRemovedEvent {
        FeedMemberRemovedEvent(
            createdAt: createdAt,
            custom: custom,
            feedVisibility: feedVisibility,
            fid: fid,
            memberId: memberId,
            receivedAt: receivedAt,
            user: user
        )
    }
}
