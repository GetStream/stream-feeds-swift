//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollVotesResponse: Sendable, Decodable {
    public let next: String?
    public let prev: String?
    /// Poll votes
    public let votes: [PollVoteResponseData]

    public init(next: String? = nil, prev: String? = nil, votes: [PollVoteResponseData]) {
        self.next = next
        self.prev = prev
        self.votes = votes
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
        self.votes = try container.decode([PollVoteResponseData].self, forKey: .votes)
    }
}

extension PollVotesResponse: Hashable {
    public static func == (lhs: PollVotesResponse, rhs: PollVotesResponse) -> Bool {
        lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.votes == rhs.votes
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(votes)
    }
}
