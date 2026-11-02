//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedsReactionGroupResponse {
    static func dummy(
        count: Int = 1,
        firstReactionAt: Date = .fixed(),
        lastReactionAt: Date = .fixed()
    ) -> FeedsReactionGroupResponse {
        FeedsReactionGroupResponse(
            count: count,
            firstReactionAt: firstReactionAt,
            lastReactionAt: lastReactionAt
        )
    }
}
