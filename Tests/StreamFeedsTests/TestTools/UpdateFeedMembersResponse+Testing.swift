//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UpdateFeedMembersResponse {
    static func dummy(
        added: [FeedMemberResponse] = [.dummy(user: .dummy(id: "feed-member-1"))],
        duration: String = "1.23ms",
        removedIds: [String] = [],
        updated: [FeedMemberResponse] = []
    ) -> UpdateFeedMembersResponse {
        UpdateFeedMembersResponse(
            added: added,
            duration: duration,
            removedIds: removedIds,
            updated: updated
        )
    }
}
