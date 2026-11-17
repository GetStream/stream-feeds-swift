//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension QueryFeedMembersResponse {
    static func dummy(
        members: [FeedMemberResponse] = [],
        next: String? = nil,
        prev: String? = nil
    ) -> QueryFeedMembersResponse {
        QueryFeedMembersResponse(
            members: members,
            next: next,
            prev: prev
        )
    }
}
