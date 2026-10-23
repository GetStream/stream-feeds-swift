//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdatePollRequestVotingVisibility: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let `public` = UpdatePollRequestVotingVisibility(rawValue: "public")
    public static let anonymous = UpdatePollRequestVotingVisibility(rawValue: "anonymous")
}

public final class UpdatePollRequest: Sendable, Codable, JSONEncodable {
    /// Allow answers
    public let allowAnswers: Bool?
    /// Allow user suggested options
    public let allowUserSuggestedOptions: Bool?
    /// Custom data for this object
    public let custom: [String: RawJSON]?
    /// Poll description
    public let description: String?
    /// Enforce unique vote
    public let enforceUniqueVote: Bool?
    /// Poll ID
    public let id: String
    /// Is closed
    public let isClosed: Bool?
    /// Max votes allowed
    public let maxVotesAllowed: Int?
    /// Poll name
    public let name: String
    /// Poll options
    public let options: [PollOptionRequest]?
    /// Voting visibility
    public let votingVisibility: UpdatePollRequestVotingVisibility?

    public init(allowAnswers: Bool? = nil, allowUserSuggestedOptions: Bool? = nil, custom: [String: RawJSON]? = nil, description: String? = nil, enforceUniqueVote: Bool? = nil, id: String, isClosed: Bool? = nil, maxVotesAllowed: Int? = nil, name: String, options: [PollOptionRequest]? = nil, votingVisibility: UpdatePollRequestVotingVisibility? = nil) {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.allowAnswers = try container.decodeIfPresent(Bool.self, forKey: .allowAnswers)
        self.allowUserSuggestedOptions = try container.decodeIfPresent(Bool.self, forKey: .allowUserSuggestedOptions)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.enforceUniqueVote = try container.decodeIfPresent(Bool.self, forKey: .enforceUniqueVote)
        self.id = try container.decode(String.self, forKey: .id)
        self.isClosed = try container.decodeIfPresent(Bool.self, forKey: .isClosed)
        self.maxVotesAllowed = try container.decodeIfPresent(Int.self, forKey: .maxVotesAllowed)
        self.name = try container.decode(String.self, forKey: .name)
        self.options = try container.decodeIfPresent([PollOptionRequest].self, forKey: .options)
        self.votingVisibility = try container.decodeIfPresent(UpdatePollRequestVotingVisibility.self, forKey: .votingVisibility)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(allowAnswers, forKey: .allowAnswers)
        try container.encodeIfPresent(allowUserSuggestedOptions, forKey: .allowUserSuggestedOptions)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(enforceUniqueVote, forKey: .enforceUniqueVote)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(isClosed, forKey: .isClosed)
        try container.encodeIfPresent(maxVotesAllowed, forKey: .maxVotesAllowed)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(options, forKey: .options)
        try container.encodeIfPresent(votingVisibility, forKey: .votingVisibility)
    }
}

extension UpdatePollRequest: Hashable {
    public static func == (lhs: UpdatePollRequest, rhs: UpdatePollRequest) -> Bool {
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
