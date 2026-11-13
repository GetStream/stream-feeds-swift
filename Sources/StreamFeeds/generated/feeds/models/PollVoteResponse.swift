//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollVoteResponse: Sendable, Decodable {
    public let vote: PollVoteResponseData?

    public init(vote: PollVoteResponseData? = nil) {
        self.vote = vote
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.vote = try container.decodeIfPresent(PollVoteResponseData.self, forKey: .vote)
    }
}

extension PollVoteResponse: Hashable {
    public static func == (lhs: PollVoteResponse, rhs: PollVoteResponse) -> Bool {
        lhs.vote == rhs.vote
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(vote)
    }
}
