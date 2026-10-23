//
// Copyright © 2026 Stream.io Inc. All rights reserved.
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
            counterDelta: 1,
            duration: duration,
            outcome: "created",
            reaction: reaction
        )
    }
}
