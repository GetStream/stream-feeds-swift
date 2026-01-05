//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ActivityPinnedEvent {
    static func dummy(
        activity: ActivityResponse = ActivityResponse.dummy(),
        fid: String,
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> ActivityPinnedEvent {
        ActivityPinnedEvent(
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            pinnedActivity: PinActivityResponse.dummy(activity: activity, feed: fid, userId: user?.id ?? "test-user-id"),
            receivedAt: Date.fixed(),
            user: user
        )
    }
}
