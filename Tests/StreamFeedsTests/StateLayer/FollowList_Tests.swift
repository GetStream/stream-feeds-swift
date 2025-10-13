//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct FollowList_Tests {
    @Test func initialGetUpdatesState() async throws {
        let client = defaultClient()
        let followList = client.followList(
            for: FollowsQuery(filter: .equal(.sourceFeed, "user:current-user-id"))
        )
        let follows = try await followList.get()
        let stateFollows = await followList.state.follows
        #expect(follows.map(\.id) == ["user:current-user-id-user:user-1"])
        #expect(stateFollows.map(\.id) == ["user:current-user-id-user:user-1"])
    }
    
    @Test func paginationLoadsMoreFollows() async throws {
        let client = defaultClient(
            additionalPayloads: [
                QueryFollowsResponse.dummy(
                    follows: [
                        .dummy(
                            createdAt: .fixed(offset: -1),
                            sourceFeed: .dummy(feed: "user:current-user-id"),
                            targetFeed: .dummy(feed: "user:user-2")
                        )
                    ],
                    next: nil
                )
            ]
        )

        let followList = client.followList(
            for: FollowsQuery(filter: .equal(.sourceFeed, "user:current-user-id"))
        )
        
        // Initial load
        try await followList.get()
        #expect(await followList.state.follows.map(\.id) == ["user:current-user-id-user:user-1"])
        #expect(await followList.state.canLoadMore == true)
        
        // Load more
        let moreFollows = try await followList.queryMoreFollows()
        #expect(moreFollows.map(\.id) == ["user:current-user-id-user:user-2"])
        #expect(await followList.state.canLoadMore == false)
        
        // Check final state
        let finalStateFollows = await followList.state.follows
        #expect(finalStateFollows.map(\.id) == ["user:current-user-id-user:user-1", "user:current-user-id-user:user-2"], "Newest first")
    }
    
    @Test func feedFollowAddedEventUpdatesState() async throws {
        let client = defaultClient()
        let followList = client.followList(
            for: FollowsQuery(filter: .equal(.sourceFeed, "user:current-user-id"))
        )
        try await followList.get()
        
        // Send follow added event
        await client.eventsMiddleware.sendEvent(
            FollowCreatedEvent.dummy(
                follow: .dummy(
                    sourceFeed: .dummy(feed: "user:current-user-id"),
                    targetFeed: .dummy(feed: "user:user-2")
                ),
                fid: "user:test"
            )
        )
        
        let result = await followList.state.follows.map(\.id)
        #expect(result == ["user:current-user-id-user:user-2", "user:current-user-id-user:user-1"]) // New follow should be added
        let newFollow = await followList.state.follows.first
        #expect(newFollow?.targetFeed.feed.rawValue == "user:user-2")
    }
    
    @Test func feedFollowUpdatedEventUpdatesState() async throws {
        let client = defaultClient()
        let followList = client.followList(
            for: FollowsQuery(filter: .equal(.sourceFeed, "user:current-user-id"))
        )
        try await followList.get()
        
        // Send follow updated event
        await client.eventsMiddleware.sendEvent(
            FollowUpdatedEvent.dummy(
                follow: .dummy(
                    sourceFeed: .dummy(feed: "user:current-user-id"),
                    targetFeed: .dummy(feed: "user:user-1"),
                    updatedAt: .fixed(offset: 1)
                ),
                fid: "user:test"
            )
        )
        
        let result = await followList.state.follows.map(\.id)
        #expect(result == ["user:current-user-id-user:user-1"]) // Follow should still be there but updated
        let updatedFollow = await followList.state.follows.first
        #expect(updatedFollow?.updatedAt == .fixed(offset: 1))
    }
    
    @Test func feedFollowDeletedEventUpdatesState() async throws {
        let client = defaultClient()
        let followList = client.followList(
            for: FollowsQuery(filter: .equal(.sourceFeed, "user:current-user-id"))
        )
        try await followList.get()
        
        // Send follow deleted event
        await client.eventsMiddleware.sendEvent(
            FollowDeletedEvent.dummy(
                follow: .dummy(
                    sourceFeed: .dummy(feed: "user:current-user-id"),
                    targetFeed: .dummy(feed: "user:user-1")
                ),
                fid: "user:test"
            )
        )
        
        let result = await followList.state.follows.map(\.id)
        #expect(result == []) // Follow should be removed
    }

    @Test func feedFollowUpdatedEventRemovesFollowWhenNoLongerMatchingQuery() async throws {
        let client = defaultClient(
            follows: [.dummy(
                sourceFeed: .dummy(feed: "user:current-user-id"),
                status: .accepted,
                targetFeed: .dummy(feed: "user:user-1")
            )]
        )
        let followList = client.followList(
            for: FollowsQuery(filter: .equal(.status, FollowStatus.accepted.rawValue))
        )
        try await followList.get()

        // Verify initial state has the follow that matches the filter
        let initialFollows = await followList.state.follows
        #expect(initialFollows.count == 1)
        #expect(initialFollows.first?.id == "user:current-user-id-user:user-1")
        #expect(initialFollows.first?.status == .accepted)

        // Send follow updated event where the status changes to something that doesn't match the filter
        // This should cause the follow to no longer match the query filter
        await client.eventsMiddleware.sendEvent(
            FollowUpdatedEvent.dummy(
                follow: .dummy(
                    sourceFeed: .dummy(feed: "user:current-user-id"),
                    status: .rejected,
                    targetFeed: .dummy(feed: "user:user-1"),
                    updatedAt: .fixed(offset: 1)
                ),
                fid: "user:test"
            )
        )

        // Follow should be removed since it no longer matches the status filter
        let followsAfterUpdate = await followList.state.follows
        #expect(followsAfterUpdate.isEmpty)
    }
    
    // MARK: -
    
    private func defaultClient(
        follows: [FollowResponse] = [.dummy(sourceFeed: .dummy(feed: "user:current-user-id"), targetFeed: .dummy(feed: "user:user-1"))],
        additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryFollowsResponse.dummy(
                        follows: follows,
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
