//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query for retrieving activities with filtering, sorting, and pagination options.
///
/// Use this struct to configure how activities should be fetched from the Stream Feeds API.
/// You can specify filters to narrow down results, sorting options, and pagination parameters.
public struct ActivitiesQuery: Sendable {
    /// Optional filter to apply to the activities query.
    /// Use this to narrow down results based on specific criteria.
    public let filter: ActivitiesFilter?
    
    /// Array of sorting criteria to apply to the activities.
    /// If not specified, the API will use its default sorting.
    public let sort: [Sort<ActivitiesSortField>]?
    
    /// Pagination cursor for fetching the next page of results.
    /// This is typically provided in the response of a previous request.
    public let next: String?
    
    /// Pagination cursor for fetching the previous page of results.
    /// This is typically provided in the response of a previous request.
    public let previous: String?
    
    /// Maximum number of activities to return in a single request.
    /// If not specified, the API will use its default limit.
    public let limit: Int?
    
    /// Creates a new activities query with the specified parameters.
    ///
    /// - Parameters:
    ///   - filter: Optional filter to apply to the activities query.
    ///   - sort: Optional array of sorting criteria to apply to the activities.
    ///   - limit: Optional maximum number of activities to return in a single request.
    ///   - next: Optional pagination cursor for fetching the next page of results.
    ///   - previous: Optional pagination cursor for fetching the previous page of results.
    public init(
        filter: ActivitiesFilter?,
        sort: [Sort<ActivitiesSortField>] = [],
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.filter = filter
        self.sort = sort
        self.next = next
        self.previous = previous
        self.limit = limit
    }
}

// MARK: - Filters

/// Represents a field that can be used in activities filtering.
///
/// This type provides a type-safe way to specify which field should be used
/// when creating filters for activities queries.
public struct ActivitiesFilterField: FilterFieldRepresentable, Sendable {
    /// The string value representing the field name in the API.
    public let value: String
    
    /// Creates a new filter field with the specified value.
    ///
    /// - Parameter value: The string value representing the field name.
    public init(value: String) {
        self.value = value
    }
    
    /// Creates a filter field from a coding key.
    ///
    /// - Parameter codingKey: The coding key to convert to a filter field.
    init(codingKey: ActivityResponse.CodingKeys) {
        value = codingKey.rawValue
    }
}

extension ActivitiesFilterField {
    /// Filter by the creation timestamp of the activity.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let createdAt = Self(codingKey: .createdAt)
    
    /// Filter by the unique identifier of the activity.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let id = Self(codingKey: .id)
    
    /// Filter by the filter tags associated with the activity.
    ///
    /// **Supported operators:** `.equal`, `.in`, `.contains`
    public static let filterTags = Self(codingKey: .filterTags)
    
    /// Filter by the popularity score of the activity.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let popularity = Self(codingKey: .popularity)
    
    /// Filter by the search data content of the activity.
    ///
    /// **Supported operators:** `.equal`, `.q`, `.autocomplete`
    public static let searchData = Self(codingKey: .searchData)
    
    /// Filter by the text content of the activity.
    ///
    /// **Supported operators:** `.equal`, `.q`, `.autocomplete`
    public static let text = Self(codingKey: .text)
    
    /// Filter by the type of activity (e.g., "post", "comment", "reaction").
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let type = Self(codingKey: .type)
    
    /// Filter by the user ID who created the activity.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let userId = Self(value: "user_id")
}

/// A filter that can be applied to activities queries.
///
/// Use this struct to create filters that narrow down activity results
/// based on specific field values and operators.
///
/// ## Supported Operators by Field Type
///
/// **String fields** (`id`, `type`, `userId`):
/// - `.equal` - Exact match
/// - `.in` - Match any value in a list
///
/// **Text search fields** (`text`, `searchData`):
/// - `.equal` - Exact match
/// - `.q` - Full-text search query
/// - `.autocomplete` - Autocomplete search
///
/// **Number fields** (`popularity`):
/// - `.equal` - Exact match
/// - `.greaterThan` - Greater than the specified value
/// - `.lessThan` - Less than the specified value
/// - `.greaterThanOrEqual` - Greater than or equal to the specified value
/// - `.lessThanOrEqual` - Less than or equal to the specified value
///
/// **Date fields** (`createdAt`):
/// - `.equal` - Exact match
/// - `.greaterThan` - After the specified date
/// - `.lessThan` - Before the specified date
/// - `.greaterThanOrEqual` - On or after the specified date
/// - `.lessThanOrEqual` - On or before the specified date
///
/// **Tag fields** (`filterTags`):
/// - `.equal` - Exact match (array)
/// - `.in` - Match any value in a list
/// - `.contains` - Contains the specified tag
public struct ActivitiesFilter: Filter {
    /// Creates a new activities filter with the specified parameters.
    ///
    /// - Parameters:
    ///   - filterOperator: The operator to use for the filter comparison.
    ///   - field: The field to filter on.
    ///   - value: The value to compare against.
    public init(filterOperator: FilterOperator, field: ActivitiesFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    /// The field to filter on.
    public let field: ActivitiesFilterField
    
    /// The value to compare against in the filter.
    public let value: any FilterValue
    
    /// The operator to use for the filter comparison.
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

/// Represents a field that can be used for sorting activities.
///
/// This type provides a type-safe way to specify which field should be used
/// when sorting activities results.
public struct ActivitiesSortField: SortField {
    /// The model type associated with this sort field.
    public typealias Model = ActivityData
    
    /// The comparator used for local sorting.
    public let comparator: AnySortComparator<Model>
    
    /// The string value representing the field name in the API for remote sorting.
    public let remote: String
    
    /// Creates a new sort field with the specified parameters.
    ///
    /// - Parameters:
    ///   - remote: The string value representing the field name in the API.
    ///   - localValue: A closure that extracts the comparable value from the model.
    public init<Value>(_ remote: String, localValue: @escaping @Sendable (Model) -> Value) where Value: Comparable {
        comparator = SortComparator(localValue).toAny()
        self.remote = remote
    }
    
    /// Sort by the creation timestamp of the activity.
    /// This field allows sorting activities by when they were created (newest/oldest first).
    public static let createdAt = Self("created_at", localValue: \.createdAt)
    
    /// Sort by the popularity score of the activity.
    /// This field allows sorting activities by popularity (most/least popular first).
    public static let popularity = Self("popularity", localValue: \.popularity)
}

extension Sort where Field == ActivitiesSortField {
    /// The default sorting for activities queries.
    /// Sorts by creation date in descending order (newest first).
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension ActivitiesQuery {
    /// Converts the query to a raw API request format.
    ///
    /// - Returns: A `QueryActivitiesRequest` object that can be sent to the API.
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
