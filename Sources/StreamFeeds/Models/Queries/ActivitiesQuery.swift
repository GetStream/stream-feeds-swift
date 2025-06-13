//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct ActivitiesQuery: Sendable {
    let filter: ActivityFilter?
    let sort: [Sort<ActivitiesSortField>]
    let next: String?
    let previous: String?
    let limit: Int
    
    public init(
        filter: ActivityFilter?,
        sort: [Sort<ActivitiesSortField>],
        next: String?,
        previous: String?,
        limit: Int
    ) {
        self.filter = filter
        self.sort = sort
        self.next = next
        self.previous = previous
        self.limit = limit
    }
}

// MARK: - Filters

public struct ActivityFilterField: FilterFieldRawRepresentable, Sendable {
    public let rawValue: String
    
    init(field: String) {
        self.rawValue = field
    }
    
    init(field: ActivityResponse.CodingKeys) {
        self.rawValue = field.rawValue
    }
}

extension ActivityFilterField {
    public static let createdAt = Self(field: .createdAt)
    public static let id = Self(field: .id)
    public static let filterTags = Self(field: .filterTags)
    public static let popularity = Self(field: .popularity)
    public static let searchData = Self(field: .searchData)
    public static let text = Self(field: .text)
    public static let type = Self(field: .type)
    public static let userId = Self(field: "user_id")
}

public struct ActivityFilter: Filter {
    public init(operator filterOperator: FilterOperator, field: ActivityFilterField, value: any FilterValue) {
        self.operator = filterOperator
        self.field = field
        self.value = value
    }
    
    public let field: ActivityFilterField
    public let value: any FilterValue
    public let `operator`: FilterOperator
}

// MARK: - Sorting

public struct ActivitiesSortField: SortField {
    public let rawValue: String
    
    static let createdAt: Self = "created_at"
    static let popularity: Self = "popularity"
}

extension ActivitiesSortField: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        rawValue = value
    }
}

// MARK: -

extension ActivitiesQuery {
    func toRequest() -> QueryActivitiesRequest {
        QueryActivitiesRequest(
            filter: filter.flatMap(\.toRawJSON),
            limit: limit,
            next: next,
            prev: previous,
            sort: sort.map { SortParamRequest(direction: $0.direction.rawValue, field: $0.field.rawValue) }
        )
    }
}
