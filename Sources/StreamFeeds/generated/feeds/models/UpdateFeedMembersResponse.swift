//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class UpdateFeedMembersResponse: Sendable, Decodable {
    public let added: [FeedMemberResponse]
    /// Duration of the request in milliseconds
    public let duration: String
    public let removedIds: [String]
    public let updated: [FeedMemberResponse]

    public init(added: [FeedMemberResponse], duration: String, removedIds: [String], updated: [FeedMemberResponse]) {
        self.added = added
        self.duration = duration
        self.removedIds = removedIds
        self.updated = updated
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.added = try container.decode([FeedMemberResponse].self, forKey: .added)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.removedIds = try container.decode([String].self, forKey: .removedIds)
        self.updated = try container.decode([FeedMemberResponse].self, forKey: .updated)
    }
}

extension UpdateFeedMembersResponse: Hashable {
    public static func == (lhs: UpdateFeedMembersResponse, rhs: UpdateFeedMembersResponse) -> Bool {
        lhs.added == rhs.added &&
            lhs.duration == rhs.duration &&
            lhs.removedIds == rhs.removedIds &&
            lhs.updated == rhs.updated
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(added)
        hasher.combine(duration)
        hasher.combine(removedIds)
        hasher.combine(updated)
    }
}
