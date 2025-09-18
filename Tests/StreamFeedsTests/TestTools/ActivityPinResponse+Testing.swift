//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ActivityPinResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        createdAt: Date = .fixed(),
        feed: String = "user:test",
        updatedAt: Date = .fixed(),
        user: UserResponse = .dummy()
    ) -> ActivityPinResponse {
        ActivityPinResponse(
            activity: activity,
            createdAt: createdAt,
            feed: feed,
            updatedAt: updatedAt,
            user: user
        )
    }
}
