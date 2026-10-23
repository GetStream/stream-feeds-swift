//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollVotesResponse: Sendable, Codable, JSONEncodable {
    /// Duration of the request in milliseconds
    public let duration: String
    public let next: String?
    public let prev: String?
    /// Poll votes
    public let votes: [PollVoteResponseData]

    public init(duration: String, next: String? = nil, prev: String? = nil, votes: [PollVoteResponseData]) {
        self.duration = duration
        self.next = next
        self.prev = prev
        self.votes = votes
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
        self.votes = try container.decode([PollVoteResponseData].self, forKey: .votes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
        try container.encode(votes, forKey: .votes)
    }
}

extension PollVotesResponse: Hashable {
    public static func == (lhs: PollVotesResponse, rhs: PollVotesResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.votes == rhs.votes
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(votes)
    }
}
