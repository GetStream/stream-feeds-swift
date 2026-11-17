//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryFeedsResponse: Sendable, Decodable {
    /// List of feeds matching the query
    public let feeds: [FeedResponse]
    /// Cursor for next page
    public let next: String?
    /// Cursor for previous page
    public let prev: String?

    public init(feeds: [FeedResponse], next: String? = nil, prev: String? = nil) {
        self.feeds = feeds
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.feeds = try container.decode([FeedResponse].self, forKey: .feeds)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }
}

extension QueryFeedsResponse: Hashable {
    public static func == (lhs: QueryFeedsResponse, rhs: QueryFeedsResponse) -> Bool {
        lhs.feeds == rhs.feeds &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(feeds)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
