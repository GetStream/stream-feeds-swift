//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Cursor & depth information for a comment's direct replies. Mirrors Reddit's 'load more replies' semantics.
public final class RepliesMeta: @unchecked Sendable, Codable, JSONEncodable {
    /// True if the subtree was cut because the requested depth was reached.
    public var depthTruncated: Bool
    /// True if more siblings exist in the database.
    public var hasMore: Bool
    /// Opaque cursor to request the next page of siblings.
    public var nextCursor: String?
    /// Number of unread siblings that match current filters.
    public var remaining: Int

    public init(depthTruncated: Bool, hasMore: Bool, nextCursor: String? = nil, remaining: Int) {
        self.depthTruncated = depthTruncated
        self.hasMore = hasMore
        self.nextCursor = nextCursor
        self.remaining = remaining
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case depthTruncated = "depth_truncated"
        case hasMore = "has_more"
        case nextCursor = "next_cursor"
        case remaining
    }
}

extension RepliesMeta: Hashable {
    public static func == (lhs: RepliesMeta, rhs: RepliesMeta) -> Bool {
        lhs.depthTruncated == rhs.depthTruncated &&
            lhs.hasMore == rhs.hasMore &&
            lhs.nextCursor == rhs.nextCursor &&
            lhs.remaining == rhs.remaining
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(depthTruncated)
        hasher.combine(hasMore)
        hasher.combine(nextCursor)
        hasher.combine(remaining)
    }
}
