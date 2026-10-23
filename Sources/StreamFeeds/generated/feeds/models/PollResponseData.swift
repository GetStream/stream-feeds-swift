//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollResponseData: @unchecked Sendable, Codable, JSONEncodable {
    public enum PollResponseDataVotingVisibility: String, Sendable, Codable, CaseIterable {
        case `public`
        case anonymous
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var allowAnswers: Bool
    public var allowUserSuggestedOptions: Bool
    public var answersCount: Int
    public var createdAt: Date
    /// User response object
    public var createdBy: UserResponse?
    public var createdById: String
    public var custom: [String: RawJSON]
    public var description: String
    public var descriptionI18n: [String: String]?
    public var enforceUniqueVote: Bool
    public var id: String
    public var isClosed: Bool?
    public var latestAnswers: [PollVoteResponseData]
    public var latestVotesByOption: [String: [PollVoteResponseData]]
    public var maxVotesAllowed: Int?
    public var name: String
    public var nameI18n: [String: String]?
    public var options: [PollOptionResponseData]
    public var ownVotes: [PollVoteResponseData]
    public var updatedAt: Date
    public var voteCount: Int
    public var voteCountsByOption: [String: Int]
    /// Voting visibility of the poll
    public var votingVisibility: PollResponseDataVotingVisibility

    public init(
        allowAnswers: Bool,
        allowUserSuggestedOptions: Bool,
        answersCount: Int,
        createdAt: Date,
        createdBy: UserResponse? = nil,
        createdById: String,
        custom: [String: RawJSON],
        description: String,
        descriptionI18n: [String: String]? = nil,
        enforceUniqueVote: Bool,
        id: String,
        isClosed: Bool? = nil,
        latestAnswers: [PollVoteResponseData],
        latestVotesByOption: [String: [PollVoteResponseData]],
        maxVotesAllowed: Int? = nil,
        name: String,
        nameI18n: [String: String]? = nil,
        options: [PollOptionResponseData],
        ownVotes: [PollVoteResponseData],
        updatedAt: Date,
        voteCount: Int,
        voteCountsByOption: [String: Int],
        votingVisibility: PollResponseDataVotingVisibility
    ) {
        self.allowAnswers = allowAnswers
        self.allowUserSuggestedOptions = allowUserSuggestedOptions
        self.answersCount = answersCount
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.createdById = createdById
        self.custom = custom
        self.description = description
        self.descriptionI18n = descriptionI18n
        self.enforceUniqueVote = enforceUniqueVote
        self.id = id
        self.isClosed = isClosed
        self.latestAnswers = latestAnswers
        self.latestVotesByOption = latestVotesByOption
        self.maxVotesAllowed = maxVotesAllowed
        self.name = name
        self.nameI18n = nameI18n
        self.options = options
        self.ownVotes = ownVotes
        self.updatedAt = updatedAt
        self.voteCount = voteCount
        self.voteCountsByOption = voteCountsByOption
        self.votingVisibility = votingVisibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case allowAnswers = "allow_answers"
        case allowUserSuggestedOptions = "allow_user_suggested_options"
        case answersCount = "answers_count"
        case createdAt = "created_at"
        case createdBy = "created_by"
        case createdById = "created_by_id"
        case custom
        case description
        case descriptionI18n = "description_i18n"
        case enforceUniqueVote = "enforce_unique_vote"
        case id
        case isClosed = "is_closed"
        case latestAnswers = "latest_answers"
        case latestVotesByOption = "latest_votes_by_option"
        case maxVotesAllowed = "max_votes_allowed"
        case name
        case nameI18n = "name_i18n"
        case options
        case ownVotes = "own_votes"
        case updatedAt = "updated_at"
        case voteCount = "vote_count"
        case voteCountsByOption = "vote_counts_by_option"
        case votingVisibility = "voting_visibility"
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
            lhs.descriptionI18n == rhs.descriptionI18n &&
            lhs.enforceUniqueVote == rhs.enforceUniqueVote &&
            lhs.id == rhs.id &&
            lhs.isClosed == rhs.isClosed &&
            lhs.latestAnswers == rhs.latestAnswers &&
            lhs.latestVotesByOption == rhs.latestVotesByOption &&
            lhs.maxVotesAllowed == rhs.maxVotesAllowed &&
            lhs.name == rhs.name &&
            lhs.nameI18n == rhs.nameI18n &&
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
        hasher.combine(descriptionI18n)
        hasher.combine(enforceUniqueVote)
        hasher.combine(id)
        hasher.combine(isClosed)
        hasher.combine(latestAnswers)
        hasher.combine(latestVotesByOption)
        hasher.combine(maxVotesAllowed)
        hasher.combine(name)
        hasher.combine(nameI18n)
        hasher.combine(options)
        hasher.combine(ownVotes)
        hasher.combine(updatedAt)
        hasher.combine(voteCount)
        hasher.combine(voteCountsByOption)
        hasher.combine(votingVisibility)
    }
}
