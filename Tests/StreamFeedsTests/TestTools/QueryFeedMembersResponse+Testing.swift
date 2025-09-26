//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryFeedMembersResponse {
    static func dummy(
        duration: String = "1.23ms",
        members: [FeedMemberResponse] = [],
        next: String? = nil,
        prev: String? = nil
    ) -> QueryFeedMembersResponse {
        QueryFeedMembersResponse(
            duration: duration,
            members: members,
            next: next,
            prev: prev
        )
    }
}
