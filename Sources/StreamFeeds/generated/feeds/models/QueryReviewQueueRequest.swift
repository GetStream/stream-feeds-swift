//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryReviewQueueRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Filter conditions for review queue items. Accepts built-in fields (e.g. status, channel_cid, severity, recommended_action) and customer-supplied moderation_payload.custom keys: any key that is not a built-in field is matched against the item's custom moderation data (e.g. {"location_id": "loc-42"}). Use filter_config.filterable_custom_keys to discover which custom keys the app exposes as chips. content_text searches the moderated text: "$q" is a keyword search (terms ANDed, no adjacency) over the indexed tsvector, while "$eq" (or "$in" for several wordings) matches the text exactly. The exact form is unindexed, so scope it with date_range rather than running it across the whole queue.
    public var filter: [String: RawJSON]?
    public var limit: Int?
    /// Number of items to lock (1-25)
    public var lockCount: Int?
    /// Duration for which items should be locked
    public var lockDuration: Int?
    /// Whether to lock items for review (true), unlock items (false), or just fetch (nil)
    public var lockItems: Bool?
    public var next: String?
    public var prev: String?
    /// Sorting parameters for the results
    public var sort: [SortParamRequest]?
    /// Whether to return only statistics
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
}

extension QueryReviewQueueRequest: Hashable {
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
