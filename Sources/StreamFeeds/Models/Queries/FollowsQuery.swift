//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public struct FollowsQuery: Sendable {
    public var filter: FollowsFilter?
    public var limit: Int?
    public var next: String?
    public var previous: String?
    public var sort: [Sort<FollowsSortField>]?

    public init(
        filter: FollowsFilter? = nil,
        sort: [Sort<FollowsSortField>]? = nil,
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.filter = filter
        self.limit = limit
        self.next = next
        self.previous = previous
        self.sort = sort
    }
}

// MARK: - Filters

public struct FollowsFilterField: FilterFieldRepresentable, Sendable {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
    init(codingKey: FollowResponse.CodingKeys) {
        self.value = codingKey.rawValue
    }
}

extension FollowsFilterField {
    public static let sourceFeed = Self(codingKey: .sourceFeed)
    public static let targetFeed = Self(codingKey: .targetFeed)
    public static let userId = Self(value: "user_id")
}

public struct FollowsFilter: Filter {
    public init(filterOperator: FilterOperator, field: FollowsFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    public let field: FollowsFilterField
    public let value: any FilterValue
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

public struct FollowsSortField: SortField {
    public typealias Model = FollowData
    public let comparator: AnySortComparator<Model>
    public let remote: String
    
    public init<Value>(_ remote: String, localValue: @escaping @Sendable (Model) -> Value) where Value : Comparable {
        self.comparator = SortComparator(localValue).toAny()
        self.remote = remote
    }
    
    public static let createdAt = Self("created_at", localValue: \.createdAt)
}

extension Sort where Field == FollowsSortField {
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension FollowsQuery {
    func toRequest() -> QueryFollowsRequest {
        QueryFollowsRequest(
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
}
