//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query for retrieving follows with filtering, sorting, and pagination options.
///
/// Use this struct to configure how follows should be fetched from the Stream Feeds API.
/// You can specify filters to narrow down results, sorting options, and pagination parameters.
public struct FollowsQuery: Sendable {
    /// Optional filter to apply to the follows query.
    /// Use this to narrow down results based on specific criteria.
    public var filter: FollowsFilter?
    
    /// Maximum number of follows to return in a single request.
    /// If not specified, the API will use its default limit.
    public var limit: Int?
    
    /// Pagination cursor for fetching the next page of results.
    /// This is typically provided in the response of a previous request.
    public var next: String?
    
    /// Pagination cursor for fetching the previous page of results.
    /// This is typically provided in the response of a previous request.
    public var previous: String?
    
    /// Array of sorting criteria to apply to the follows.
    /// If not specified, the API will use its default sorting.
    public var sort: [Sort<FollowsSortField>]?

    /// Creates a new follows query with the specified parameters.
    ///
    /// - Parameters:
    ///   - filter: Optional filter to apply to the follows query.
    ///   - sort: Optional array of sorting criteria to apply to the follows.
    ///   - limit: Optional maximum number of follows to return in a single request.
    ///   - next: Optional pagination cursor for fetching the next page of results.
    ///   - previous: Optional pagination cursor for fetching the previous page of results.
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

/// Represents a field that can be used in follows filtering.
///
/// This type provides a type-safe way to specify which field should be used
/// when creating filters for follows queries.
public struct FollowsFilterField: FilterFieldRepresentable, Sendable {
    public typealias Model = FollowData
    public let matcher: AnyFilterMatcher<Model>
    public let remote: String
    
    public init<Value>(remote: String, localValue: @escaping @Sendable (Model) -> Value?) where Value: FilterValue {
        self.remote = remote
        matcher = AnyFilterMatcher(localValue: localValue)
    }
    
    init<Value>(remoteCodingKey: FollowResponse.CodingKeys, localValue: @escaping @Sendable (Model) -> Value?) where Value: FilterValue {
        self.init(remote: remoteCodingKey.rawValue, localValue: localValue)
    }
}

extension FollowsFilterField {
    /// Filter by the source feed ID (the feed that is following).
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let sourceFeed = Self(remote: "source_feed", localValue: \.sourceFeed.feed.rawValue)
    
    /// Filter by the target feed ID (the feed being followed).
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let targetFeed = Self(remote: "target_feed", localValue: \.targetFeed.feed.rawValue)
    
    /// Filter by the status of the follow relationship (e.g., "accepted", "pending").
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let status = Self(remote: "status", localValue: \.status.rawValue)
    
    /// Filter by the creation timestamp of the follow relationship.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let createdAt = Self(remote: "created_at", localValue: \.createdAt)
}

/// A filter that can be applied to follows queries.
///
/// Use this struct to create filters that narrow down follow results
/// based on specific field values and operators.
///
/// ## Supported Operators by Field Type
///
/// **String fields** (`sourceFeed`, `targetFeed`, `status`):
/// - `.equal` - Exact match
/// - `.in` - Match any value in a list
///
/// **Date fields** (`createdAt`):
/// - `.equal` - Exact match
/// - `.greaterThan` - After the specified date
/// - `.lessThan` - Before the specified date
/// - `.greaterThanOrEqual` - On or after the specified date
/// - `.lessThanOrEqual` - On or before the specified date
public struct FollowsFilter: Filter {
    /// Creates a new follows filter with the specified parameters.
    ///
    /// - Parameters:
    ///   - filterOperator: The operator to use for the filter comparison.
    ///   - field: The field to filter on.
    ///   - value: The value to compare against.
    public init(filterOperator: FilterOperator, field: FollowsFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    /// The field to filter on.
    public let field: FollowsFilterField
    
    /// The value to compare against in the filter.
    public let value: any FilterValue
    
    /// The operator to use for the filter comparison.
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

/// Represents a field that can be used for sorting follows.
///
/// This type provides a type-safe way to specify which field should be used
/// when sorting follows results.
public struct FollowsSortField: SortField {
    /// The model type associated with this sort field.
    public typealias Model = FollowData
    
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
        comparator = AnySortComparator(localValue: localValue)
        self.remote = remote
    }
    
    /// Sort by the creation timestamp of the follow relationship.
    /// This field allows sorting follows by when they were created (newest/oldest first).
    public static let createdAt = Self("created_at", localValue: \.createdAt)
}

extension Sort where Field == FollowsSortField {
    /// The default sorting for follows queries.
    /// Sorts by creation date in descending order (newest first).
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
