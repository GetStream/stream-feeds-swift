//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryFollowsResponse: Sendable, Decodable {
    public let duration: String
    /// List of follow relationships matching the query
    public let follows: [FollowResponse]
    /// Cursor for next page
    public let next: String?
    /// Cursor for previous page
    public let prev: String?

    public init(duration: String, follows: [FollowResponse], next: String? = nil, prev: String? = nil) {
        self.duration = duration
        self.follows = follows
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.follows = try container.decode([FollowResponse].self, forKey: .follows)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }
}

extension QueryFollowsResponse: Hashable {
    public static func == (lhs: QueryFollowsResponse, rhs: QueryFollowsResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.follows == rhs.follows &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(follows)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
