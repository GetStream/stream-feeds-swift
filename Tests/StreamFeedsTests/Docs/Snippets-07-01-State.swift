//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_07_01_State {
    var client: FeedsClient!
    var feed: Feed!
    
    func gettingFeedState() async throws {
        // Create a feed id
        let feedId = FeedId(group: "user", id: "john")

        // Create the feed instance from your client
        let feed = client.feed(for: feedId)

        // Get the latest data
        try await feed.getOrCreate()

        // Access the state
        let feedState = feed.state
        
        suppressUnusedWarning(feedState)
    }
    
    func activityState() async throws {
        // Create an activity instance
        let activity = client.activity(
            for: "activity-123",
            in: FeedId(group: "user", id: "john")
        )

        // Get the latest data
        try await activity.get()

        // Access the state
        let activityState = activity.state
        
        suppressUnusedWarning(activityState)
    }
}
