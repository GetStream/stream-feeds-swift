//
// Copyright © 2025 Stream.io Inc. All rights reserved.
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
    }
    
    func sendAnswer() async throws {
        let votes = try await activity.castPollVote(
            request: .init(
                vote: .init(answerText: "Let's go somewhere else")
            )
        )
    }
    
    func removingVote() async throws {
        try await activity.removePollVote(voteId: "vote_789")
    }
    
    func closingPoll() async throws {
        try await activity.closePoll()
    }
    
    func retrievingPoll() async throws {
        let poll = try await activity.getPoll(userId: "john")
        // userId is optional and can be provided for serverside calls
        // in case you want to include the votes for the user
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
}
