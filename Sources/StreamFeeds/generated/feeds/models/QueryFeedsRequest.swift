//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryFeedsRequest: Sendable, Encodable, JSONEncodable {
    /// Filters to apply to the query
    public let filter: [String: RawJSON]?
    public let limit: Int?
    public let next: String?
    public let prev: String?
    /// Sorting parameters for the query
    public let sort: [SortParamRequest]?
    /// Whether to subscribe to realtime updates
    public let watch: Bool?

    public init(filter: [String: RawJSON]? = nil, limit: Int? = nil, next: String? = nil, prev: String? = nil, sort: [SortParamRequest]? = nil, watch: Bool? = nil) {
        self.filter = filter
        self.limit = limit
        self.next = next
        self.prev = prev
        self.sort = sort
        self.watch = watch
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(filter, forKey: .filter)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
        try container.encodeIfPresent(sort, forKey: .sort)
        try container.encodeIfPresent(watch, forKey: .watch)
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
