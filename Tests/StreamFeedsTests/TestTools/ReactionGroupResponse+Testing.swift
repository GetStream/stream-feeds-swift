//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ReactionGroupResponse {
    static func dummy(
        count: Int = 1,
        firstReactionAt: Date = Date(timeIntervalSince1970: 1_640_995_200),
        lastReactionAt: Date = Date(timeIntervalSince1970: 1_640_995_200),
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
