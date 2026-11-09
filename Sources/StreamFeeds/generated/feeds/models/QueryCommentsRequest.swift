//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryCommentsRequestSort: RawRepresentable, Codable, CustomStringConvertible, Hashable, Sendable {
    public let rawValue: String

    public var description: String { rawValue }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let best = QueryCommentsRequestSort(rawValue: "best")
    public static let controversial = QueryCommentsRequestSort(rawValue: "controversial")
    public static let first = QueryCommentsRequestSort(rawValue: "first")
    public static let last = QueryCommentsRequestSort(rawValue: "last")
    public static let top = QueryCommentsRequestSort(rawValue: "top")
}

public final class QueryCommentsRequest: Sendable, Encodable, JSONEncodable {
    /// Filter to apply to the query
    public let filter: [String: RawJSON]
    /// Returns the comment with the specified ID along with surrounding comments for context
    public let idAround: String?
    /// Maximum number of comments to return
    public let limit: Int?
    public let next: String?
    public let prev: String?
    /// Array of sort parameters
    public let sort: QueryCommentsRequestSort?

    public init(filter: [String: RawJSON], idAround: String? = nil, limit: Int? = nil, next: String? = nil, prev: String? = nil, sort: QueryCommentsRequestSort? = nil) {
        self.filter = filter
        self.idAround = idAround
        self.limit = limit
        self.next = next
        self.prev = prev
        self.sort = sort
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(filter, forKey: .filter)
        try container.encodeIfPresent(idAround, forKey: .idAround)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(next, forKey: .next)
        try container.encodeIfPresent(prev, forKey: .prev)
        try container.encodeIfPresent(sort, forKey: .sort)
    }
}

extension QueryCommentsRequest: Hashable {
    public static func == (lhs: QueryCommentsRequest, rhs: QueryCommentsRequest) -> Bool {
        lhs.filter == rhs.filter &&
            lhs.idAround == rhs.idAround &&
            lhs.limit == rhs.limit &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.sort == rhs.sort
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(filter)
        hasher.combine(idAround)
        hasher.combine(limit)
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(sort)
    }
}
