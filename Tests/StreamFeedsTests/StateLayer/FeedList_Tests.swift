//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct FeedList_Tests {
    // MARK: - Actions

    @Test func getUpdatesState() async throws {
        let client = defaultClientWithFeedsResponses()
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
        let client = defaultClientWithFeedsResponses([
            QueryFeedsResponse.dummy(
                feeds: [
                    .dummy(id: "feed-3", name: "Third Feed", createdAt: Date.fixed()),
                    .dummy(id: "feed-4", name: "Fourth Feed", createdAt: Date.fixed())
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
        // The feeds should be sorted by createdAt in ascending order (oldest first)
        #expect(updatedState.map(\.id) == ["feed-3", "feed-4", "feed-1", "feed-2"])
        await #expect(feedList.state.canLoadMore == true)
        await #expect(feedList.state.pagination?.next == "next-cursor-2")
    }

    @Test func queryMoreFeedsWhenNoMoreFeedsReturnsEmpty() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                QueryFeedsResponse.dummy(
                    feeds: [
                        .dummy(id: "feed-1", name: "First Feed", createdAt: Date.fixed()),
                        .dummy(id: "feed-2", name: "Second Feed", createdAt: Date.fixed())
                    ],
                    next: nil
                )
            ])
        )
        let feedList = client.feedList(for: FeedsQuery())

        // Initial load
        _ = try await feedList.get()

        // Check pagination state
        let pagination = await feedList.state.pagination
        #expect(pagination?.next == nil)

        // Try to load more when no more available - should return empty array
        let moreFeeds = try await feedList.queryMoreFeeds()
        #expect(moreFeeds.isEmpty)
    }

    @Test func getWithEmptyResponseUpdatesState() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                QueryFeedsResponse.dummy(
                    feeds: [],
                    next: nil
                )
            ])
        )
        let feedList = client.feedList(for: FeedsQuery())
        let feeds = try await feedList.get()
        let stateFeeds = await feedList.state.feeds
        #expect(feeds.isEmpty)
        #expect(stateFeeds.isEmpty)
        await #expect(feedList.state.canLoadMore == false)
        await #expect(feedList.state.pagination?.next == nil)
    }

    // MARK: - WebSocket Events

    @Test func feedUpdatedEventUpdatesState() async throws {
        let client = defaultClientWithFeedsResponses()
        let feedList = client.feedList(for: FeedsQuery())
        try await feedList.get()

        let initialState = await feedList.state.feeds
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "feed-1" }?.name == "First Feed")

        // Send feed updated event
        await client.eventsMiddleware.sendEvent(
            FeedUpdatedEvent.dummy(
                feed: .dummy(id: "feed-1", name: "Updated First Feed", createdAt: Date.fixed()),
                fid: "user:test"
            )
        )

        let updatedState = await feedList.state.feeds
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "feed-1" }?.name == "Updated First Feed")
        #expect(updatedState.first { $0.id == "feed-2" }?.name == "Second Feed")
    }

    @Test func feedUpdatedEventForUnrelatedFeedDoesNotUpdateState() async throws {
        let client = defaultClientWithFeedsResponses()
        let feedList = client.feedList(for: FeedsQuery())
        try await feedList.get()

        let initialState = await feedList.state.feeds
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "feed-1" }?.name == "First Feed")

        // Send feed updated event for unrelated feed
        await client.eventsMiddleware.sendEvent(
            FeedUpdatedEvent.dummy(
                feed: .dummy(id: "unrelated-feed", name: "Unrelated Feed", createdAt: Date.fixed()),
                fid: "user:other"
            )
        )

        let updatedState = await feedList.state.feeds
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "feed-1" }?.name == "First Feed")
        #expect(updatedState.first { $0.id == "feed-2" }?.name == "Second Feed")
    }

    // MARK: - Helper Methods

    private func defaultClientWithFeedsResponses(
        _ additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryFeedsResponse.dummy(
                        feeds: [
                            .dummy(id: "feed-1", name: "First Feed", createdAt: Date.fixed()),
                            .dummy(id: "feed-2", name: "Second Feed", createdAt: Date.fixed())
                        ],
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
