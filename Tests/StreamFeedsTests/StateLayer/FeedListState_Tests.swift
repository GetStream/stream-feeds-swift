//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct FeedListState_Tests {
    // MARK: - Actions

    @Test func getUpdatesState() async throws {
        let client = defaultClientWithFeedResponses()
        let feedList = client.feedList(for: FeedsQuery())
        let feeds = try await feedList.get()
        let stateFeeds = await feedList.state.feeds
        #expect(feeds.count == 2)
        #expect(stateFeeds.count == 2)
        #expect(stateFeeds.map(\.id) == ["feed-1", "feed-2"])
        #expect(feeds.map(\.id) == stateFeeds.map(\.id))
        await #expect(feedList.state.canLoadMore == true)
        await #expect(feedList.state.pagination?.next == "next-cursor")
    }

    @Test func queryMoreFeedsUpdatesState() async throws {
        let client = defaultClientWithFeedResponses([
            QueryFeedsResponse.dummy(
                feeds: [
                    .dummy(id: "feed-3", name: "Test Feed 3"),
                    .dummy(id: "feed-4", name: "Test Feed 4")
                ],
                next: "next-cursor-2"
            )
        ])
        let feedList = client.feedList(for: FeedsQuery())

        // Initial load
        _ = try await feedList.get()
        let initialState = await feedList.state.feeds
        #expect(initialState.count == 2)
        #expect(initialState.map(\.id) == ["feed-1", "feed-2"])

        // Load more
        let moreFeeds = try await feedList.queryMoreFeeds()
        let updatedState = await feedList.state.feeds
        #expect(moreFeeds.count == 2)
        #expect(moreFeeds.map(\.id) == ["feed-3", "feed-4"])
        #expect(updatedState.count == 4)
        await #expect(feedList.state.canLoadMore == true)
        await #expect(feedList.state.pagination?.next == "next-cursor-2")
    }

    // MARK: - WebSocket Events

    @Test func feedUpdatedEventUpdatesState() async throws {
        let client = defaultClientWithFeedResponses()
        let feedList = client.feedList(for: FeedsQuery())

        // Initial load
        _ = try await feedList.get()
        let initialState = await feedList.state.feeds
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "feed-1" }?.name == "Test Feed 1")

        // Send feed updated event
        let updatedFeed = FeedResponse.dummy(id: "feed-1", name: "Updated Feed Name").toModel()
        await client.stateLayerEventPublisher.sendEvent(.feedUpdated(updatedFeed, FeedId(rawValue: "user:feed-1")))

        // Wait a bit for the event to be processed
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        let updatedState = await feedList.state.feeds
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "feed-1" }?.name == "Updated Feed Name")
    }

    // MARK: - Helper Methods

    private func defaultClientWithFeedResponses(
        _ additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryFeedsResponse.dummy(
                        feeds: [
                            .dummy(id: "feed-1", name: "Test Feed 1"),
                            .dummy(id: "feed-2", name: "Test Feed 2")
                        ],
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
