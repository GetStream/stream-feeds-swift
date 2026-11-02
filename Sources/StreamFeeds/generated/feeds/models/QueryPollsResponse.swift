//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryPollsResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// Duration of the request in milliseconds
    public var duration: String
    public var next: String?
    /// Polls data returned by the query
    public var polls: [PollResponseData]
    public var prev: String?

    public init(duration: String, next: String? = nil, polls: [PollResponseData], prev: String? = nil) {
        self.duration = duration
        self.next = next
        self.polls = polls
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case next
        case polls
        case prev
    }
}

extension QueryPollsResponse: Hashable {
    public static func == (lhs: QueryPollsResponse, rhs: QueryPollsResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.next == rhs.next &&
            lhs.polls == rhs.polls &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(next)
        hasher.combine(polls)
        hasher.combine(prev)
    }
}
