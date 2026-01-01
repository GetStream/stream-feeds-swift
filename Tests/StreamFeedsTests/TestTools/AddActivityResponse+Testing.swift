//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension AddActivityResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        duration: String = "1.23ms"
    ) -> AddActivityResponse {
        AddActivityResponse(
            activity: activity,
            duration: duration
        )
    }
}
