//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedMemberResponse {
    static func dummy(
        createdAt: Date = .fixed(),
        updatedAt: Date = .fixed(),
        user: UserResponse
    ) -> FeedMemberResponse {
        FeedMemberResponse(
            createdAt: createdAt,
            custom: nil,
            inviteAcceptedAt: nil,
            inviteRejectedAt: nil,
            role: "user",
            status: .member,
            updatedAt: updatedAt,
            user: user
        )
    }
}
