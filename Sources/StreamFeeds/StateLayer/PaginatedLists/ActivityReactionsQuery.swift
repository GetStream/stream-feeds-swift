//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query for retrieving activity reactions with filtering, sorting, and pagination options.
///
/// Use this struct to configure how activity reactions should be fetched from the Stream Feeds API.
/// You can specify filters to narrow down results, sorting options, and pagination parameters.
public struct ActivityReactionsQuery: Sendable {
    /// The unique identifier of the activity to fetch reactions for.
    public var activityId: String
    
    /// Optional filter to apply to the activity reactions query.
    /// Use this to narrow down results based on specific criteria.
    public var filter: ActivityReactionsFilter?
    
    /// Maximum number of activity reactions to return in a single request.
    /// If not specified, the API will use its default limit.
    public var limit: Int?
    
    /// Pagination cursor for fetching the next page of results.
    /// This is typically provided in the response of a previous request.
    public var next: String?
    
    /// Pagination cursor for fetching the previous page of results.
    /// This is typically provided in the response of a previous request.
    public var previous: String?
    
    /// Array of sorting criteria to apply to the activity reactions.
    /// If not specified, the API will use its default sorting.
    public var sort: [Sort<ActivityReactionsSortField>]?

    /// Creates a new activity reactions query with the specified parameters.
    ///
    /// - Parameters:
    ///   - activityId: The unique identifier of the activity to fetch reactions for.
    ///   - filter: Optional filter to apply to the activity reactions query.
    ///   - sort: Optional array of sorting criteria to apply to the activity reactions.
    ///   - limit: Optional maximum number of activity reactions to return in a single request.
    ///   - next: Optional pagination cursor for fetching the next page of results.
    ///   - previous: Optional pagination cursor for fetching the previous page of results.
    public init(
        activityId: String,
        filter: ActivityReactionsFilter? = nil,
        sort: [Sort<ActivityReactionsSortField>]? = nil,
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.activityId = activityId
        self.filter = filter
        self.limit = limit
        self.next = next
        self.previous = previous
        self.sort = sort
    }
}

// MARK: - Filters

/// Represents a field that can be used in activity reactions filtering.
///
/// This type provides a type-safe way to specify which field should be used
/// when creating filters for activity reactions queries.
public struct ActivityReactionsFilterField: FilterFieldRepresentable, Sendable {
    /// The string value representing the field name in the API.
    public let value: String
    
    /// Creates a new filter field with the specified value.
    ///
    /// - Parameter value: The string value representing the field name.
    public init(value: String) {
        self.value = value
    }
}

extension ActivityReactionsFilterField {
    /// Filter by the reaction type (e.g., "like", "love", "angry").
    /// 
    /// **Supported operators:** `.equal`, `.in`
    public static let reactionType = Self(value: "reaction_type")
    
    /// Filter by the user ID who created the reaction.
    /// 
    /// **Supported operators:** `.equal`, `.in`
    public static let userId = Self(value: "user_id")
    
    /// Filter by the creation timestamp of the reaction.
    /// 
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let createdAt = Self(value: "created_at")
}

/// A filter that can be applied to activity reactions queries.
///
/// Use this struct to create filters that narrow down activity reaction results
/// based on specific field values and operators.
///
/// ## Supported Operators by Field Type
/// 
/// **String fields** (`reactionType`, `userId`):
/// - `.equal` - Exact match
/// - `.in` - Match any value in a list
/// 
/// **Date fields** (`createdAt`):
/// - `.equal` - Exact match
/// - `.greaterThan` - After the specified date
/// - `.lessThan` - Before the specified date
/// - `.greaterThanOrEqual` - On or after the specified date
/// - `.lessThanOrEqual` - On or before the specified date
public struct ActivityReactionsFilter: Filter {
    /// Creates a new activity reactions filter with the specified parameters.
    ///
    /// - Parameters:
    ///   - filterOperator: The operator to use for the filter comparison.
    ///   - field: The field to filter on.
    ///   - value: The value to compare against.
    public init(filterOperator: FilterOperator, field: ActivityReactionsFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    /// The field to filter on.
    public let field: ActivityReactionsFilterField
    
    /// The value to compare against in the filter.
    public let value: any FilterValue
    
    /// The operator to use for the filter comparison.
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

/// Represents a field that can be used for sorting activity reactions.
///
/// This type provides a type-safe way to specify which field should be used
/// when sorting activity reactions results.
public struct ActivityReactionsSortField: SortField {
    /// The model type associated with this sort field.
    public typealias Model = FeedsReactionData
    
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
    
    /// Sort by the creation timestamp of the reaction.
    /// This field allows sorting reactions by when they were created (newest/oldest first).
    public static let createdAt = Self("created_at", localValue: \.createdAt)
}

extension Sort where Field == ActivityReactionsSortField {
    /// The default sorting for activity reactions queries.
    /// Sorts by creation date in descending order (newest first).
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension ActivityReactionsQuery {
    func toRequest() -> QueryActivityReactionsRequest {
        QueryActivityReactionsRequest(
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
} 