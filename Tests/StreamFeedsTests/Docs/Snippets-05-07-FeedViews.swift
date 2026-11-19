//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_05_07_FeedViews {
    var client: FeedsClient!

    func usingFeedViews() async throws {
        let query = FeedQuery(
            group: "user",
            id: "john",
            view: "<id of a feed view>" // Override the default view id
        )
        let feed = client.feed(for: query)
        try await feed.getOrCreate()
    }
}
