//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct PollList_Tests {
    @Test func initialGetUpdatesState() async throws {
        let client = defaultClient()
        let pollList = client.pollList(
            for: PollsQuery()
        )
        let polls = try await pollList.get()
        let statePolls = await pollList.state.polls
        #expect(polls.map(\.id) == ["poll-1"])
        #expect(statePolls.map(\.id) == ["poll-1"])
    }
    
    @Test func paginationLoadsMorePolls() async throws {
        let client = defaultClient(
            additionalPayloads: [
                QueryPollsResponse.dummy(
                    polls: [
                        .dummy(
                            createdAt: .fixed(offset: -1),
                            id: "poll-2",
                            name: "Poll 2"
                        )
                    ],
                    next: nil
                )
            ]
        )

        let pollList = client.pollList(
            for: PollsQuery()
        )
        
        // Initial load
        #expect(try await pollList.get().map(\.id) == ["poll-1"])
        #expect(await pollList.state.canLoadMore == true)
        
        // Load more
        let morePolls = try await pollList.queryMorePolls()
        #expect(morePolls.map(\.id) == ["poll-2"])
        #expect(await pollList.state.canLoadMore == false)
        
        // Check final state
        let finalStatePolls = await pollList.state.polls
        #expect(finalStatePolls.map(\.id) == ["poll-1", "poll-2"], "Newest first")
    }
    
    @Test func pollUpdatedEventUpdatesState() async throws {
        let client = defaultClient()
        let pollList = client.pollList(
            for: PollsQuery()
        )
        try await pollList.get()
        
        // Send poll updated event
        await client.eventsMiddleware.sendEvent(
            PollUpdatedFeedEvent.dummy(
                poll: .dummy(id: "poll-1", name: "Updated Poll", updatedAt: .fixed(offset: 1)),
                fid: "user:test"
            )
        )
        
        let result = await pollList.state.polls.map(\.id)
        #expect(result == ["poll-1"]) // Poll should still be there but updated
        let updatedPoll = await pollList.state.polls.first
        #expect(updatedPoll?.name == "Updated Poll")
        #expect(updatedPoll?.updatedAt == .fixed(offset: 1))
    }
    
    @Test func pollDeletedEventUpdatesState() async throws {
        let client = defaultClient()
        let pollList = client.pollList(
            for: PollsQuery()
        )
        try await pollList.get()
        
        // Send poll deleted event
        await client.eventsMiddleware.sendEvent(
            PollDeletedFeedEvent.dummy(
                pollId: "poll-1",
                fid: "user:test"
            )
        )
        
        let result = await pollList.state.polls.map(\.id)
        #expect(result == []) // Poll should be removed
    }
    
    @Test func pollVoteCastedEventUpdatesState() async throws {
        let client = defaultClient()
        let pollList = client.pollList(
            for: PollsQuery()
        )
        try await pollList.get()
        
        // Send poll vote casted event
        await client.eventsMiddleware.sendEvent(
            PollVoteCastedFeedEvent.dummy(
                poll: .dummy(id: "poll-1", name: "Poll 1", voteCount: 1),
                vote: .dummy(id: "vote-1", pollId: "poll-1", user: .dummy(id: "user-1")),
                fid: "user:test"
            )
        )
        
        let result = await pollList.state.polls.map(\.id)
        #expect(result == ["poll-1"]) // Poll should still be there but updated
        let updatedPoll = await pollList.state.polls.first
        #expect(updatedPoll?.voteCount == 1)
    }
    
    @Test func pollVoteChangedEventUpdatesState() async throws {
        let client = defaultClient()
        let pollList = client.pollList(
            for: PollsQuery()
        )
        try await pollList.get()
        
        // Send poll vote changed event
        await client.eventsMiddleware.sendEvent(
            PollVoteChangedFeedEvent.dummy(
                poll: .dummy(id: "poll-1", name: "Poll 1", voteCount: 1),
                vote: .dummy(id: "vote-1", optionId: "option-2", pollId: "poll-1", user: .dummy(id: "user-1")),
                fid: "user:test"
            )
        )
        
        let result = await pollList.state.polls.map(\.id)
        #expect(result == ["poll-1"]) // Poll should still be there but updated
        let updatedPoll = await pollList.state.polls.first
        #expect(updatedPoll?.voteCount == 1)
    }
    
    @Test func pollVoteDeletedEventUpdatesState() async throws {
        let client = defaultClient()
        let pollList = client.pollList(
            for: PollsQuery()
        )
        try await pollList.get()
        
        // Send poll vote deleted event
        await client.eventsMiddleware.sendEvent(
            PollVoteRemovedFeedEvent.dummy(
                poll: .dummy(id: "poll-1", name: "Poll 1", voteCount: 0),
                vote: .dummy(id: "vote-1", pollId: "poll-1", user: .dummy(id: "user-1")),
                fid: "user:test"
            )
        )
        
        let result = await pollList.state.polls.map(\.id)
        #expect(result == ["poll-1"]) // Poll should still be there but updated
        let updatedPoll = await pollList.state.polls.first
        #expect(updatedPoll?.voteCount == 0)
    }

    @Test func pollUpdatedEventRemovesPollWhenNoLongerMatchingQuery() async throws {
        let client = defaultClient(
            polls: [.dummy(id: "poll-1", name: "Test Poll")]
        )
        let pollList = client.pollList(
            for: PollsQuery(
                filter: .equal(.name, "Test Poll")
            )
        )
        try await pollList.get()

        // Verify initial state has the poll that matches the filter
        let initialPolls = await pollList.state.polls
        #expect(initialPolls.count == 1)
        #expect(initialPolls.first?.id == "poll-1")
        #expect(initialPolls.first?.name == "Test Poll")

        // Send poll updated event where the name changes to something that doesn't match the filter
        // This should cause the poll to no longer match the query filter
        await client.eventsMiddleware.sendEvent(
            PollUpdatedFeedEvent.dummy(
                poll: .dummy(id: "poll-1", name: "Updated Poll Name", updatedAt: .fixed(offset: 1)),
                fid: "user:test"
            )
        )

        // Poll should be removed since it no longer matches the name filter
        let pollsAfterUpdate = await pollList.state.polls
        #expect(pollsAfterUpdate.isEmpty)
    }
    
    // MARK: -
    
    private func defaultClient(
        polls: [PollResponseData] = [.dummy(id: "poll-1", name: "Poll 1")],
        additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryPollsResponse.dummy(
                        polls: polls,
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
