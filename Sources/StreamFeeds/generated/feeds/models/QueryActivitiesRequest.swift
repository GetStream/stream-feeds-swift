import Foundation
import StreamCore

public final class QueryActivitiesRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum string: String, Sendable, Codable, CaseIterable {
        case first
        case last
        case popular
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue)
            {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var commentLimit: Int?
    public var commentSort: String?
    public var filter: [String: RawJSON]?
    public var limit: Int?
    public var next: String?
    public var prev: String?
    public var sort: [SortParamRequest]?

    public init(commentLimit: Int? = nil, commentSort: String? = nil, filter: [String: RawJSON]? = nil, limit: Int? = nil, next: String? = nil, prev: String? = nil, sort: [SortParamRequest]? = nil) {
        self.commentLimit = commentLimit
        self.commentSort = commentSort
        self.filter = filter
        self.limit = limit
        self.next = next
        self.prev = prev
        self.sort = sort
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case commentLimit = "comment_limit"
        case commentSort = "comment_sort"
        case filter
        case limit
        case next
        case prev
        case sort
    }

    public static func == (lhs: QueryActivitiesRequest, rhs: QueryActivitiesRequest) -> Bool {
        lhs.commentLimit == rhs.commentLimit &&
            lhs.commentSort == rhs.commentSort &&
            lhs.filter == rhs.filter &&
            lhs.limit == rhs.limit &&
            lhs.next == rhs.next &&
            lhs.prev == rhs.prev &&
            lhs.sort == rhs.sort
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(commentLimit)
        hasher.combine(commentSort)
        hasher.combine(filter)
        hasher.combine(limit)
        hasher.combine(next)
        hasher.combine(prev)
        hasher.combine(sort)
    }
}
