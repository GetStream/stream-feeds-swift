//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UnpinActivityResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        duration: String = "0.123s",
        feed: String = "user:jane",
        userId: String = "user-123"
    ) -> UnpinActivityResponse {
        UnpinActivityResponse(
            activity: activity,
            duration: duration,
            feed: feed,
            userId: userId
        )
    }
}
