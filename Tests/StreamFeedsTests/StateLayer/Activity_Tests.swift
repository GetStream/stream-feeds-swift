//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct Activity_Tests {
    // MARK: - Actions
    
    @Test func getOrCreateUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses()
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        let activityData = try await activity.get()
        let stateActivity = try #require(await activity.state.activity)
        #expect(stateActivity.id == "activity-123")
        #expect(stateActivity.text == "Test activity content")
        #expect(stateActivity == activityData)
        await #expect(activity.state.comments.map(\.id) == ["comment-1", "comment-2"])
        let statePoll = try #require(await activity.state.poll)
        #expect(statePoll.id == "poll-123")
        #expect(statePoll.name == "Test Poll")
        #expect(statePoll.options.map(\.id) == ["option-1", "option-2"])
    }
    
    @Test func pinUpdatesState() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    PinActivityResponse.dummy(
                        activity: .dummy(id: "activity-123", text: "Pinned activity"),
                        feed: "user:jane"
                    )
                ]
            )
        )
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        await #expect(activity.state.activity == nil)
        try await activity.pin()
        
        let stateActivity = try #require(await activity.state.activity)
        #expect(stateActivity.id == "activity-123")
        #expect(stateActivity.text == "Pinned activity")
    }
    
    @Test func unpinUpdatesState() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    UnpinActivityResponse.dummy(
                        activity: .dummy(id: "activity-123", text: "Unpinned activity"),
                        feed: "user:jane"
                    )
                ]
            )
        )
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        await #expect(activity.state.activity == nil)
        try await activity.unpin()
        
        let stateActivity = try #require(await activity.state.activity)
        #expect(stateActivity.id == "activity-123")
        #expect(stateActivity.text == "Unpinned activity")
    }
    
    @Test func closePollUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses([
            PollResponse.dummy(
                poll: .dummy(
                    id: "poll-123",
                    isClosed: true,
                    name: "Test Poll",
                    options: [
                        .dummy(id: "option-1", text: "Option 1"),
                        .dummy(id: "option-2", text: "Option 2")
                    ],
                    ownVotes: [
                        .dummy(id: "vote-1", optionId: "option-1", pollId: "poll-123")
                    ],
                    voteCount: 1,
                    voteCountsByOption: ["option-1": 1, "option-2": 0]
                )
            )
        ])
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        try await activity.get()
        
        let poll = try await activity.closePoll()
        let statePoll = try #require(await activity.state.poll)
        #expect(poll.id == "poll-123")
        #expect(poll.isClosed == true)
        #expect(statePoll.id == "poll-123")
        #expect(statePoll.isClosed == true)
    }
    
    @Test func deletePollUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses([
            Response.dummy()
        ])
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        try await activity.get()
        
        // Verify poll exists initially
        let initialPoll = try #require(await activity.state.poll)
        #expect(initialPoll.id == "poll-123")
        
        try await activity.deletePoll()
        
        // Verify poll is removed from state
        let finalPoll = await activity.state.poll
        #expect(finalPoll == nil)
    }
    
    @Test func getPollUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses([
            PollResponse.dummy(
                poll: .dummy(
                    id: "poll-123",
                    name: "Updated Poll",
                    options: [
                        .dummy(id: "option-1", text: "Option 1"),
                        .dummy(id: "option-2", text: "Option 2")
                    ],
                    ownVotes: [
                        .dummy(id: "vote-1", optionId: "option-1", pollId: "poll-123")
                    ],
                    voteCount: 1,
                    voteCountsByOption: ["option-1": 1, "option-2": 0]
                )
            )
        ])
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        try await activity.get()
        
        let poll = try await activity.getPoll()
        let statePoll = try #require(await activity.state.poll)
        #expect(poll.id == "poll-123")
        #expect(poll.name == "Updated Poll")
        #expect(statePoll.id == "poll-123")
        #expect(statePoll.name == "Updated Poll")
    }
    
    @Test func updatePollPartialUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses([
            PollResponse.dummy(
                poll: .dummy(
                    id: "poll-123",
                    name: "Partially Updated Poll",
                    options: [
                        .dummy(id: "option-1", text: "Option 1"),
                        .dummy(id: "option-2", text: "Option 2")
                    ],
                    ownVotes: [
                        .dummy(id: "vote-1", optionId: "option-1", pollId: "poll-123")
                    ],
                    voteCount: 1,
                    voteCountsByOption: ["option-1": 1, "option-2": 0]
                )
            )
        ])
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        try await activity.get()
        
        let poll = try await activity.updatePollPartial(request: .init(set: ["name": .string("Partially Updated Poll")]))
        let statePoll = try #require(await activity.state.poll)
        #expect(poll.id == "poll-123")
        #expect(poll.name == "Partially Updated Poll")
        #expect(statePoll.id == "poll-123")
        #expect(statePoll.name == "Partially Updated Poll")
    }
    
    @Test func updatePollUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses([
            PollResponse.dummy(
                poll: .dummy(
                    id: "poll-123",
                    name: "Fully Updated Poll",
                    options: [
                        .dummy(id: "option-1", text: "Option 1"),
                        .dummy(id: "option-2", text: "Option 2")
                    ],
                    ownVotes: [
                        .dummy(id: "vote-1", optionId: "option-1", pollId: "poll-123")
                    ],
                    voteCount: 1,
                    voteCountsByOption: ["option-1": 1, "option-2": 0]
                )
            )
        ])
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        try await activity.get()
        
        let poll = try await activity.updatePoll(request: .init(id: "poll-123", name: "Fully Updated Poll"))
        let statePoll = try #require(await activity.state.poll)
        #expect(poll.id == "poll-123")
        #expect(poll.name == "Fully Updated Poll")
        #expect(statePoll.id == "poll-123")
        #expect(statePoll.name == "Fully Updated Poll")
    }
    
    @Test func createPollOptionUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses([
            PollOptionResponse.dummy(
                pollOption: .dummy(id: "option-3", text: "New Option")
            )
        ])
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        try await activity.get()
        
        let option = try await activity.createPollOption(request: .init(text: "New Option"))
        let statePoll = try #require(await activity.state.poll)
        #expect(option.id == "option-3")
        #expect(option.text == "New Option")
        #expect(statePoll.options.count == 3)
        #expect(statePoll.options.contains { $0.id == "option-3" })
    }
    
    @Test func deletePollOptionUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses([
            StreamFeeds.Response.dummy()
        ])
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        try await activity.get()
        
        // Verify option exists initially
        let initialPoll = try #require(await activity.state.poll)
        #expect(initialPoll.options.count == 2)
        #expect(initialPoll.options.contains { $0.id == "option-1" })
        
        try await activity.deletePollOption(optionId: "option-1")
        
        // Verify option is removed from state
        let finalPoll = try #require(await activity.state.poll)
        #expect(finalPoll.options.count == 1)
        #expect(!finalPoll.options.contains { $0.id == "option-1" })
    }
    
    @Test func getPollOptionUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses([
            PollOptionResponse.dummy(
                pollOption: .dummy(id: "option-1", text: "Updated Option 1")
            )
        ])
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        try await activity.get()
        
        let option = try await activity.getPollOption(optionId: "option-1", userId: nil)
        let statePoll = try #require(await activity.state.poll)
        #expect(option.id == "option-1")
        #expect(option.text == "Updated Option 1")
        #expect(statePoll.options.first { $0.id == "option-1" }?.text == "Updated Option 1")
    }
    
    @Test func updatePollOptionUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses([
            PollOptionResponse.dummy(
                pollOption: .dummy(id: "option-1", text: "Updated Option 1")
            )
        ])
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        try await activity.get()
        
        let option = try await activity.updatePollOption(request: .init(id: "option-1", text: "Updated Option 1"))
        let statePoll = try #require(await activity.state.poll)
        #expect(option.id == "option-1")
        #expect(option.text == "Updated Option 1")
        #expect(statePoll.options.first { $0.id == "option-1" }?.text == "Updated Option 1")
    }
    
    @Test func castPollVoteUpdatesStateWhenEnforceUniqueVotes() async throws {
        let client = defaultClientWithActivityAndCommentsResponses([
            PollVoteResponse.dummy(
                vote: .dummy(id: "vote-2", optionId: "option-2", pollId: "poll-123")
            )
        ])
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        try await activity.get()
        
        let vote = try await activity.castPollVote(request: .init(vote: .init(optionId: "option-2")))
        let statePoll = try #require(await activity.state.poll)
        #expect(vote?.id == "vote-2")
        #expect(vote?.optionId == "option-2")
        #expect(statePoll.ownVotes.map(\.id) == ["vote-2"])
    }
    
    @Test func castPollVoteUpdatesStateWhenNotEnforcingUniqueVotes() async throws {
        let client = defaultClientWithActivityAndCommentsResponses(
            uniqueVotes: false,
            [
                PollVoteResponse.dummy(
                    vote: .dummy(id: "vote-2", optionId: "option-2", pollId: "poll-123")
                )
            ]
        )
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        try await activity.get()
        
        let vote = try await activity.castPollVote(request: .init(vote: .init(optionId: "option-2")))
        let statePoll = try #require(await activity.state.poll)
        #expect(vote?.id == "vote-2")
        #expect(vote?.optionId == "option-2")
        #expect(statePoll.ownVotes.map(\.id).sorted() == ["vote-1", "vote-2"])
    }
    
    @Test func deletePollVoteUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses([
            PollVoteResponse.dummy(
                vote: .dummy(id: "vote-1", optionId: "option-1", pollId: "poll-123")
            )
        ])
        let activity = client.activity(
            for: "activity-123",
            in: .init(group: "user", id: "jane")
        )
        try await activity.get()
        
        // Verify vote exists initially
        let initialPoll = try #require(await activity.state.poll)
        #expect(initialPoll.ownVotes.count == 1)
        #expect(initialPoll.ownVotes.contains { $0.id == "vote-1" })
        
        let vote = try await activity.deletePollVote(voteId: "vote-1")
        
        // Verify vote is removed from state
        let finalPoll = try #require(await activity.state.poll)
        #expect(vote?.id == "vote-1")
        #expect(finalPoll.ownVotes.isEmpty)
    }
    
    // MARK: - Web-Socket Events
    
    @Test func activityUpdatedEventUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses()
        let feedId = FeedId(group: "user", id: "jane")
        let activity = client.activity(
            for: "activity-123",
            in: feedId
        )
        try await activity.get()
        
        // Matching event
        await client.eventsMiddleware.sendEvent(
            ActivityUpdatedEvent.dummy(
                activity: .dummy(id: "activity-123", text: "NEW TEXT"),
                fid: feedId.rawValue
            )
        )
        await #expect(activity.state.activity?.text == "NEW TEXT")
        
        // Unrelated event
        await client.eventsMiddleware.sendEvent(
            ActivityUpdatedEvent.dummy(
                activity: .dummy(id: "some-other-activity", text: "SHOULD NOT CHANGE TO TEXT"),
                fid: feedId.rawValue
            )
        )
        await #expect(activity.state.activity?.text == "NEW TEXT")
    }
    
    @Test func pollDeletedFeedEventUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses()
        let feedId = FeedId(group: "user", id: "jane")
        let activity = client.activity(
            for: "activity-123",
            in: feedId
        )
        try await activity.get()
        
        let initialPoll = try #require(await activity.state.poll)
        #expect(initialPoll.id == "poll-123")
        
        // Unrelated event - should not affect poll
        await client.eventsMiddleware.sendEvent(
            PollDeletedFeedEvent.dummy(
                fid: feedId.rawValue,
                poll: .dummy(id: "some-other-poll")
            )
        )
        await #expect(activity.state.poll != nil)
        
        // Matching event - should remove poll
        await client.eventsMiddleware.sendEvent(
            PollDeletedFeedEvent.dummy(
                fid: feedId.rawValue,
                poll: .dummy(id: "poll-123")
            )
        )
        await #expect(activity.state.poll == nil)
    }
    
    @Test func pollUpdatedFeedEventUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses()
        let feedId = FeedId(group: "user", id: "jane")
        let activity = client.activity(
            for: "activity-123",
            in: feedId
        )
        try await activity.get()
        
        let initialPoll = try #require(await activity.state.poll)
        #expect(initialPoll.id == "poll-123")
        #expect(initialPoll.name == "Test Poll")
        
        // Unrelated event - should not affect poll
        await client.eventsMiddleware.sendEvent(
            PollUpdatedFeedEvent.dummy(
                fid: feedId.rawValue,
                poll: .dummy(id: "some-other-poll", name: "Other Poll")
            )
        )
        await #expect(activity.state.poll?.name == "Test Poll")
        
        // Matching event - should update poll
        await client.eventsMiddleware.sendEvent(
            PollUpdatedFeedEvent.dummy(
                fid: feedId.rawValue,
                poll: .dummy(id: "poll-123", name: "Updated Poll")
            )
        )
        await #expect(activity.state.poll?.name == "Updated Poll")
    }
    
    @Test func pollClosedFeedEventUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses()
        let feedId = FeedId(group: "user", id: "jane")
        let activity = client.activity(
            for: "activity-123",
            in: feedId
        )
        try await activity.get()
        
        let initialPoll = try #require(await activity.state.poll)
        #expect(initialPoll.id == "poll-123")
        #expect(initialPoll.isClosed == false)
        
        // Unrelated event - should not affect poll
        await client.eventsMiddleware.sendEvent(
            PollClosedFeedEvent.dummy(
                fid: feedId.rawValue,
                poll: .dummy(id: "some-other-poll", isClosed: true)
            )
        )
        await #expect(activity.state.poll?.isClosed == false)
        
        // Matching event - should close poll
        await client.eventsMiddleware.sendEvent(
            PollClosedFeedEvent.dummy(
                fid: feedId.rawValue,
                poll: .dummy(id: "poll-123", isClosed: true)
            )
        )
        await #expect(activity.state.poll?.isClosed == true)
    }
    
    @Test func pollVoteCastedFeedEventUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses()
        let feedId = FeedId(group: "user", id: "jane")
        let activity = client.activity(
            for: "activity-123",
            in: feedId
        )
        try await activity.get()
        
        let initialPoll = try #require(await activity.state.poll)
        #expect(initialPoll.id == "poll-123")
        #expect(initialPoll.ownVotes.map(\.id) == ["vote-1"])
        #expect(initialPoll.voteCount == 1)
        #expect(initialPoll.voteCountsByOption == ["option-1": 1, "option-2": 0])
        
        // Unrelated event - should not affect poll
        await client.eventsMiddleware.sendEvent(
            PollVoteCastedFeedEvent.dummy(
                fid: feedId.rawValue,
                poll: .dummy(
                    id: "some-other-poll",
                    ownVotes: [.dummy(id: "vote-other", optionId: "option-1", pollId: "some-other-poll")],
                    voteCount: 1,
                    voteCountsByOption: ["option-1": 1]
                ),
                pollVote: .dummy(id: "vote-other", optionId: "option-1", pollId: "some-other-poll")
            )
        )
        await #expect(activity.state.poll?.ownVotes.map(\.id) == ["vote-1"])
        await #expect(activity.state.poll?.voteCount == 1)
        await #expect(activity.state.poll?.voteCountsByOption == ["option-1": 1, "option-2": 0])
        
        // Matching event - should add vote
        await client.eventsMiddleware.sendEvent(
            PollVoteCastedFeedEvent.dummy(
                fid: feedId.rawValue,
                poll: .dummy(
                    id: "poll-123",
                    ownVotes: [
                        .dummy(id: "vote-1", optionId: "option-1", pollId: "poll-123"),
                        .dummy(id: "vote-2", optionId: "option-2", pollId: "poll-123")
                    ],
                    voteCount: 2,
                    voteCountsByOption: ["option-1": 1, "option-2": 1]
                ),
                pollVote: .dummy(id: "vote-2", optionId: "option-2", pollId: "poll-123")
            )
        )
        await #expect(activity.state.poll?.ownVotes.map(\.id).sorted() == ["vote-1", "vote-2"])
        await #expect(activity.state.poll?.voteCount == 2)
        await #expect(activity.state.poll?.voteCountsByOption == ["option-1": 1, "option-2": 1])
    }
    
    @Test func pollVoteChangedFeedEventUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses()
        let feedId = FeedId(group: "user", id: "jane")
        let activity = client.activity(
            for: "activity-123",
            in: feedId
        )
        try await activity.get()
        
        let initialPoll = try #require(await activity.state.poll)
        #expect(initialPoll.id == "poll-123")
        #expect(initialPoll.ownVotes.map(\.id) == ["vote-1"])
        #expect(initialPoll.voteCount == 1)
        #expect(initialPoll.voteCountsByOption == ["option-1": 1, "option-2": 0])
        
        // Unrelated event - should not affect poll
        await client.eventsMiddleware.sendEvent(
            PollVoteChangedFeedEvent.dummy(
                fid: feedId.rawValue,
                poll: .dummy(
                    id: "some-other-poll",
                    ownVotes: [.dummy(id: "vote-other", optionId: "option-2", pollId: "some-other-poll")],
                    voteCount: 1,
                    voteCountsByOption: ["option-2": 1]
                ),
                pollVote: .dummy(id: "vote-other", optionId: "option-2", pollId: "some-other-poll")
            )
        )
        await #expect(activity.state.poll?.ownVotes.map(\.id) == ["vote-1"])
        await #expect(activity.state.poll?.voteCount == 1)
        await #expect(activity.state.poll?.voteCountsByOption == ["option-1": 1, "option-2": 0])
        
        // Matching event - should change vote
        await client.eventsMiddleware.sendEvent(
            PollVoteChangedFeedEvent.dummy(
                fid: feedId.rawValue,
                poll: .dummy(
                    id: "poll-123",
                    ownVotes: [.dummy(id: "vote-1-changed", optionId: "option-2", pollId: "poll-123")],
                    voteCount: 1,
                    voteCountsByOption: ["option-1": 0, "option-2": 1]
                ),
                pollVote: .dummy(id: "vote-1", optionId: "option-2", pollId: "poll-123")
            )
        )
        await #expect(activity.state.poll?.ownVotes.map(\.id) == ["vote-1-changed"])
        await #expect(activity.state.poll?.voteCount == 1)
        await #expect(activity.state.poll?.voteCountsByOption == ["option-1": 0, "option-2": 1])
    }
    
    @Test func pollVoteRemovedFeedEventUpdatesState() async throws {
        let client = defaultClientWithActivityAndCommentsResponses()
        let feedId = FeedId(group: "user", id: "jane")
        let activity = client.activity(
            for: "activity-123",
            in: feedId
        )
        try await activity.get()
        
        let initialPoll = try #require(await activity.state.poll)
        #expect(initialPoll.id == "poll-123")
        #expect(initialPoll.ownVotes.map(\.id) == ["vote-1"])
        #expect(initialPoll.voteCount == 1)
        #expect(initialPoll.voteCountsByOption == ["option-1": 1, "option-2": 0])
        
        // Unrelated event - should not affect poll
        await client.eventsMiddleware.sendEvent(
            PollVoteRemovedFeedEvent.dummy(
                fid: feedId.rawValue,
                poll: .dummy(
                    id: "some-other-poll",
                    ownVotes: [],
                    voteCount: 0,
                    voteCountsByOption: [:]
                ),
                pollVote: .dummy(id: "vote-other", optionId: "option-1", pollId: "some-other-poll")
            )
        )
        await #expect(activity.state.poll?.ownVotes.map(\.id) == ["vote-1"])
        await #expect(activity.state.poll?.voteCount == 1)
        await #expect(activity.state.poll?.voteCountsByOption == ["option-1": 1, "option-2": 0])
        
        // Matching event - should remove vote
        await client.eventsMiddleware.sendEvent(
            PollVoteRemovedFeedEvent.dummy(
                fid: feedId.rawValue,
                poll: .dummy(
                    id: "poll-123",
                    ownVotes: [],
                    voteCount: 0,
                    voteCountsByOption: ["option-1": 0, "option-2": 0]
                ),
                pollVote: .dummy(id: "vote-1", optionId: "option-1", pollId: "poll-123")
            )
        )
        await #expect(activity.state.poll?.ownVotes.map(\.id) == [])
        await #expect(activity.state.poll?.voteCount == 0)
        await #expect(activity.state.poll?.voteCountsByOption == ["option-1": 0, "option-2": 0])
    }
    
    // MARK: -
    
    private func defaultClientWithActivityAndCommentsResponses(
        uniqueVotes: Bool = true,
        _ additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    GetActivityResponse.dummy(
                        activity: .dummy(
                            id: "activity-123",
                            poll: .dummy(
                                enforceUniqueVote: uniqueVotes,
                                id: "poll-123",
                                name: "Test Poll",
                                options: [
                                    .dummy(id: "option-1", text: "Option 1"),
                                    .dummy(id: "option-2", text: "Option 2")
                                ],
                                ownVotes: [
                                    .dummy(
                                        id: "vote-1",
                                        optionId: "option-1",
                                        pollId: "poll-123"
                                    )
                                ],
                                voteCount: 1,
                                voteCountsByOption: ["option-1": 1, "option-2": 0]
                            ),
                            text: "Test activity content"
                        )
                    ),
                    GetCommentsResponse.dummy(comments: [
                        .dummy(id: "comment-1", text: "First comment"),
                        .dummy(id: "comment-2", text: "Second comment")
                    ])
                ] + additionalPayloads
            )
        )
    }
}
