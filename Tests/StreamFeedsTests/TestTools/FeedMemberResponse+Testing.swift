//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedMemberResponse {
    static func dummy(
        user: UserResponse
    ) -> FeedMemberResponse {
        FeedMemberResponse(
            createdAt: Date.fixed(),
            custom: nil,
            inviteAcceptedAt: nil,
            inviteRejectedAt: nil,
            role: "user",
            status: .member,
            updatedAt: Date.fixed(),
            user: user
        )
    }
}
