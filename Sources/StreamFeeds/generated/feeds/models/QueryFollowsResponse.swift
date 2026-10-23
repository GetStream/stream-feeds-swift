//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryFollowsResponse: Sendable, Codable, JSONEncodable {
    public let duration: String
    /// List of follow relationships matching the query
    public let follows: [FollowResponse]
    /// Accepted following counts keyed by followed feed group. Present only when include_group_counts is set with a source_feed equality.
    public let groupCounts: [String: Int]?
    /// Cursor for next page
    public let next: String?
    /// Cursor for previous page
    public let prev: String?

    public init(duration: String, follows: [FollowResponse], groupCounts: [String: Int]? = nil, next: String? = nil, prev: String? = nil) {
        self.duration = duration
        self.follows = follows
        self.groupCounts = groupCounts
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.follows = try container.decode([FollowResponse].self, forKey: .follows)
        self.groupCounts = try container.decodeIfPresent([String: Int].self, forKey: .groupCounts)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(duration, forKey: .duration)
        try container.encode(follows, forKey: .follows)
        try container.encodeIfPresent(groupCounts, forKey: .groupCounts)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
    }
}

extension QueryFollowsResponse: Hashable {
    public static func == (lhs: QueryFollowsResponse, rhs: QueryFollowsResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.follows == rhs.follows &&
            lhs.groupCounts == rhs.groupCounts &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(follows)
        hasher.combine(groupCounts)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
