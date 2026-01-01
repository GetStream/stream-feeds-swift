//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension RejectFeedMemberInviteResponse {
    static func dummy(
        duration: String = "1.23ms",
        member: FeedMemberResponse
    ) -> RejectFeedMemberInviteResponse {
        RejectFeedMemberInviteResponse(
            duration: duration,
            member: member
        )
    }
}
