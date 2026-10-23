//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryReviewQueueRequest: Sendable, Codable, JSONEncodable {
    public let excludeDefaultActionConfig: Bool?
    /// Filter conditions for review queue items. Accepts built-in fields (e.g. status, channel_cid, severity, recommended_action) and customer-supplied moderation_payload.custom keys: any key that is not a built-in field is matched against the item's custom moderation data (e.g. {"location_id": "loc-42"}). Use filter_config.filterable_custom_keys to discover which custom keys the app exposes as chips. content_text searches the moderated text: "$q" is a keyword search (terms ANDed, no adjacency) over the indexed tsvector, while "$eq" (or "$in" for several wordings) matches the text exactly. The exact form is unindexed, so scope it with date_range rather than running it across the whole queue.
    public let filter: [String: RawJSON]?
    public let limit: Int?
    /// Number of items to lock (1-25)
    public let lockCount: Int?
    /// Duration for which items should be locked
    public let lockDuration: Int?
    /// Whether to lock items for review (true), unlock items (false), or just fetch (nil)
    public let lockItems: Bool?
    public let next: String?
    public let prev: String?
    /// Sorting parameters for the results
    public let sort: [SortParamRequest]?
    /// Whether to return only statistics
    public let statsOnly: Bool?

    public init(excludeDefaultActionConfig: Bool? = nil, filter: [String: RawJSON]? = nil, limit: Int? = nil, lockCount: Int? = nil, lockDuration: Int? = nil, lockItems: Bool? = nil, next: String? = nil, prev: String? = nil, sort: [SortParamRequest]? = nil, statsOnly: Bool? = nil) {
        self.excludeDefaultActionConfig = excludeDefaultActionConfig
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.excludeDefaultActionConfig = try container.decodeIfPresent(Bool.self, forKey: .excludeDefaultActionConfig)
        self.filter = try container.decodeIfPresent([String: RawJSON].self, forKey: .filter)
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        self.lockCount = try container.decodeIfPresent(Int.self, forKey: .lockCount)
        self.lockDuration = try container.decodeIfPresent(Int.self, forKey: .lockDuration)
        self.lockItems = try container.decodeIfPresent(Bool.self, forKey: .lockItems)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
        self.sort = try container.decodeIfPresent([SortParamRequest].self, forKey: .sort)
        self.statsOnly = try container.decodeIfPresent(Bool.self, forKey: .statsOnly)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(excludeDefaultActionConfig, forKey: .excludeDefaultActionConfig)
        try container.encodeIfPresent(filter, forKey: .filter)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(lockCount, forKey: .lockCount)
        try container.encodeIfPresent(lockDuration, forKey: .lockDuration)
        try container.encodeIfPresent(lockItems, forKey: .lockItems)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
        try container.encodeIfPresent(sort, forKey: .sort)
        try container.encodeIfPresent(statsOnly, forKey: .statsOnly)
    }
}

extension QueryReviewQueueRequest: Hashable {
    public static func == (lhs: QueryReviewQueueRequest, rhs: QueryReviewQueueRequest) -> Bool {
        lhs.excludeDefaultActionConfig == rhs.excludeDefaultActionConfig &&
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
        hasher.combine(excludeDefaultActionConfig)
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
