import Foundation
import StreamCore

public final class QueryFeedsRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var filter: [String: RawJSON]?
    public var pagination: PagerRequest?
    public var sort: [SortParamRequest]?
    public var watch: Bool?

    public init(filter: [String: RawJSON]? = nil, pagination: PagerRequest? = nil, sort: [SortParamRequest]? = nil, watch: Bool? = nil) {
        self.filter = filter
        self.pagination = pagination
        self.sort = sort
        self.watch = watch
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case filter
        case pagination
        case sort
        case watch
    }

    public static func == (lhs: QueryFeedsRequest, rhs: QueryFeedsRequest) -> Bool {
        lhs.filter == rhs.filter &&
            lhs.pagination == rhs.pagination &&
            lhs.sort == rhs.sort &&
            lhs.watch == rhs.watch
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(filter)
        hasher.combine(pagination)
        hasher.combine(sort)
        hasher.combine(watch)
    }
}
