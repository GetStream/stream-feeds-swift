//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryCommentsRequestSort: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let best = QueryCommentsRequestSort(rawValue: "best")
    public static let controversial = QueryCommentsRequestSort(rawValue: "controversial")
    public static let first = QueryCommentsRequestSort(rawValue: "first")
    public static let last = QueryCommentsRequestSort(rawValue: "last")
    public static let top = QueryCommentsRequestSort(rawValue: "top")
}

public final class QueryCommentsRequest: Sendable, Codable, JSONEncodable {
    /// Filter to apply to the query
    public let filter: [String: RawJSON]
    /// Maximum number of comments to return
    public let limit: Int?
    public let next: String?
    public let prev: String?
    /// Array of sort parameters
    public let sort: QueryCommentsRequestSort?

    public init(filter: [String: RawJSON], limit: Int? = nil, next: String? = nil, prev: String? = nil, sort: QueryCommentsRequestSort? = nil) {
        self.filter = filter
        self.limit = limit
        self.next = next
        self.prev = prev
        self.sort = sort
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.filter = try container.decode([String: RawJSON].self, forKey: .filter)
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
        self.sort = try container.decodeIfPresent(QueryCommentsRequestSort.self, forKey: .sort)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(filter, forKey: .filter)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
        try container.encodeIfPresent(sort, forKey: .sort)
    }
}

extension QueryCommentsRequest: Hashable {
    public static func == (lhs: QueryCommentsRequest, rhs: QueryCommentsRequest) -> Bool {
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
