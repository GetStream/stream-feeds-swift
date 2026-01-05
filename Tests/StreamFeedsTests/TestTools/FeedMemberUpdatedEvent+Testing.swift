//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedMemberUpdatedEvent {
    static func dummy(
        createdAt: Date = .fixed(),
        custom: [String: RawJSON] = [:],
        feedVisibility: String? = nil,
        fid: String,
        member: FeedMemberResponse,
        receivedAt: Date? = nil,
        user: UserResponseCommonFields? = nil
    ) -> FeedMemberUpdatedEvent {
        FeedMemberUpdatedEvent(
            createdAt: createdAt,
            custom: custom,
            feedVisibility: feedVisibility,
            fid: fid,
            member: member,
            receivedAt: receivedAt,
            user: user
        )
    }
}
