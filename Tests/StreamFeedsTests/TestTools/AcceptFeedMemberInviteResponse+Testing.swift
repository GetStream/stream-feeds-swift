//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension AcceptFeedMemberInviteResponse {
    static func dummy(
        duration: String = "1.23ms",
        member: FeedMemberResponse
    ) -> AcceptFeedMemberInviteResponse {
        AcceptFeedMemberInviteResponse(
            duration: duration,
            member: member
        )
    }
}
