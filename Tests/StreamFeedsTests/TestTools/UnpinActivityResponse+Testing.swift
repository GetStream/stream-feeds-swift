//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UnpinActivityResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        feed: String = "user:jane",
        userId: String = "user-123"
    ) -> UnpinActivityResponse {
        UnpinActivityResponse(
            activity: activity,
            feed: feed,
            userId: userId
        )
    }
}
