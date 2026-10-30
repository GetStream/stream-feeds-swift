//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CastPollVoteRequest: Sendable, Encodable, JSONEncodable {
    public let vote: VoteData?

    public init(vote: VoteData? = nil) {
        self.vote = vote
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
