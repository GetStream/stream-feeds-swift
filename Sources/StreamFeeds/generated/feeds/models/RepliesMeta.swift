import Foundation
import StreamCore

public final class RepliesMeta: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var depthTruncated: Bool
    public var hasMore: Bool
    public var nextCursor: String?
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
