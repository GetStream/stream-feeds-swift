//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_05_10_ExternalRanking {
    var client: FeedsClient!

    func providingExternalData() async throws {
        let timeline = client.feed(
            for: FeedQuery(
                group: "timeline",
                id: "john",
                externalRanking: [
                    "popularity_multiplier": 1, // normal weight for popularity
                    "share_multiplier": 100 // very high boost for share_count
                ]
            )
        )
        try await timeline.getOrCreate()
    }

    func mapLookup() async throws {
        let timeline = client.feed(
            for: FeedQuery(
                group: "timeline",
                id: "john",
                externalRanking: [
                    "stock_boosts": [
                        "apple": 0.9,
                        "tesla": 0.5,
                        "microsoft": 0.3
                    ]
                ]
            )
        )
        try await timeline.getOrCreate()
    }

    func mapSum() async throws {
        let timeline = client.feed(
            for: FeedQuery(
                group: "timeline",
                id: "john",
                externalRanking: [
                    "stock_boosts": [
                        "apple": 10.0,
                        "tesla": 5.0,
                        "microsoft": 2.0
                    ]
                ]
            )
        )
        try await timeline.getOrCreate()

        // score = popularity + 10.0 + 5.0 = popularity + 15.0 (for activity with stocks: ['apple', 'tesla'])
    }

    func arrayIntersection() async throws {
        let timeline = client.feed(
            for: FeedQuery(
                group: "timeline",
                id: "john",
                externalRanking: [
                    "watchlist": ["apple", "tesla", "microsoft"]
                ]
            )
        )
        try await timeline.getOrCreate()

        // activities with stocks in the watchlist get a +10 boost, others get no boost.
    }
}
