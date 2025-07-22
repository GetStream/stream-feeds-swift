//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct Feed_Tests {
    @Test func getOrCreateUpdatesState() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetOrCreateFeedResponse.dummy(activities: [.dummy(id: "1")])
            ])
        )
        let feed = client.feed(group: "user", id: "jane")
        let feedData = try await feed.getOrCreate()
        let stateActivities = await feed.state.activities
        let stateFeedData = await feed.state.feed
        #expect(stateActivities.map(\.id) == ["1"])
        #expect(stateFeedData == feedData)
    }
}
