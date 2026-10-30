//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryFeedMembersResponse: Sendable, Decodable {
    public let duration: String
    /// List of feed members
    public let members: [FeedMemberResponse]
    /// Cursor for next page
    public let next: String?
    /// Cursor for previous page
    public let prev: String?

    public init(duration: String, members: [FeedMemberResponse], next: String? = nil, prev: String? = nil) {
        self.duration = duration
        self.members = members
        self.next = next
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.members = try container.decode([FeedMemberResponse].self, forKey: .members)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }
}

extension QueryFeedMembersResponse: Hashable {
    public static func == (lhs: QueryFeedMembersResponse, rhs: QueryFeedMembersResponse) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.members == rhs.members &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(members)
        hasher.combine(next)
        hasher.combine(prev)
    }
}
