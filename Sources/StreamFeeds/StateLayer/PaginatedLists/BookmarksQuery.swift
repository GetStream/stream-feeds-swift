//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public struct BookmarksQuery: Sendable {
    public var filter: BookmarksFilter?
    public var limit: Int?
    public var next: String?
    public var previous: String?
    public var sort: [Sort<BookmarksSortField>]?

    public init(
        filter: BookmarksFilter? = nil,
        sort: [Sort<BookmarksSortField>]? = nil,
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

public struct BookmarksFilterField: FilterFieldRepresentable, Sendable {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
    init(codingKey: BookmarkResponse.CodingKeys) {
        self.value = codingKey.rawValue
    }
}

extension BookmarksFilterField {
    public static let activityId = Self(value: "activity_id")
    public static let folderId = Self(value: "folder_id")
    public static let userId = Self(value: "user_id")
}

public struct BookmarksFilter: Filter {
    public init(filterOperator: FilterOperator, field: BookmarksFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    public let field: BookmarksFilterField
    public let value: any FilterValue
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

public struct BookmarksSortField: SortField {
    public typealias Model = BookmarkData
    public let comparator: AnySortComparator<Model>
    public let remote: String
    
    public init<Value>(_ remote: String, localValue: @escaping @Sendable (Model) -> Value) where Value : Comparable {
        self.comparator = SortComparator(localValue).toAny()
        self.remote = remote
    }
    
    public static let createdAt = Self("created_at", localValue: \.createdAt)
}

extension Sort where Field == BookmarksSortField {
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension BookmarksQuery {
    func toRequest() -> QueryBookmarksRequest {
        QueryBookmarksRequest(
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
}
