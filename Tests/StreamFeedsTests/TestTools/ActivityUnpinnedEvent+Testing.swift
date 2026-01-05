//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ActivityUnpinnedEvent {
    static func dummy(
        pinnedActivity: PinActivityResponse,
        fid: String,
        user: UserResponseCommonFields? = UserResponseCommonFields.dummy()
    ) -> ActivityUnpinnedEvent {
        ActivityUnpinnedEvent(
            createdAt: Date.fixed(),
            custom: [:],
            feedVisibility: nil,
            fid: fid,
            pinnedActivity: pinnedActivity,
            receivedAt: Date.fixed(),
            user: user
        )
    }
}
