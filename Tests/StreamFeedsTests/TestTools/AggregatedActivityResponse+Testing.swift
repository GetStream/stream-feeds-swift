//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension AggregatedActivityResponse {
    static func dummy(
        activities: [ActivityResponse] = [.dummy()],
        activityCount: Int = 1,
        createdAt: Date = .fixed(),
        group: String = "like",
        score: Float = 1.0,
        updatedAt: Date = .fixed(),
        userCount: Int = 1,
        userCountTruncated: Bool = false
    ) -> AggregatedActivityResponse {
        AggregatedActivityResponse(
            activities: activities,
            activityCount: activityCount,
            createdAt: createdAt,
            group: group,
            score: score,
            updatedAt: updatedAt,
            userCount: userCount,
            userCountTruncated: userCountTruncated
        )
    }
}
