//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query for retrieving collections with filtering, sorting, and pagination options.
///
/// Client-side requests return the current user's collections and the collections that have no owner.
public struct CollectionsQuery: Sendable {
    /// Optional filter to apply to the collections query.
    public var filter: CollectionsFilter?

    /// Maximum number of collections to return in a single request, at most 100.
    /// If not specified, the API will use its default limit.
    public var limit: Int?

    /// Pagination cursor for fetching the next page of results.
    public var next: String?

    /// Pagination cursor for fetching the previous page of results.
    public var previous: String?

    /// Array of sorting criteria to apply to the collections.
    /// If not specified, collections are sorted by creation date, newest first.
    public var sort: [Sort<CollectionsSortField>]?

    /// Creates a new collections query with the specified parameters.
    ///
    /// - Parameters:
    ///   - filter: Optional filter to apply to the collections query.
    ///   - sort: Optional array of sorting criteria to apply to the collections.
    ///   - limit: Optional maximum number of collections to return in a single request.
    ///   - next: Optional pagination cursor for fetching the next page of results.
    ///   - previous: Optional pagination cursor for fetching the previous page of results.
    public init(
        filter: CollectionsFilter? = nil,
        sort: [Sort<CollectionsSortField>]? = nil,
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

/// A filter field for collections.
public struct CollectionsFilterField: FilterFieldRepresentable, Sendable {
    public typealias Model = CollectionData
    public let matcher: AnyFilterMatcher<Model>
    public let rawValue: String

    public init<Value>(_ rawValue: String, localValue: @escaping @Sendable (Model) -> Value?) where Value: FilterValue {
        self.rawValue = rawValue
        matcher = AnyFilterMatcher(localValue: localValue)
    }
}

extension CollectionsFilterField {
    /// Filter by the creation timestamp of the collection.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let createdAt = Self("created_at", localValue: \.createdAt)

    /// Filter by the identifier of the collection.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let id = Self("id", localValue: \.id)

    /// Filter by the name of the collection.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let name = Self("name", localValue: \.name)

    /// Filter by the last update timestamp of the collection.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let updatedAt = Self("updated_at", localValue: \.updatedAt)
}

/// A filter that can be applied to collections queries.
///
/// ## Supported Operators by Field Type
///
/// **String fields** (`id`, `name`):
/// - `.equal` - Exact match
/// - `.in` - Match any value in a list
///
/// **Date fields** (`createdAt`, `updatedAt`):
/// - `.equal` - Exact match
/// - `.greaterThan` - After the specified date
/// - `.lessThan` - Before the specified date
/// - `.greaterThanOrEqual` - On or after the specified date
/// - `.lessThanOrEqual` - On or before the specified date
public struct CollectionsFilter: Filter {
    /// Creates a new collections filter with the specified parameters.
    ///
    /// - Parameters:
    ///   - filterOperator: The operator to use for the filter comparison.
    ///   - field: The field to filter on.
    ///   - value: The value to compare against.
    public init(filterOperator: FilterOperator, field: CollectionsFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }

    /// The field to filter on.
    public let field: CollectionsFilterField

    /// The value to compare against in the filter.
    public let value: any FilterValue

    /// The operator to use for the filter comparison.
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

/// A sortable field for collections that can be used for both local and remote sorting.
public struct CollectionsSortField: SortField {
    /// The model type associated with this sort field.
    public typealias Model = CollectionData

    /// The comparator used for local sorting.
    public let comparator: AnySortComparator<Model>

    /// The string value representing the field name in the API for remote sorting.
    public let rawValue: String

    /// Creates a new sort field with the specified parameters.
    ///
    /// - Parameters:
    ///   - rawValue: The string value representing the field name in the API.
    ///   - localValue: A closure that extracts the comparable value from the model.
    public init<Value>(_ rawValue: String, localValue: @escaping @Sendable (Model) -> Value) where Value: Comparable & Sendable {
        comparator = AnySortComparator(localValue: localValue)
        self.rawValue = rawValue
    }
}

extension CollectionsSortField {
    /// Sort by the creation timestamp of the collection.
    public static let createdAt = Self("created_at", localValue: { $0.createdAt ?? .distantPast })

    /// Sort by the identifier of the collection.
    public static let id = Self("id", localValue: \.id)

    /// Sort by the last update timestamp of the collection.
    public static let updatedAt = Self("updated_at", localValue: { $0.updatedAt ?? .distantPast })
}

extension Sort where Field == CollectionsSortField {
    /// The default sorting for collections queries: newest first.
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension CollectionsQuery {
    func toRequest() -> QueryCollectionsRequest {
        QueryCollectionsRequest(
            filter: filter.flatMap { $0.toRawJSONDictionary() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
}
