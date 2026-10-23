//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class QueryUsersPayload: Sendable, Codable, JSONEncodable {
    /// Filter conditions to apply to the query
    public let filterConditions: [String: RawJSON]
    public let includeDeactivatedUsers: Bool?
    public let limit: Int?
    public let offset: Int?
    public let presence: Bool?
    /// Array of sort parameters
    public let sort: [SortParamRequest]?

    public init(filterConditions: [String: RawJSON], includeDeactivatedUsers: Bool? = nil, limit: Int? = nil, offset: Int? = nil, presence: Bool? = nil, sort: [SortParamRequest]? = nil) {
        self.filterConditions = filterConditions
        self.includeDeactivatedUsers = includeDeactivatedUsers
        self.limit = limit
        self.offset = offset
        self.presence = presence
        self.sort = sort
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.filterConditions = try container.decode([String: RawJSON].self, forKey: .filterConditions)
        self.includeDeactivatedUsers = try container.decodeIfPresent(Bool.self, forKey: .includeDeactivatedUsers)
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        self.offset = try container.decodeIfPresent(Int.self, forKey: .offset)
        self.presence = try container.decodeIfPresent(Bool.self, forKey: .presence)
        self.sort = try container.decodeIfPresent([SortParamRequest].self, forKey: .sort)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(filterConditions, forKey: .filterConditions)
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
