//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension TranslateActivityResponse {
    static func dummy(
        activity: ActivityResponse = .dummy()
    ) -> TranslateActivityResponse {
        TranslateActivityResponse(
            activity: activity
        )
    }
}
