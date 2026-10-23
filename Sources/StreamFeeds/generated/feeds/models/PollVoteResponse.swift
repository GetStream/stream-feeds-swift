//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollVoteResponse: Sendable, Decodable {
    /// Duration of the request in milliseconds
    public let duration: String
    public let vote: PollVoteResponseData?

    public init(duration: String, vote: PollVoteResponseData? = nil) {
        self.duration = duration
        self.vote = vote
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.vote = try container.decodeIfPresent(PollVoteResponseData.self, forKey: .vote)
    }
}

extension PollVoteResponse: Hashable {
    public static func == (lhs: PollVoteResponse, rhs: PollVoteResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.vote == rhs.vote
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(vote)
    }
}
