//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ActivityAddedEvent {
    static func dummy(
        activity: ActivityResponse = ActivityResponse.dummy(),
        fid: String,
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
