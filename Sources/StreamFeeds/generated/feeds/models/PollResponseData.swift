//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollResponseData: Sendable, Decodable {
    public let allowAnswers: Bool
    public let allowUserSuggestedOptions: Bool
    public let answersCount: Int
    public let createdAt: Date
    /// User response object
    public let createdBy: UserResponse?
    public let createdById: String
    public let custom: [String: RawJSON]
    public let description: String
    public let enforceUniqueVote: Bool
    public let id: String
    public let isClosed: Bool?
    public let latestAnswers: [PollVoteResponseData]
    public let latestVotesByOption: [String: [PollVoteResponseData]]
    public let maxVotesAllowed: Int?
    public let name: String
    public let options: [PollOptionResponseData]
    public let ownVotes: [PollVoteResponseData]
    public let updatedAt: Date
    public let voteCount: Int
    public let voteCountsByOption: [String: Int]
    /// Voting visibility of the poll
    public let votingVisibility: VotingVisibility

    public init(allowAnswers: Bool, allowUserSuggestedOptions: Bool, answersCount: Int, createdAt: Date, createdBy: UserResponse? = nil, createdById: String, custom: [String: RawJSON], description: String, enforceUniqueVote: Bool, id: String, isClosed: Bool? = nil, latestAnswers: [PollVoteResponseData], latestVotesByOption: [String: [PollVoteResponseData]], maxVotesAllowed: Int? = nil, name: String, options: [PollOptionResponseData], ownVotes: [PollVoteResponseData], updatedAt: Date, voteCount: Int, voteCountsByOption: [String: Int], votingVisibility: VotingVisibility) {
        self.allowAnswers = allowAnswers
        self.allowUserSuggestedOptions = allowUserSuggestedOptions
        self.answersCount = answersCount
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.createdById = createdById
        self.custom = custom
        self.description = description
        self.enforceUniqueVote = enforceUniqueVote
        self.id = id
        self.isClosed = isClosed
        self.latestAnswers = latestAnswers
        self.latestVotesByOption = latestVotesByOption
        self.maxVotesAllowed = maxVotesAllowed
        self.name = name
        self.options = options
        self.ownVotes = ownVotes
        self.updatedAt = updatedAt
        self.voteCount = voteCount
        self.voteCountsByOption = voteCountsByOption
        self.votingVisibility = votingVisibility
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.allowAnswers = try container.decode(Bool.self, forKey: .allowAnswers)
        self.allowUserSuggestedOptions = try container.decode(Bool.self, forKey: .allowUserSuggestedOptions)
        self.answersCount = try container.decode(Int.self, forKey: .answersCount)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.createdBy = try container.decodeIfPresent(UserResponse.self, forKey: .createdBy)
        self.createdById = try container.decode(String.self, forKey: .createdById)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.description = try container.decode(String.self, forKey: .description)
        self.enforceUniqueVote = try container.decode(Bool.self, forKey: .enforceUniqueVote)
        self.id = try container.decode(String.self, forKey: .id)
        self.isClosed = try container.decodeIfPresent(Bool.self, forKey: .isClosed)
        self.latestAnswers = try container.decode([PollVoteResponseData].self, forKey: .latestAnswers)
        self.latestVotesByOption = try container.decode([String: [PollVoteResponseData]].self, forKey: .latestVotesByOption)
        self.maxVotesAllowed = try container.decodeIfPresent(Int.self, forKey: .maxVotesAllowed)
        self.name = try container.decode(String.self, forKey: .name)
        self.options = try container.decode([PollOptionResponseData].self, forKey: .options)
        self.ownVotes = try container.decode([PollVoteResponseData].self, forKey: .ownVotes)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.voteCount = try container.decode(Int.self, forKey: .voteCount)
        self.voteCountsByOption = try container.decode([String: Int].self, forKey: .voteCountsByOption)
        self.votingVisibility = try container.decode(VotingVisibility.self, forKey: .votingVisibility)
    }
}

extension PollResponseData: Hashable {
    public static func == (lhs: PollResponseData, rhs: PollResponseData) -> Bool {
        lhs.allowAnswers == rhs.allowAnswers &&
            lhs.allowUserSuggestedOptions == rhs.allowUserSuggestedOptions &&
            lhs.answersCount == rhs.answersCount &&
            lhs.createdAt == rhs.createdAt &&
            lhs.createdBy == rhs.createdBy &&
            lhs.createdById == rhs.createdById &&
            lhs.custom == rhs.custom &&
            lhs.description == rhs.description &&
            lhs.enforceUniqueVote == rhs.enforceUniqueVote &&
            lhs.id == rhs.id &&
            lhs.isClosed == rhs.isClosed &&
            lhs.latestAnswers == rhs.latestAnswers &&
            lhs.latestVotesByOption == rhs.latestVotesByOption &&
            lhs.maxVotesAllowed == rhs.maxVotesAllowed &&
            lhs.name == rhs.name &&
            lhs.options == rhs.options &&
            lhs.ownVotes == rhs.ownVotes &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.voteCount == rhs.voteCount &&
            lhs.voteCountsByOption == rhs.voteCountsByOption &&
            lhs.votingVisibility == rhs.votingVisibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(allowAnswers)
        hasher.combine(allowUserSuggestedOptions)
        hasher.combine(answersCount)
        hasher.combine(createdAt)
        hasher.combine(createdBy)
        hasher.combine(createdById)
        hasher.combine(custom)
        hasher.combine(description)
        hasher.combine(enforceUniqueVote)
        hasher.combine(id)
        hasher.combine(isClosed)
        hasher.combine(latestAnswers)
        hasher.combine(latestVotesByOption)
        hasher.combine(maxVotesAllowed)
        hasher.combine(name)
        hasher.combine(options)
        hasher.combine(ownVotes)
        hasher.combine(updatedAt)
        hasher.combine(voteCount)
        hasher.combine(voteCountsByOption)
        hasher.combine(votingVisibility)
    }
}
