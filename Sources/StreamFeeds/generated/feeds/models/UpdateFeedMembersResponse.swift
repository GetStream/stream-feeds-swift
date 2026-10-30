//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Basic response information
public final class UpdateFeedMembersResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var added: [FeedMemberResponse]
    /// Duration of the request in milliseconds
    public var duration: String
    public var removedIds: [String]
    public var updated: [FeedMemberResponse]

    public init(added: [FeedMemberResponse], duration: String, removedIds: [String], updated: [FeedMemberResponse]) {
        self.added = added
        self.duration = duration
        self.removedIds = removedIds
        self.updated = updated
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case added
        case duration
        case removedIds = "removed_ids"
        case updated
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
