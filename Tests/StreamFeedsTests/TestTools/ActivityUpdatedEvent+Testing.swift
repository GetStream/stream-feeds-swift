//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ActivityUpdatedEvent {
    static func dummy(
        activity: ActivityResponse = ActivityResponse.dummy(),
        fid: String = "test-feed-id",
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
