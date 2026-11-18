//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_05_09_InterestRanking {
    var client: FeedsClient!

    func interestWeights() async throws {
        let timeline = client.feed(
            for: FeedQuery(
                group: "timeline",
                id: "john",
                interestWeights: [
                    "travel": 1,
                    "food": 0.5,
                    "exercise": -1
                ]
            )
        )
        try await timeline.getOrCreate()
    }
}
