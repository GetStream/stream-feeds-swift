//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryActivitiesResponse {
    static func dummy(
        activities: [ActivityResponse],
        next: String? = nil,
        prev: String? = nil
    ) -> QueryActivitiesResponse {
        QueryActivitiesResponse(
            activities: activities,
            next: next,
            prev: prev
        )
    }
}
