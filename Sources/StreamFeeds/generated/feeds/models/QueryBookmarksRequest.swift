//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryBookmarksRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Filters to apply to the query
    public var filter: [String: RawJSON]?
    public var limit: Int?
    public var next: String?
    public var prev: String?
    /// Sorting parameters for the query
    public var sort: [SortParamRequest]?

    public init(filter: [String: RawJSON]? = nil, limit: Int? = nil, next: String? = nil, prev: String? = nil, sort: [SortParamRequest]? = nil) {
        self.filter = filter
        self.limit = limit
        self.next = next
        self.prev = prev
        self.sort = sort
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case filter
        case limit
        case next
        case prev
        case sort
    }
}

extension QueryBookmarksRequest: Hashable {
    public static func == (lhs: QueryBookmarksRequest, rhs: QueryBookmarksRequest) -> Bool {
        lhs.filter == rhs.filter &&
            lhs.limit == rhs.limit &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.sort == rhs.sort
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(filter)
        hasher.combine(limit)
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(sort)
    }
}
