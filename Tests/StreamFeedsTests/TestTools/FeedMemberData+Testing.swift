//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedMemberData {
    static func dummy(
        id: String = "member-1",
        user: UserData = .dummy(id: "user-1"),
        createdAt: Date = .fixed(),
        updatedAt: Date = .fixed(),
        custom: [String: RawJSON]? = nil,
        inviteAcceptedAt: Date? = nil,
        inviteRejectedAt: Date? = nil,
        role: String = "member",
        status: FeedMemberStatus = .member
    ) -> FeedMemberData {
        FeedMemberData(
            createdAt: createdAt,
            custom: custom,
            inviteAcceptedAt: inviteAcceptedAt,
            inviteRejectedAt: inviteRejectedAt,
            role: role,
            status: status,
            updatedAt: updatedAt,
            user: user
        )
    }
}
