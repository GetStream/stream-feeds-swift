//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension RejectFeedMemberInviteResponse {
    static func dummy(
        member: FeedMemberResponse
    ) -> RejectFeedMemberInviteResponse {
        RejectFeedMemberInviteResponse(
            member: member
        )
    }
}
