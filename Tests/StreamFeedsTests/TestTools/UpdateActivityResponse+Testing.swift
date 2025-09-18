//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UpdateActivityResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        duration: String = "1.23ms"
    ) -> UpdateActivityResponse {
        UpdateActivityResponse(
            activity: activity,
            duration: duration
        )
    }
}
