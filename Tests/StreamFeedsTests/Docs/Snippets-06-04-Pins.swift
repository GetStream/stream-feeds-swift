//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_06_04_Pins {
    var client: FeedsClient!
    var feed: Feed!
    
    func overview() async throws {
        let activity = client.activity(
            for: "activity_123",
            in: FeedId(group: "user", id: "john")
        )
        // Pin an activity
        try await activity.pin()

        // Unpin an activity
        try await activity.unpin()
    }
    
    func overview2() async throws {
        try await feed.getOrCreate()
        print(feed.state.pinnedActivities)
    }
}
