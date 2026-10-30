//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Contains all information needed to create a new poll
public final class CreatePollRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Indicates whether users can suggest user defined answers
    public var allowAnswers: Bool?
    public var allowUserSuggestedOptions: Bool?
    /// Custom data for this object
    public var custom: [String: RawJSON]?
    /// A description of the poll
    public var description: String?
    /// Indicates whether users can cast multiple votes
    public var enforceUniqueVote: Bool?
    public var id: String?
    /// Indicates whether the poll is open for voting
    public var isClosed: Bool?
    /// Indicates the maximum amount of votes a user can cast
    public var maxVotesAllowed: Int?
    /// The name of the poll
    public var name: String
    public var options: [PollOptionInput]?
    /// Represents the visibility of votes in a poll.
    public var votingVisibility: VotingVisibility?

    public init(allowAnswers: Bool? = nil, allowUserSuggestedOptions: Bool? = nil, custom: [String: RawJSON]? = nil, description: String? = nil, enforceUniqueVote: Bool? = nil, id: String? = nil, isClosed: Bool? = nil, maxVotesAllowed: Int? = nil, name: String, options: [PollOptionInput]? = nil, votingVisibility: VotingVisibility? = nil) {
        self.allowAnswers = allowAnswers
        self.allowUserSuggestedOptions = allowUserSuggestedOptions
        self.custom = custom
        self.description = description
        self.enforceUniqueVote = enforceUniqueVote
        self.id = id
        self.isClosed = isClosed
        self.maxVotesAllowed = maxVotesAllowed
        self.name = name
        self.options = options
        self.votingVisibility = votingVisibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case allowAnswers = "allow_answers"
        case allowUserSuggestedOptions = "allow_user_suggested_options"
        case custom
        case description
        case enforceUniqueVote = "enforce_unique_vote"
        case id
        case isClosed = "is_closed"
        case maxVotesAllowed = "max_votes_allowed"
        case name
        case options
        case votingVisibility = "voting_visibility"
    }
}

extension CreatePollRequest: Hashable {
    public static func == (lhs: CreatePollRequest, rhs: CreatePollRequest) -> Bool {
        lhs.allowAnswers == rhs.allowAnswers &&
            lhs.allowUserSuggestedOptions == rhs.allowUserSuggestedOptions &&
            lhs.custom == rhs.custom &&
            lhs.description == rhs.description &&
            lhs.enforceUniqueVote == rhs.enforceUniqueVote &&
            lhs.id == rhs.id &&
            lhs.isClosed == rhs.isClosed &&
            lhs.maxVotesAllowed == rhs.maxVotesAllowed &&
            lhs.name == rhs.name &&
            lhs.options == rhs.options &&
            lhs.votingVisibility == rhs.votingVisibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(allowAnswers)
        hasher.combine(allowUserSuggestedOptions)
        hasher.combine(custom)
        hasher.combine(description)
        hasher.combine(enforceUniqueVote)
        hasher.combine(id)
        hasher.combine(isClosed)
        hasher.combine(maxVotesAllowed)
        hasher.combine(name)
        hasher.combine(options)
        hasher.combine(votingVisibility)
    }
}
