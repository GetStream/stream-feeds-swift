//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct PollInfo: Identifiable, Sendable {
    public let allowAnswers: Bool
    public let allowUserSuggestedOptions: Bool
    public let answersCount: Int
    public let createdAt: Date
    public let createdBy: UserInfo?
    public let createdById: String
    public let custom: [String: RawJSON]
    public let description: String
    public let enforceUniqueVote: Bool
    public let id: String
    public let isClosed: Bool
    public let latestAnswers: [PollVoteInfo]
    public private(set) var latestVotesByOption: [String: [PollVoteInfo]]
    public let maxVotesAllowed: Int?
    public let name: String
    public private(set) var options: [PollOptionInfo]
    public private(set) var ownVotes: [PollVoteInfo]
    public let updatedAt: Date
    public private(set) var voteCount: Int
    public private(set) var voteCountsByOption: [String: Int]
    public let votingVisibility: String
    
    init(from response: PollResponseData) {
        self.allowAnswers = response.allowAnswers
        self.allowUserSuggestedOptions = response.allowUserSuggestedOptions
        self.answersCount = response.answersCount
        self.createdAt = response.createdAt
        self.createdBy = response.createdBy.flatMap(UserInfo.init(from:))
        self.createdById = response.createdById
        self.custom = response.custom
        self.description = response.description
        self.enforceUniqueVote = response.enforceUniqueVote
        self.id = response.id
        self.isClosed = response.isClosed ?? false
        self.latestAnswers = response.latestAnswers.map(PollVoteInfo.init(from:))
        self.latestVotesByOption = response.latestVotesByOption.mapValues { $0.map(PollVoteInfo.init(from:)) }
        self.maxVotesAllowed = response.maxVotesAllowed
        self.name = response.name
        self.options = response.options.map(PollOptionInfo.init(from:))
        self.ownVotes = response.ownVotes.map(PollVoteInfo.init(from:))
        self.updatedAt = response.updatedAt
        self.voteCount = response.voteCount
        self.voteCountsByOption = response.voteCountsByOption
        self.votingVisibility = response.votingVisibility
    }
}

// MARK: - Mutating the Data

extension PollInfo {
    
    // MARK: - Options
    
    mutating func addOption(_ option: PollOptionInfo) {
        options.insert(byId: option)
    }
    
    mutating func removeOption(withId optionId: String) {
        guard let index = options.firstIndex(where: { $0.id == optionId }) else { return }
        options.remove(at: index)
    }
    
    mutating func updateOption(_ option: PollOptionInfo) {
        options.replace(byId: option)
    }
    
    // MARK: - Votes
    
    mutating func castVote(_ vote: PollVoteInfo) {
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
    
    mutating func removeVote(_ vote: PollVoteInfo) {
        ownVotes.remove(byId: vote)
        let optionVoteCounts = voteCountsByOption[vote.optionId] ?? 0
        voteCountsByOption[vote.optionId] = max(0, optionVoteCounts - 1)
        var optionVotes = latestVotesByOption[vote.optionId] ?? []
        optionVotes.remove(byId: vote)
        latestVotesByOption[vote.optionId] = optionVotes
    }
}
