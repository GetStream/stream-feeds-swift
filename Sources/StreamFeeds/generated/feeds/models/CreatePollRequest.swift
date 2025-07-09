import Foundation
import StreamCore

public final class CreatePollRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum CreatePollRequestVotingVisibility: String, Sendable, Codable, CaseIterable {
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

    public var allowAnswers: Bool?
    public var allowUserSuggestedOptions: Bool?
    public var custom: [String: RawJSON]?
    public var description: String?
    public var enforceUniqueVote: Bool?
    public var id: String?
    public var isClosed: Bool?
    public var maxVotesAllowed: Int?
    public var name: String
    public var options: [PollOptionInput]?
    public var votingVisibility: CreatePollRequestVotingVisibility?

    public init(allowAnswers: Bool? = nil, allowUserSuggestedOptions: Bool? = nil, custom: [String: RawJSON]? = nil, description: String? = nil, enforceUniqueVote: Bool? = nil, id: String? = nil, isClosed: Bool? = nil, maxVotesAllowed: Int? = nil, name: String, options: [PollOptionInput]? = nil, votingVisibility: CreatePollRequestVotingVisibility? = nil) {
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
        case custom = "Custom"
        case description
        case enforceUniqueVote = "enforce_unique_vote"
        case id
        case isClosed = "is_closed"
        case maxVotesAllowed = "max_votes_allowed"
        case name
        case options
        case votingVisibility = "voting_visibility"
    }

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
