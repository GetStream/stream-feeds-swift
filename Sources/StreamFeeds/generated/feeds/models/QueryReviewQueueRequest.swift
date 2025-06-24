import Foundation
import StreamCore

public final class QueryReviewQueueRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var filter: [String: RawJSON]?
    public var limit: Int?
    public var lockCount: Int?
    public var lockDuration: Int?
    public var lockItems: Bool?
    public var next: String?
    public var prev: String?
    public var sort: [SortParamRequest]?
    public var statsOnly: Bool?

    public init(filter: [String: RawJSON]? = nil, limit: Int? = nil, lockCount: Int? = nil, lockDuration: Int? = nil, lockItems: Bool? = nil, next: String? = nil, prev: String? = nil, sort: [SortParamRequest]? = nil, statsOnly: Bool? = nil) {
        self.filter = filter
        self.limit = limit
        self.lockCount = lockCount
        self.lockDuration = lockDuration
        self.lockItems = lockItems
        self.next = next
        self.prev = prev
        self.sort = sort
        self.statsOnly = statsOnly
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case filter
        case limit
        case lockCount = "lock_count"
        case lockDuration = "lock_duration"
        case lockItems = "lock_items"
        case next
        case prev
        case sort
        case statsOnly = "stats_only"
    }

    public static func == (lhs: QueryReviewQueueRequest, rhs: QueryReviewQueueRequest) -> Bool {
        lhs.filter == rhs.filter &&
            lhs.limit == rhs.limit &&
            lhs.lockCount == rhs.lockCount &&
            lhs.lockDuration == rhs.lockDuration &&
            lhs.lockItems == rhs.lockItems &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.sort == rhs.sort &&
            lhs.statsOnly == rhs.statsOnly
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(filter)
        hasher.combine(limit)
        hasher.combine(lockCount)
        hasher.combine(lockDuration)
        hasher.combine(lockItems)
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(sort)
        hasher.combine(statsOnly)
    }
}
