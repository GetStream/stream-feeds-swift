//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ActivityUpdatedEvent {
    static func dummy(
        fid: String = "test-feed-id",
        activity: ActivityResponse = ActivityResponse.dummy(),
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> ActivityUpdatedEvent {
        ActivityUpdatedEvent(
            activity: activity,
            createdAt: Date(),
            custom: [:],
            fid: fid,
            receivedAt: Date(),
            user: user
        )
    }
}
