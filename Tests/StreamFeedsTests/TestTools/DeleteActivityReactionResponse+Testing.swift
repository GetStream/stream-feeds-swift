//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension DeleteActivityReactionResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        duration: String = "1.23ms",
        reaction: FeedsReactionResponse = .dummy()
    ) -> DeleteActivityReactionResponse {
        DeleteActivityReactionResponse(
            activity: activity,
            duration: duration,
            reaction: reaction
        )
    }
}
