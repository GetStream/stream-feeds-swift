//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UpdateFeedMembersResponse {
    static func dummy(
        added: [FeedMemberResponse] = [.dummy(user: .dummy(id: "feed-member-1"))],
        removedIds: [String] = [],
        updated: [FeedMemberResponse] = []
    ) -> UpdateFeedMembersResponse {
        UpdateFeedMembersResponse(
            added: added,
            removedIds: removedIds,
            updated: updated
        )
    }
}
