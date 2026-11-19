//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_05_08_CustomRanking {
    var client: FeedsClient!

    func inspectingRankingVariables() async throws {
        let feed = client.feed(
            for: FeedQuery(
                group: "timeline",
                id: "sara",
                enrichmentOptions: EnrichmentOptions(includeScoreVars: true)
            )
        )
        try await feed.getOrCreate()

        print(feed.state.activities[0].score)
        print(feed.state.activities[0].reactionCount)
        print(feed.state.activities[0].popularity)
        // The variables the ranking expression used, on freshly ranked pages
        print(feed.state.activities[0].scoreVariables ?? [:])
    }
}
