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
    let limit: Int?
    
    public init(
        filter: ActivityFilter?,
        sort: [Sort<ActivitiesSortField>],
        next: String?,
        previous: String?,
        limit: Int?
    ) {
        self.filter = filter
        self.sort = sort
        self.next = next
        self.previous = previous
        self.limit = limit
    }
}

// MARK: - Filters

public struct ActivityFilterField: FilterFieldRepresentable, Sendable {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
    init(codingKey: ActivityResponse.CodingKeys) {
        self.value = codingKey.rawValue
    }
}

extension ActivityFilterField {
    public static let createdAt = Self(codingKey: .createdAt)
    public static let id = Self(codingKey: .id)
    public static let filterTags = Self(codingKey: .filterTags)
    public static let popularity = Self(codingKey: .popularity)
    public static let searchData = Self(codingKey: .searchData)
    public static let text = Self(codingKey: .text)
    public static let type = Self(codingKey: .type)
    public static let userId = Self(value: "user_id")
}

public struct ActivityFilter: Filter {
    public init(filterOperator: FilterOperator, field: ActivityFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    public let field: ActivityFilterField
    public let value: any FilterValue
    public let filterOperator: FilterOperator
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
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort.map { SortParamRequest(direction: $0.direction.rawValue, field: $0.field.rawValue) }
        )
    }
}
