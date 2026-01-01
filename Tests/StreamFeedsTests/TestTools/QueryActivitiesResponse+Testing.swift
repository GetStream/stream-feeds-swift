//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryActivitiesResponse {
    static func dummy(
        activities: [ActivityResponse],
        duration: String = "0.123s",
        next: String? = nil,
        prev: String? = nil
    ) -> QueryActivitiesResponse {
        QueryActivitiesResponse(
            activities: activities,
            duration: duration,
            next: next,
            prev: prev
        )
    }
}
