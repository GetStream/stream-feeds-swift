import Foundation
import StreamCore

public final class QueryUsersPayload: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var filterConditions: [String: RawJSON]
    public var includeDeactivatedUsers: Bool?
    public var limit: Int?
    public var offset: Int?
    public var presence: Bool?
    public var sort: [SortParamRequest]?

    public init(filterConditions: [String: RawJSON], includeDeactivatedUsers: Bool? = nil, limit: Int? = nil, offset: Int? = nil, presence: Bool? = nil, sort: [SortParamRequest]? = nil) {
        self.filterConditions = filterConditions
        self.includeDeactivatedUsers = includeDeactivatedUsers
        self.limit = limit
        self.offset = offset
        self.presence = presence
        self.sort = sort
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case filterConditions = "filter_conditions"
        case includeDeactivatedUsers = "include_deactivated_users"
        case limit
        case offset
        case presence
        case sort
    }

    public static func == (lhs: QueryUsersPayload, rhs: QueryUsersPayload) -> Bool {
        lhs.filterConditions == rhs.filterConditions &&
            lhs.includeDeactivatedUsers == rhs.includeDeactivatedUsers &&
            lhs.limit == rhs.limit &&
            lhs.offset == rhs.offset &&
            lhs.presence == rhs.presence &&
            lhs.sort == rhs.sort
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(filterConditions)
        hasher.combine(includeDeactivatedUsers)
        hasher.combine(limit)
        hasher.combine(offset)
        hasher.combine(presence)
        hasher.combine(sort)
    }
}
