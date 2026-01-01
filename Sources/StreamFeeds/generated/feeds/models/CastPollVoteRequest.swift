//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class CastPollVoteRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var vote: VoteData?

    public init(vote: VoteData? = nil) {
        self.vote = vote
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case vote
    }

    public static func == (lhs: CastPollVoteRequest, rhs: CastPollVoteRequest) -> Bool {
        lhs.vote == rhs.vote
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(vote)
    }
}
