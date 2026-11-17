//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension AddActivityResponse {
    static func dummy(
        activity: ActivityResponse = .dummy()
    ) -> AddActivityResponse {
        AddActivityResponse(
            activity: activity
        )
    }
}
