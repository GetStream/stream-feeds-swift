//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CastPollVoteRequest: Sendable, Codable, JSONEncodable {
    public let vote: VoteData?

    public init(vote: VoteData? = nil) {
        self.vote = vote
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.vote = try container.decodeIfPresent(VoteData.self, forKey: .vote)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(vote, forKey: .vote)
    }
}

extension CastPollVoteRequest: Hashable {
    public static func == (lhs: CastPollVoteRequest, rhs: CastPollVoteRequest) -> Bool {
        lhs.vote == rhs.vote
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(vote)
    }
}
