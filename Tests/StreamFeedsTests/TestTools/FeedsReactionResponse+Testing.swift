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
        createdAt: Date = Date.fixed(),
        custom: [String: RawJSON]? = nil,
        type: String = "like",
        user: UserResponse = .dummy(id: "current-user-id")
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
