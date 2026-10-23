//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryFeedsRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Filters to apply to the query
    public var filter: [String: RawJSON]?
    public var limit: Int?
    public var next: String?
    public var prev: String?
    /// Sorting parameters for the query
    public var sort: [SortParamRequest]?
    /// Whether to subscribe to realtime updates
    public var watch: Bool?

    public init(filter: [String: RawJSON]? = nil, limit: Int? = nil, next: String? = nil, prev: String? = nil, sort: [SortParamRequest]? = nil, watch: Bool? = nil) {
        self.filter = filter
        self.limit = limit
        self.next = next
        self.prev = prev
        self.sort = sort
        self.watch = watch
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case filter
        case limit
        case next
        case prev
        case sort
        case watch
    }
}

extension QueryFeedsRequest: Hashable {
    public static func == (lhs: QueryFeedsRequest, rhs: QueryFeedsRequest) -> Bool {
        lhs.filter == rhs.filter &&
            lhs.limit == rhs.limit &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.sort == rhs.sort &&
            lhs.watch == rhs.watch
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(filter)
        hasher.combine(limit)
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(sort)
        hasher.combine(watch)
    }
}
