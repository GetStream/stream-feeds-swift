//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ReactionGroupResponse {
    static func dummy(
        count: Int = 1,
        firstReactionAt: Date = .fixed(),
        lastReactionAt: Date = .fixed(),
        sumScores: Int? = nil
    ) -> ReactionGroupResponse {
        ReactionGroupResponse(
            count: count,
            firstReactionAt: firstReactionAt,
            lastReactionAt: lastReactionAt,
            sumScores: sumScores
        )
    }
}
