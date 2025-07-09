//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollVotesResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var next: String?
    public var prev: String?
    public var votes: [PollVoteResponseData]

    public init(duration: String, next: String? = nil, prev: String? = nil, votes: [PollVoteResponseData]) {
        self.duration = duration
        self.next = next
        self.prev = prev
        self.votes = votes
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case next
        case prev
        case votes
    }

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
