//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PinActivityResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        createdAt: Date = Date(timeIntervalSince1970: 1_640_995_200),
        duration: String = "0.123s",
        feed: String,
        userId: String
    ) -> PinActivityResponse {
        PinActivityResponse(
            activity: activity,
            createdAt: createdAt,
            duration: duration,
            feed: feed,
            userId: userId
        )
    }
}
