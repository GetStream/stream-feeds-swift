//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query configuration for fetching moderation configurations.
///
/// This struct defines the parameters used to fetch moderation configurations, including
/// pagination settings, sorting options, and filtering conditions.
///
/// ## Features
///
/// - **Pagination**: Supports `next` and `prev` cursors for efficient pagination
/// - **Sorting**: Configurable sorting options for configuration ordering
/// - **Filtering**: Advanced filtering conditions for configuration queries
/// - **Thread Safety**: Conforms to `Sendable` for safe concurrent access
public struct ModerationConfigsQuery: Sendable {
    /// Filter conditions for the moderation configuration query.
    ///
    /// This parameter allows you to specify complex filtering conditions
    /// for the moderation configuration query. The filter conditions are applied on the server
    /// and can include various operators and field combinations.
    public var filter: ModerationConfigsFilter?
    
    /// The maximum number of configurations to fetch per request.
    ///
    /// This parameter controls the page size for pagination. Larger values
    /// reduce the number of API calls needed but may increase response time.
    public var limit: Int?
    
    /// The pagination cursor for fetching the next page of configurations.
    ///
    /// This cursor is provided by the server in the pagination response and
    /// should be used to fetch the next page of results.
    public var next: String?
    
    /// The pagination cursor for fetching the previous page of configurations.
    ///
    /// This cursor is provided by the server in the pagination response and
    /// should be used to fetch the previous page of results.
    public var previous: String?
    
    /// The sorting criteria for configurations.
    ///
    /// This parameter defines how configurations should be ordered in the results.
    /// Multiple sort fields can be specified, with earlier fields taking precedence.
    public var sort: [Sort<ModerationConfigsSortField>]?
    
    /// Initializes a new ModerationConfigsQuery instance.
    ///
    /// - Parameters:
    ///   - filter: Filter conditions for the configuration query
    ///   - sort: Sorting criteria for configurations
    ///   - limit: Maximum number of configurations per request
    ///   - next: Pagination cursor for next page
    ///   - previous: Pagination cursor for previous page
    public init(
        filter: ModerationConfigsFilter? = nil,
        sort: [Sort<ModerationConfigsSortField>]? = nil,
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

/// Represents a field that can be used in moderation configuration filtering.
///
/// This type provides a type-safe way to specify which field should be used
/// when creating filters for moderation configuration queries.
public struct ModerationConfigFilterField: FilterFieldRepresentable, Sendable {
    /// The string value representing the field name in the API.
    public let value: String
    
    /// Creates a new filter field with the specified value.
    ///
    /// - Parameter value: The string value representing the field name.
    public init(value: String) {
        self.value = value
    }
}

extension ModerationConfigFilterField {
    /// Filter by the unique key of the moderation configuration.
    ///
    /// **Supported operators:** `.equal`, `.in`, `.autocomplete`
    public static let key = Self(value: "key")
    
    /// Filter by the creation timestamp of the configuration.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let createdAt = Self(value: "created_at")
    
    /// Filter by the last update timestamp of the configuration.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let updatedAt = Self(value: "updated_at")
    
    /// Filter by the team associated with the configuration.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let team = Self(value: "team")
}

/// A filter that can be applied to moderation configuration queries.
///
/// Use this struct to create filters that narrow down configuration results
/// based on specific field values and operators.
///
/// ## Supported Operators by Field Type
///
/// **String fields** (`key`, `team`):
/// - `.equal` - Exact match
/// - `.in` - Match any value in a list
///
/// **Autocomplete fields** (`key`):
/// - `.autocomplete` - Autocomplete search
///
/// **Date fields** (`createdAt`, `updatedAt`):
/// - `.equal` - Exact match
/// - `.greaterThan` - After the specified date
/// - `.lessThan` - Before the specified date
/// - `.greaterThanOrEqual` - On or after the specified date
/// - `.lessThanOrEqual` - On or before the specified date
public struct ModerationConfigsFilter: Filter {
    /// Creates a new moderation configuration filter with the specified parameters.
    ///
    /// - Parameters:
    ///   - filterOperator: The operator to use for the filter comparison.
    ///   - field: The field to filter on.
    ///   - value: The value to compare against.
    public init(filterOperator: FilterOperator, field: ModerationConfigFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    /// The field to filter on.
    public let field: ModerationConfigFilterField
    
    /// The value to compare against in the filter.
    public let value: any FilterValue
    
    /// The operator to use for the filter comparison.
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

/// Represents a field that can be used for sorting moderation configurations.
///
/// This type provides a type-safe way to specify which field should be used
/// when sorting moderation configuration results.
public struct ModerationConfigsSortField: SortField {
    /// The model type associated with this sort field.
    public typealias Model = ModerationConfigData
    
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
    
    /// Sort by the unique key of the configuration.
    /// This field allows sorting configurations by their key (alphabetical order).
    public static let key = Self("id", localValue: \.key)
    
    /// Sort by the creation timestamp of the configuration.
    /// This field allows sorting configurations by when they were created (newest/oldest first).
    public static let createdAt = Self("created_at", localValue: \.createdAt)
    
    /// Sort by the last update timestamp of the configuration.
    /// This field allows sorting configurations by when they were last updated (newest/oldest first).
    public static let updatedAt = Self("updated_at", localValue: \.updatedAt)
}

extension Sort where Field == ModerationConfigsSortField {
    /// The default sorting for moderation configuration queries.
    /// Sorts by creation date in descending order (newest first).
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension ModerationConfigsQuery {
    func toRequest() -> QueryModerationConfigsRequest {
        QueryModerationConfigsRequest(
            filter: filter?.toRawJSON(),
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
}
