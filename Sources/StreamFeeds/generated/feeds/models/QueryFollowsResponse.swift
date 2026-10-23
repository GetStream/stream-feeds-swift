//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryFollowsResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var duration: String
    /// List of follow relationships matching the query
    public var follows: [FollowResponse]
    /// Accepted following counts keyed by followed feed group. Present only when include_group_counts is set with a source_feed equality.
    public var groupCounts: [String: Int]?
    /// Cursor for next page
    public var next: String?
    /// Cursor for previous page
    public var prev: String?

    public init(
        duration: String,
        follows: [FollowResponse],
        groupCounts: [String: Int]? = nil,
        next: String? = nil,
        prev: String? = nil
    ) {
        self.duration = duration
        self.follows = follows
        self.groupCounts = groupCounts
        self.next = next
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case follows
        case groupCounts = "group_counts"
        case next
        case prev
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
