//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryUsersPayload: @unchecked Sendable, Codable, JSONEncodable {
    /// Filter conditions to apply to the query
    public var filterConditions: [String: RawJSON]
    public var idGt: String?
    public var idGte: String?
    public var idLt: String?
    public var idLte: String?
    public var includeDeactivatedUsers: Bool?
    public var limit: Int?
    public var offset: Int?
    public var presence: Bool?
    /// Array of sort parameters
    public var sort: [SortParamRequest]?

    public init(
        filterConditions: [String: RawJSON],
        idGt: String? = nil,
        idGte: String? = nil,
        idLt: String? = nil,
        idLte: String? = nil,
        includeDeactivatedUsers: Bool? = nil,
        limit: Int? = nil,
        offset: Int? = nil,
        presence: Bool? = nil,
        sort: [SortParamRequest]? = nil
    ) {
        self.filterConditions = filterConditions
        self.idGt = idGt
        self.idGte = idGte
        self.idLt = idLt
        self.idLte = idLte
        self.includeDeactivatedUsers = includeDeactivatedUsers
        self.limit = limit
        self.offset = offset
        self.presence = presence
        self.sort = sort
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case filterConditions = "filter_conditions"
        case idGt = "id_gt"
        case idGte = "id_gte"
        case idLt = "id_lt"
        case idLte = "id_lte"
        case includeDeactivatedUsers = "include_deactivated_users"
        case limit
        case offset
        case presence
        case sort
    }
}

extension QueryUsersPayload: Hashable {
    public static func == (lhs: QueryUsersPayload, rhs: QueryUsersPayload) -> Bool {
        lhs.filterConditions == rhs.filterConditions &&
            lhs.idGt == rhs.idGt &&
            lhs.idGte == rhs.idGte &&
            lhs.idLt == rhs.idLt &&
            lhs.idLte == rhs.idLte &&
            lhs.includeDeactivatedUsers == rhs.includeDeactivatedUsers &&
            lhs.limit == rhs.limit &&
            lhs.offset == rhs.offset &&
            lhs.presence == rhs.presence &&
            lhs.sort == rhs.sort
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(filterConditions)
        hasher.combine(idGt)
        hasher.combine(idGte)
        hasher.combine(idLt)
        hasher.combine(idLte)
        hasher.combine(includeDeactivatedUsers)
        hasher.combine(limit)
        hasher.combine(offset)
        hasher.combine(presence)
        hasher.combine(sort)
    }
}
