//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ActivityAddedEvent {
    static func dummy(
        fid: String = "test-feed-id",
        activity: ActivityResponse = ActivityResponse.dummy(),
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> ActivityAddedEvent {
        ActivityAddedEvent(
            activity: activity,
            createdAt: Date.fixed(),
            custom: [:],
            fid: fid,
            receivedAt: Date.fixed(),
            user: user
        )
    }
}
