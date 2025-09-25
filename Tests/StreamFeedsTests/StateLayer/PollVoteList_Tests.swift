//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct PollVoteList_Tests {
    static let pollId = "poll-123"
    
    @Test func initialGetUpdatesState() async throws {
        let client = defaultClient()
        let voteList = client.pollVoteList(
            for: PollVotesQuery(pollId: Self.pollId)
        )
        let votes = try await voteList.get()
        let stateVotes = await voteList.state.votes
        #expect(votes.map(\.id) == ["vote-1"])
        #expect(stateVotes.map(\.id) == ["vote-1"])
    }
    
    @Test func paginationLoadsMoreVotes() async throws {
        let client = defaultClient(
            additionalPayloads: [
                PollVotesResponse.dummy(
                    next: nil,
                    votes: [
                        .dummy(
                            createdAt: .fixed(offset: -1),
                            id: "vote-2",
                            pollId: Self.pollId,
                            user: .dummy(id: "user-2")
                        )
                    ]
                )
            ]
        )

        let voteList = client.pollVoteList(
            for: PollVotesQuery(pollId: Self.pollId)
        )
        
        // Initial load
        #expect(try await voteList.get().map(\.id) == ["vote-1"])
        #expect(await voteList.state.canLoadMore == true)
        
        // Load more
        let moreVotes = try await voteList.queryMorePollVotes()
        #expect(moreVotes.map(\.id) == ["vote-2"])
        #expect(await voteList.state.canLoadMore == false)
        
        // Check final state
        let finalStateVotes = await voteList.state.votes
        #expect(finalStateVotes.map(\.id) == ["vote-1", "vote-2"], "Newest first")
    }
    
    @Test func pollVoteChangedEventUpdatesState() async throws {
        let client = defaultClient()
        let voteList = client.pollVoteList(
            for: PollVotesQuery(pollId: Self.pollId)
        )
        try await voteList.get()
        
        // Send vote changed event
        await client.eventsMiddleware.sendEvent(
            PollVoteChangedFeedEvent.dummy(
                poll: .dummy(id: Self.pollId),
                vote: .dummy(
                    id: "vote-1",
                    optionId: "option-2",
                    pollId: Self.pollId,
                    updatedAt: .fixed(offset: 1),
                    user: .dummy(id: "user-1")
                ),
                fid: "user:test"
            )
        )
        
        let result = await voteList.state.votes.map(\.id)
        #expect(result == ["vote-1"]) // Vote should still be there but updated
        let updatedVote = await voteList.state.votes.first
        #expect(updatedVote?.optionId == "option-2")
        #expect(updatedVote?.updatedAt == .fixed(offset: 1))
    }
    
    @Test func pollVoteDeletedEventUpdatesState() async throws {
        let client = defaultClient()
        let voteList = client.pollVoteList(
            for: PollVotesQuery(pollId: Self.pollId)
        )
        try await voteList.get()
        
        // Send vote deleted event
        await client.eventsMiddleware.sendEvent(
            PollVoteRemovedFeedEvent.dummy(
                poll: .dummy(id: Self.pollId),
                vote: .dummy(id: "vote-1", pollId: Self.pollId, user: .dummy(id: "user-1")),
                fid: "user:test"
            )
        )
        
        let result = await voteList.state.votes.map(\.id)
        #expect(result == []) // Vote should be removed
    }
    
    @Test func eventsOnlyAffectMatchingPoll() async throws {
        let client = defaultClient()
        let voteList = client.pollVoteList(
            for: PollVotesQuery(pollId: Self.pollId)
        )
        try await voteList.get()
        
        // Send event for different poll
        await client.eventsMiddleware.sendEvent(
            PollVoteChangedFeedEvent.dummy(
                poll: .dummy(id: "poll-456"),
                vote: .dummy(id: "vote-2", pollId: "poll-456", user: .dummy(id: "user-1")),
                fid: "user:test"
            )
        )
        
        let result = await voteList.state.votes.map(\.id)
        #expect(result == ["vote-1"]) // Should not be affected
    }
    
    // MARK: -
    
    private func defaultClient(
        votes: [PollVoteResponseData] = [.dummy(id: "vote-1", pollId: Self.pollId, user: .dummy(id: "user-1"))],
        additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    PollVotesResponse.dummy(
                        next: "next-cursor",
                        votes: votes
                    )
                ] + additionalPayloads
            )
        )
    }
}
