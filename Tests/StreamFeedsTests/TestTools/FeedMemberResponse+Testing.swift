//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension FeedMemberResponse {
    static func dummy() -> FeedMemberResponse {
        FeedMemberResponse(
            createdAt: Date(timeIntervalSince1970: 1_640_995_200),
            custom: nil,
            inviteAcceptedAt: nil,
            inviteRejectedAt: nil,
            role: "user",
            status: .member,
            updatedAt: Date(timeIntervalSince1970: 1_640_995_200),
            user: .dummy()
        )
    }
}
