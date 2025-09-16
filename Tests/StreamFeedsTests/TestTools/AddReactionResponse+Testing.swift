//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension AddReactionResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        duration: String = "1.23ms",
        reaction: FeedsReactionResponse = .dummy()
    ) -> AddReactionResponse {
        AddReactionResponse(
            activity: activity,
            duration: duration,
            reaction: reaction
        )
    }
}
