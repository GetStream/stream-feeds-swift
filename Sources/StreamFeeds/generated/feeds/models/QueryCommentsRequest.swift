//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryCommentsRequest: @unchecked Sendable, Codable, JSONEncodable {
    public enum QueryCommentsRequestSort: String, Sendable, Codable, CaseIterable {
        case best
        case controversial
        case first
        case last
        case top
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    /// Filter to apply to the query
    public var filter: [String: RawJSON]
    /// Returns the comment with the specified ID along with surrounding comments for context
    public var idAround: String?
    /// Maximum number of comments to return
    public var limit: Int?
    public var next: String?
    public var prev: String?
    /// Array of sort parameters
    public var sort: QueryCommentsRequestSort?

    public init(
        filter: [String: RawJSON],
        idAround: String? = nil,
        limit: Int? = nil,
        next: String? = nil,
        prev: String? = nil,
        sort: QueryCommentsRequestSort? = nil
    ) {
        self.filter = filter
        self.idAround = idAround
        self.limit = limit
        self.next = next
        self.prev = prev
        self.sort = sort
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case filter
        case idAround = "id_around"
        case limit
        case next
        case prev
        case sort
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
