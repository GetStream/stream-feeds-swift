//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Combine
import StreamCore
import StreamFeeds
import UIKit

@MainActor struct Snippets_09_01_Polls {
    var activity: Activity!
    var client: FeedsClient!
    var feed: Feed!
    
    func creatingPollAndSendingItAsPartOfMessage() async throws {
        // Create a poll
        let poll = try await feed.createPoll(
            request: CreatePollRequest(
                name: "Where should we host our next company event?",
                options: [
                    PollOptionInput(text: "Amsterdam, The Netherlands"),
                    PollOptionInput(text: "Boulder, CO")
                ]
            ),
            activityType: "poll"
        )

        // The poll is automatically added as an activity to the feed
        print("Poll created with ID: \(poll.id)")
    }
    
    func pollOptions() async throws {
        let poll = try await feed.createPoll(
            request: CreatePollRequest(
                custom: ["category": "event_planning", "priority": "high"],
                name: "Where should we host our next company event?",
                options: [
                    PollOptionInput(
                        custom: ["country": "Netherlands", "timezone": "CET"],
                        text: "Amsterdam, The Netherlands"
                    ),
                    PollOptionInput(
                        custom: ["country": "USA", "timezone": "MST"],
                        text: "Boulder, CO"
                    )
                ]
            ),
            activityType: "poll"
        )
        
        suppressUnusedWarning(poll)
    }
    
    func sendVoteOnOption() async throws {
        let activity = client.activity(
            for: "activity_123",
            in: FeedId(group: "user", id: "test")
        )

        let votes = try await activity.castPollVote(
            request: .init(
                vote: .init(optionId: "option_789")
            )
        )
        
        suppressUnusedWarning(votes)
    }
    
    func sendAnswer() async throws {
        let votes = try await activity.castPollVote(
            request: .init(
                vote: .init(answerText: "Let's go somewhere else")
            )
        )
        
        suppressUnusedWarning(votes)
    }
    
    func removingVote() async throws {
        try await activity.deletePollVote(voteId: "vote_789")
    }
    
    func closingPoll() async throws {
        try await activity.closePoll()
    }
    
    func retrievingPoll() async throws {
        let poll = try await activity.getPoll(userId: "john")
        // userId is optional and can be provided for serverside calls
        // in case you want to include the votes for the user
        
        suppressUnusedWarning(poll)
    }
    
    func fullUpdate() async throws {
        let updatedPoll = try await activity.updatePoll(
            request: .init(
                id: "poll_456",
                name: "Where should we not go to?",
                options: [
                    PollOptionRequest(
                        custom: ["reason": "too expensive"],
                        id: "option_789",
                        text: "Amsterdam, The Netherlands"
                    ),
                    PollOptionRequest(
                        custom: ["reason": "too far"],
                        id: "option_790",
                        text: "Boulder, CO"
                    )
                ]
            )
        )
        
        suppressUnusedWarning(updatedPoll)
    }
    
    func partialUpdate() async throws {
        let updatedPoll = try await activity.updatePollPartial(
            request: .init(
                set: ["name": "Updated poll name"],
                unset: ["custom_property"]
            )
        )
        
        suppressUnusedWarning(updatedPoll)
    }
    
    func deletingPoll() async throws {
        try await activity.deletePoll()
    }
    
    func addPollOption() async throws {
        let pollOption = try await activity.createPollOption(
            request: .init(
                custom: ["added_by": "user_123"],
                text: "Another option"
            )
        )
        
        suppressUnusedWarning(pollOption)
    }
    
    func updatePollOption() async throws {
        let updatedPollOption = try await activity.updatePollOption(
            request: .init(
                custom: ["my_custom_property": "my_custom_value"],
                id: "option_789",
                text: "Updated option"
            )
        )
        
        suppressUnusedWarning(updatedPollOption)
    }
    
    func deletePollOption() async throws {
        try await activity.deletePollOption(optionId: "option_789")
    }
    
    func queryingVotes() async throws {
        // Retrieve all votes on either option1Id or option2Id
        let pollVoteList = client.pollVoteList(
            for: .init(
                pollId: "poll_456",
                filter: .in(.optionId, ["option_789", "option_790"])
            )
        )
        let votesPage1 = try await pollVoteList.get()
        let votesPage2 = try await pollVoteList.queryMorePollVotes()
        let votesPage1And2 = pollVoteList.state.votes
        
        suppressUnusedWarning(votesPage1, votesPage2, votesPage1And2)
    }
    
    func queringVotes() async throws {
        // Retrieve all polls that are closed for voting sorted by created_at
        let pollList = client.pollList(
            for: .init(
                filter: .equal(.isClosed, true)
            )
        )
        let pollsPage1 = try await pollList.get()
        let pollsPage2 = try await pollList.queryMorePolls()
        let pollsPage1And2 = pollList.state.polls
        
        suppressUnusedWarning(pollsPage1, pollsPage2, pollsPage1And2)
    }
}
