//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension AddReactionResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        reaction: FeedsReactionResponse = .dummy()
    ) -> AddReactionResponse {
        AddReactionResponse(
            activity: activity,
            reaction: reaction
        )
    }
}
