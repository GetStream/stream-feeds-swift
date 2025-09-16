//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedsReactionResponse {
    static func dummy(
        activityId: String = "activity-123",
        commentId: String? = nil,
        createdAt: Date = Date(timeIntervalSince1970: 1_640_995_200),
        custom: [String: RawJSON]? = nil,
        type: String = "like",
        user: UserResponse = .dummy()
    ) -> FeedsReactionResponse {
        FeedsReactionResponse(
            activityId: activityId,
            commentId: commentId,
            createdAt: createdAt,
            custom: custom,
            type: type,
            updatedAt: createdAt,
            user: user
        )
    }
}
