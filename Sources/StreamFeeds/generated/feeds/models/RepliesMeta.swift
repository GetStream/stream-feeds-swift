//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Cursor & depth information for a comment's direct replies. Mirrors Reddit's 'load more replies' semantics.
public final class RepliesMeta: Sendable, Codable, JSONEncodable {
    /// True if the subtree was cut because the requested depth was reached.
    public let depthTruncated: Bool
    /// True if more siblings exist in the database.
    public let hasMore: Bool
    /// Opaque cursor to request the next page of siblings.
    public let nextCursor: String?
    /// Number of unread siblings that match current filters.
    public let remaining: Int

    public init(depthTruncated: Bool, hasMore: Bool, nextCursor: String? = nil, remaining: Int) {
        self.depthTruncated = depthTruncated
        self.hasMore = hasMore
        self.nextCursor = nextCursor
        self.remaining = remaining
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.depthTruncated = try container.decode(Bool.self, forKey: .depthTruncated)
        self.hasMore = try container.decode(Bool.self, forKey: .hasMore)
        self.nextCursor = try container.decodeIfPresent(String.self, forKey: .nextCursor)
        self.remaining = try container.decode(Int.self, forKey: .remaining)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(depthTruncated, forKey: .depthTruncated)
        try container.encode(hasMore, forKey: .hasMore)
        try container.encodeIfPresent(nextCursor, forKey: .nextCursor)
        try container.encode(remaining, forKey: .remaining)
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
