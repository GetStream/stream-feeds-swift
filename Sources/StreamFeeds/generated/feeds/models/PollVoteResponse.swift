//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollVoteResponse: Sendable, Codable, JSONEncodable {
    /// Duration of the request in milliseconds
    public let duration: String
    public let poll: PollResponseData?
    public let vote: PollVoteResponseData?

    public init(duration: String, poll: PollResponseData? = nil, vote: PollVoteResponseData? = nil) {
        self.duration = duration
        self.poll = poll
        self.vote = vote
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.poll = try container.decodeIfPresent(PollResponseData.self, forKey: .poll)
        self.vote = try container.decodeIfPresent(PollVoteResponseData.self, forKey: .vote)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(poll, forKey: .poll)
        try container.encodeIfPresent(vote, forKey: .vote)
    }
}

extension PollVoteResponse: Hashable {
    public static func == (lhs: PollVoteResponse, rhs: PollVoteResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.poll == rhs.poll &&
            lhs.vote == rhs.vote
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(poll)
        hasher.combine(vote)
    }
}
