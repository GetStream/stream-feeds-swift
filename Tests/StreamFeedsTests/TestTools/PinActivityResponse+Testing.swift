//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PinActivityResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        createdAt: Date = Date.fixed(),
        feed: String,
        userId: String
    ) -> PinActivityResponse {
        PinActivityResponse(
            activity: activity,
            createdAt: createdAt,
            feed: feed,
            userId: userId
        )
    }
}
