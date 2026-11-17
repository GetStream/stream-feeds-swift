//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension RestoreActivityResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        duration: String = "1.23ms"
    ) -> RestoreActivityResponse {
        RestoreActivityResponse(
            activity: activity,
            duration: duration
        )
    }
}
