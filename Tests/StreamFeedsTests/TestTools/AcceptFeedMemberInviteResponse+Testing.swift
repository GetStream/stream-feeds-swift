//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension AcceptFeedMemberInviteResponse {
    static func dummy(
        member: FeedMemberResponse
    ) -> AcceptFeedMemberInviteResponse {
        AcceptFeedMemberInviteResponse(
            member: member
        )
    }
}
