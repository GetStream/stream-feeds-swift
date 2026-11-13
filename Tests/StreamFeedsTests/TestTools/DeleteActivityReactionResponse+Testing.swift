//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension DeleteActivityReactionResponse {
    static func dummy(
        activity: ActivityResponse = .dummy(),
        reaction: FeedsReactionResponse = .dummy()
    ) -> DeleteActivityReactionResponse {
        DeleteActivityReactionResponse(
            activity: activity,
            reaction: reaction
        )
    }
}
