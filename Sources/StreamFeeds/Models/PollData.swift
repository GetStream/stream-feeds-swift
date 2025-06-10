//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct PollData: Identifiable, Sendable {
    public let allowAnswers: Bool
    public let allowUserSuggestedOptions: Bool
    public let answersCount: Int
    public let createdAt: Date
    public let createdBy: UserData?
    public let createdById: String
    public let custom: [String: RawJSON]
    public let description: String
    public let enforceUniqueVote: Bool
    public let id: String
    public let isClosed: Bool
    public let latestAnswers: [PollVoteData]
    public private(set) var latestVotesByOption: [String: [PollVoteData]]
    public let maxVotesAllowed: Int?
    public let name: String
    public private(set) var options: [PollOptionData]
    public private(set) var ownVotes: [PollVoteData]
    public let updatedAt: Date
    public private(set) var voteCount: Int
    public private(set) var voteCountsByOption: [String: Int]
    public let votingVisibility: String
}

// MARK: - Mutating the Data

extension PollData {
    
    // MARK: - Options
    
    mutating func addOption(_ option: PollOptionData) {
        options.insert(byId: option)
    }
    
    mutating func removeOption(withId optionId: String) {
        guard let index = options.firstIndex(where: { $0.id == optionId }) else { return }
        options.remove(at: index)
    }
    
    mutating func updateOption(_ option: PollOptionData) {
        options.replace(byId: option)
    }
    
    // MARK: - Votes
    
    mutating func castVote(_ vote: PollVoteData) {
        // TODO: Review
        if enforceUniqueVote {
            for ownVote in self.ownVotes {
                removeVote(ownVote)
            }
            ownVotes = [vote]
        } else {
            ownVotes.insert(byId: vote)
        }
        
        let optionVoteCounts = voteCountsByOption[vote.optionId] ?? 0
        voteCountsByOption[vote.optionId] = optionVoteCounts + 1
        
        var optionVotes = latestVotesByOption[vote.optionId] ?? []
        optionVotes.insert(byId: vote)
        latestVotesByOption[vote.optionId] = optionVotes
        
        voteCount = voteCountsByOption.reduce(0, { $0 + $1.value })
    }
    
    mutating func removeVote(_ vote: PollVoteData) {
        ownVotes.remove(byId: vote)
        let optionVoteCounts = voteCountsByOption[vote.optionId] ?? 0
        voteCountsByOption[vote.optionId] = max(0, optionVoteCounts - 1)
        var optionVotes = latestVotesByOption[vote.optionId] ?? []
        optionVotes.remove(byId: vote)
        latestVotesByOption[vote.optionId] = optionVotes
    }
}

// MARK: - Model Conversions

extension PollResponseData {
    func toModel() -> PollData {
        PollData(
            allowAnswers: allowAnswers,
            allowUserSuggestedOptions: allowUserSuggestedOptions,
            answersCount: answersCount,
            createdAt: createdAt,
            createdBy: createdBy?.toModel(),
            createdById: createdById,
            custom: custom,
            description: description,
            enforceUniqueVote: enforceUniqueVote,
            id: id,
            isClosed: isClosed ?? false,
            latestAnswers: latestAnswers.map { $0.toModel() },
            latestVotesByOption: latestVotesByOption.mapValues { votes in votes.map { $0.toModel() } },
            maxVotesAllowed: maxVotesAllowed,
            name: name,
            options: options.map { $0.toModel() },
            ownVotes: ownVotes.map { $0.toModel() },
            updatedAt: updatedAt,
            voteCount: voteCount,
            voteCountsByOption: voteCountsByOption,
            votingVisibility: votingVisibility
        )
    }
}
