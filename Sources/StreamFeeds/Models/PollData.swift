//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct PollData: Identifiable, Equatable, Sendable {
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
    public private(set) var isClosed: Bool
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
    mutating func merge(with incomingData: PollData) {
        let ownVotes = ownVotes
        self = incomingData
        self.ownVotes = ownVotes
    }
    
    mutating func merge(with incomingData: PollData, add vote: PollVoteData, currentUserId: String) {
        merge(with: incomingData)
        guard vote.userId == currentUserId else { return }
        if enforceUniqueVote {
            ownVotes = [vote]
        } else {
            ownVotes.insert(byId: vote)
        }
    }
    
    mutating func merge(with incomingData: PollData, remove vote: PollVoteData, currentUserId: String) {
        merge(with: incomingData)
        guard vote.userId == currentUserId else { return }
        ownVotes.remove(byId: vote.id)
    }
    
    mutating func merge(with incomingData: PollData, change vote: PollVoteData, currentUserId: String) {
        merge(with: incomingData)
        guard vote.userId == currentUserId else { return }
        ownVotes.replace(byId: vote)
    }
    
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
