//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryFeedMembersResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: String
    public var members: [FeedMemberResponse]
    public var next: String?
    public var prev: String?

    public init(duration: String, members: [FeedMemberResponse], next: String? = nil, prev: String? = nil) {
        self.duration = duration
        self.members = members
        self.next = next
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case members
        case next
        case prev
    }

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
