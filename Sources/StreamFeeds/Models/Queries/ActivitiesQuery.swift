//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct ActivitiesQuery: Sendable {
    let filter: ActivitiesFilter?
    let sort: [Sort<ActivitiesSortField>]?
    let next: String?
    let previous: String?
    let limit: Int?
    
    public init(
        filter: ActivitiesFilter?,
        sort: [Sort<ActivitiesSortField>] = [],
        next: String? = nil,
        previous: String? = nil,
        limit: Int? = nil
    ) {
        self.filter = filter
        self.sort = sort
        self.next = next
        self.previous = previous
        self.limit = limit
    }
}

// MARK: - Filters

public struct ActivitiesFilterField: FilterFieldRepresentable, Sendable {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
    init(codingKey: ActivityResponse.CodingKeys) {
        self.value = codingKey.rawValue
    }
}

extension ActivitiesFilterField {
    public static let createdAt = Self(codingKey: .createdAt)
    public static let id = Self(codingKey: .id)
    public static let filterTags = Self(codingKey: .filterTags)
    public static let popularity = Self(codingKey: .popularity)
    public static let searchData = Self(codingKey: .searchData)
    public static let text = Self(codingKey: .text)
    public static let type = Self(codingKey: .type)
    public static let userId = Self(value: "user_id")
}

public struct ActivitiesFilter: Filter {
    public init(filterOperator: FilterOperator, field: ActivitiesFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    public let field: ActivitiesFilterField
    public let value: any FilterValue
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

public struct ActivitiesSortField: SortField {
    public typealias Model = ActivityData
    public let comparator: AnySortComparator<Model>
    public let remote: String
    
    public init<Value>(_ remote: String, localValue: @escaping @Sendable (Model) -> Value) where Value : Comparable {
        self.comparator = SortComparator(localValue).toAny()
        self.remote = remote
    }
    
    public static let createdAt = Self("created_at", localValue: \.createdAt)
    public static let popularity = Self("popularity", localValue: \.popularity)
}

extension Sort where Field == ActivitiesSortField {
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension ActivitiesQuery {
    func toRequest() -> QueryActivitiesRequest {
        QueryActivitiesRequest(
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
}
