import Foundation
import StreamCore

public final class QueryCommentsRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var filter: [String: RawJSON]
    public var limit: Int?
    public var next: String?
    public var prev: String?
    public var sort: String?

    public init(filter: [String: RawJSON], limit: Int? = nil, next: String? = nil, prev: String? = nil, sort: String? = nil) {
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
