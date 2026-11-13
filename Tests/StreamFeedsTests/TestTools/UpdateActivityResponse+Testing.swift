//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UpdateActivityResponse {
    static func dummy(
        activity: ActivityResponse = .dummy()
    ) -> UpdateActivityResponse {
        UpdateActivityResponse(
            activity: activity
        )
    }
}
