//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedMemberResponse {
    static func dummy(
        user: UserResponse = .dummy(),
        createdAt: Date = .fixed(),
        updatedAt: Date = .fixed(),
        custom: [String: RawJSON]? = nil,
        inviteAcceptedAt: Date? = nil,
        inviteRejectedAt: Date? = nil,
        role: String = "member",
        status: FeedMemberResponseStatus = .member
    ) -> FeedMemberResponse {
        FeedMemberResponse(
            createdAt: createdAt,
            custom: custom,
            inviteAcceptedAt: inviteAcceptedAt,
            inviteRejectedAt: inviteRejectedAt,
            membershipLevel: nil,
            role: role,
            status: status,
            updatedAt: updatedAt,
            user: user
        )
    }
}
