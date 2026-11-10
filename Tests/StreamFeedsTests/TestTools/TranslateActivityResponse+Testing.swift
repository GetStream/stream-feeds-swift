//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension TranslateActivityResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        duration: String = "0.123s"
    ) -> TranslateActivityResponse {
        TranslateActivityResponse(
            activity: activity,
            duration: duration
        )
    }
}
