//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollVoteResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var vote: PollVoteResponseData?

    public init(duration: String, vote: PollVoteResponseData? = nil) {
        self.duration = duration
        self.vote = vote
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case vote
    }

    public static func == (lhs: PollVoteResponse, rhs: PollVoteResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.vote == rhs.vote
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(vote)
    }
}
