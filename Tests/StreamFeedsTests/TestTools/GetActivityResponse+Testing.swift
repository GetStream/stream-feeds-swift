//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension GetActivityResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        duration: String = "0.123s"
    ) -> GetActivityResponse {
        GetActivityResponse(
            activity: activity,
            duration: duration
        )
    }
}
