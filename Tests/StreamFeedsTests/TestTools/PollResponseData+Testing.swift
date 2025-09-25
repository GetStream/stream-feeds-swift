//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension PollResponseData {
    static func dummy(
        allowAnswers: Bool = true,
        allowUserSuggestedOptions: Bool = false,
        answersCount: Int = 0,
        createdAt: Date = Date.fixed(),
        createdBy: UserResponse? = UserResponse.dummy(),
        createdById: String = "user-123",
        custom: [String: RawJSON] = [:],
        description: String = "Test poll description",
        enforceUniqueVote: Bool = true,
        id: String = "poll-123",
        isClosed: Bool = false,
        latestAnswers: [PollVoteResponseData] = [],
        latestVotesByOption: [String: [PollVoteResponseData]] = [:],
        maxVotesAllowed: Int = 1,
        name: String = "Test Poll",
        options: [PollOptionResponseData] = [
            .dummy(id: "option-1", text: "Option 1"),
            .dummy(id: "option-2", text: "Option 2")
        ],
        ownVotes: [PollVoteResponseData] = [],
        updatedAt: Date = Date.fixed(),
        voteCount: Int = 0,
        voteCountsByOption: [String: Int] = [:],
        votingVisibility: String = "public"
    ) -> PollResponseData {
        PollResponseData(
            allowAnswers: allowAnswers,
            allowUserSuggestedOptions: allowUserSuggestedOptions,
            answersCount: answersCount,
            createdAt: createdAt,
            createdBy: createdBy,
            createdById: createdById,
            custom: custom,
            description: description,
            enforceUniqueVote: enforceUniqueVote,
            id: id,
            isClosed: isClosed,
            latestAnswers: latestAnswers,
            latestVotesByOption: latestVotesByOption,
            maxVotesAllowed: maxVotesAllowed,
            name: name,
            options: options,
            ownVotes: ownVotes,
            updatedAt: updatedAt,
            voteCount: voteCount,
            voteCountsByOption: voteCountsByOption,
            votingVisibility: votingVisibility
        )
    }
}
