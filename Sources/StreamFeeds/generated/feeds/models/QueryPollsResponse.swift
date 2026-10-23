//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryPollsResponse: Sendable, Codable, JSONEncodable {
    /// Duration of the request in milliseconds
    public let duration: String
    public let next: String?
    /// Polls data returned by the query
    public let polls: [PollResponseData]
    public let prev: String?

    public init(duration: String, next: String? = nil, polls: [PollResponseData], prev: String? = nil) {
        self.duration = duration
        self.next = next
        self.polls = polls
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.polls = try container.decode([PollResponseData].self, forKey: .polls)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encode(polls, forKey: .polls)
        try container.encodeIfPresent(prev, forKey: .prev)
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
