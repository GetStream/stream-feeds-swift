//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UpdateActivityPartialResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        duration: String = "1.23ms"
    ) -> UpdateActivityPartialResponse {
        UpdateActivityPartialResponse(
            activity: activity,
            duration: duration
        )
    }
}
