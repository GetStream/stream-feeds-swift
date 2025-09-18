//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ActivityDeletedEvent {
    static func dummy(
        activityId: String = "test-activity-id",
        fid: String,
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> ActivityDeletedEvent {
        ActivityDeletedEvent(
            activity: ActivityResponse.dummy(id: activityId),
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            receivedAt: Date.fixed(),
            user: user
        )
    }
}
