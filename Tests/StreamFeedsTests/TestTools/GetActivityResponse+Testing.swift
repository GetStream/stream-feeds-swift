//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension GetActivityResponse {
    static func dummy(
        activity: ActivityResponse = .dummy()
    ) -> GetActivityResponse {
        GetActivityResponse(
            activity: activity
        )
    }
}
