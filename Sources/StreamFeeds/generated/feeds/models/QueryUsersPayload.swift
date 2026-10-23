//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryUsersPayload: Sendable, Codable, JSONEncodable {
    /// Filter conditions to apply to the query
    public let filterConditions: [String: RawJSON]
    public let idGt: String?
    public let idGte: String?
    public let idLt: String?
    public let idLte: String?
    public let includeDeactivatedUsers: Bool?
    public let limit: Int?
    public let offset: Int?
    public let presence: Bool?
    /// Array of sort parameters
    public let sort: [SortParamRequest]?

    public init(filterConditions: [String: RawJSON], idGt: String? = nil, idGte: String? = nil, idLt: String? = nil, idLte: String? = nil, includeDeactivatedUsers: Bool? = nil, limit: Int? = nil, offset: Int? = nil, presence: Bool? = nil, sort: [SortParamRequest]? = nil) {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.filterConditions = try container.decode([String: RawJSON].self, forKey: .filterConditions)
        self.idGt = try container.decodeIfPresent(String.self, forKey: .idGt)
        self.idGte = try container.decodeIfPresent(String.self, forKey: .idGte)
        self.idLt = try container.decodeIfPresent(String.self, forKey: .idLt)
        self.idLte = try container.decodeIfPresent(String.self, forKey: .idLte)
        self.includeDeactivatedUsers = try container.decodeIfPresent(Bool.self, forKey: .includeDeactivatedUsers)
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        self.offset = try container.decodeIfPresent(Int.self, forKey: .offset)
        self.presence = try container.decodeIfPresent(Bool.self, forKey: .presence)
        self.sort = try container.decodeIfPresent([SortParamRequest].self, forKey: .sort)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(filterConditions, forKey: .filterConditions)
        try container.encodeIfPresent(idGt, forKey: .idGt)
        try container.encodeIfPresent(idGte, forKey: .idGte)
        try container.encodeIfPresent(idLt, forKey: .idLt)
        try container.encodeIfPresent(idLte, forKey: .idLte)
        try container.encodeIfPresent(includeDeactivatedUsers, forKey: .includeDeactivatedUsers)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(offset, forKey: .offset)
        try container.encodeIfPresent(presence, forKey: .presence)
        try container.encodeIfPresent(sort, forKey: .sort)
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
