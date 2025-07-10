//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query for retrieving feeds with filtering, sorting, and pagination options.
///
/// Use this struct to configure how feeds should be fetched from the Stream Feeds API.
/// You can specify filters to narrow down results, sorting options, and pagination parameters.
///
/// ## Example Usage
/// ```swift
/// let query = FeedsQuery(
///     filter: FeedsFilter(
///         filterOperator: .equal,
///         field: .visibility,
///         value: "public"
///     ),
///     sort: [Sort(field: .createdAt, direction: .reverse)],
///     limit: 20
/// )
/// ```
public struct FeedsQuery: Sendable {
    /// Optional filter to apply to the feeds query.
    /// Use this to narrow down results based on specific criteria.
    public let filter: FeedsFilter?
    
    /// Maximum number of feeds to return in a single request.
    /// If not specified, the API will use its default limit.
    public let limit: Int?
    
    /// Pagination cursor for fetching the next page of results.
    /// This is typically provided in the response of a previous request.
    public let next: String?
    
    /// Pagination cursor for fetching the previous page of results.
    /// This is typically provided in the response of a previous request.
    public let previous: String?
    
    /// Array of sorting criteria to apply to the feeds.
    /// If not specified, the API will use its default sorting.
    public let sort: [Sort<FeedsSortField>]?
    
    /// Whether to watch for real-time updates on the feeds.
    /// Defaults to true for real-time functionality.
    public let watch: Bool

    /// Creates a new feeds query with the specified parameters.
    ///
    /// - Parameters:
    ///   - filter: Optional filter to apply to the feeds query.
    ///   - sort: Optional array of sorting criteria to apply to the feeds.
    ///   - limit: Optional maximum number of feeds to return in a single request.
    ///   - next: Optional pagination cursor for fetching the next page of results.
    ///   - previous: Optional pagination cursor for fetching the previous page of results.
    ///   - watch: Whether to watch for real-time updates on the feeds.
    public init(
        filter: FeedsFilter? = nil,
        sort: [Sort<FeedsSortField>]? = nil,
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil,
        watch: Bool = true
    ) {
        self.filter = filter
        self.limit = limit
        self.next = next
        self.previous = previous
        self.sort = sort
        self.watch = watch
    }
}

// MARK: - Filters

/// Represents a field that can be used in feeds filtering.
///
/// This type provides a type-safe way to specify which field should be used
/// when creating filters for feeds queries.
public struct FeedsFilterField: FilterFieldRepresentable, Sendable {
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
    init(codingKey: FeedResponse.CodingKeys) {
        value = codingKey.rawValue
    }
}

extension FeedsFilterField {
    /// Filter by the unique identifier of the feed.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let id = Self(codingKey: .id)
    
    /// Filter by the group ID of the feed.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let groupId = Self(codingKey: .groupId)
    
    /// Filter by the feed ID (fid) of the feed.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let fid = Self(codingKey: .fid)
    
    /// Filter by the creation timestamp of the feed.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let createdAt = Self(codingKey: .createdAt)
    
    /// Filter by the ID of the user who created the feed.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let createdById = Self(value: "created_by_id")
    
    /// Filter by the name of the user who created the feed.
    ///
    /// **Supported operators:** `.equal`, `.customQ`, `.customAutocomplete`
    public static let createdByName = Self(value: "created_by.name")
    
    /// Filter by the description of the feed.
    ///
    /// **Supported operators:** `.equal`, `.customQ`, `.customAutocomplete`
    public static let description = Self(codingKey: .description)
    
    /// Filter by the number of followers the feed has.
    ///
    /// **Supported operators:** `.equal`, `.notEqual`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let followerCount = Self(codingKey: .followerCount)
    
    /// Filter by the number of feeds this feed is following.
    ///
    /// **Supported operators:** `.equal`, `.notEqual`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let followingCount = Self(codingKey: .followingCount)
    
    /// Filter by the number of members in the feed.
    ///
    /// **Supported operators:** `.equal`, `.notEqual`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let memberCount = Self(codingKey: .memberCount)
    
    /// Filter by specific members in the feed.
    ///
    /// **Supported operators:** `.in`
    public static let members = Self(value: "members")
    
    /// Filter by the name of the feed.
    ///
    /// **Supported operators:** `.equal`, `.customQ`, `.customAutocomplete`
    public static let name = Self(codingKey: .name)
    
    /// Filter by the last update timestamp of the feed.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let updatedAt = Self(codingKey: .updatedAt)
    
    /// Filter by the visibility setting of the feed.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let visibility = Self(codingKey: .visibility)
    
    /// Filter by users that the feed is following.
    ///
    /// **Supported operators:** `.in`
    public static let followingUsers = Self(value: "following_users")
    
    /// Filter by feeds that this feed is following.
    ///
    /// **Supported operators:** `.in`
    public static let followingFeeds = Self(value: "following_feeds")
    
    /// Filter by filter tags associated with the feed.
    ///
    /// **Supported operators:** `.equal`, `.in`, `.customContains`
    public static let filterTags = Self(value: "filter_tags")
}

/// A filter that can be applied to feeds queries.
///
/// Use this struct to create filters that narrow down feed results
/// based on specific field values and operators.
///
/// ## Supported Operators by Field Type
///
/// **String fields** (`id`, `groupId`, `fid`, `createdById`, `visibility`):
/// - `.equal` - Exact match
/// - `.in` - Match any value in a list
///
/// **Text search fields** (`name`, `description`, `createdByName`):
/// - `.equal` - Exact match
/// - `.q` - Full-text search query
/// - `.autocomplete` - Autocomplete search
///
/// **Number fields** (`followerCount`, `followingCount`, `memberCount`):
/// - `.equal` - Exact match
/// - `.notEqual` - Not equal to the specified value
/// - `.greaterThan` - Greater than the specified value
/// - `.lessThan` - Less than the specified value
/// - `.greaterThanOrEqual` - Greater than or equal to the specified value
/// - `.lessThanOrEqual` - Less than or equal to the specified value
///
/// **Date fields** (`createdAt`, `updatedAt`):
/// - `.equal` - Exact match
/// - `.greaterThan` - After the specified date
/// - `.lessThan` - Before the specified date
/// - `.greaterThanOrEqual` - On or after the specified date
/// - `.lessThanOrEqual` - On or before the specified date
///
/// **Array fields** (`members`, `followingUsers`, `followingFeeds`):
/// - `.in` - Match any value in a list
///
/// **Tag fields** (`filterTags`):
/// - `.equal` - Exact match (array)
/// - `.in` - Match any value in a list
/// - `.contains` - Contains the specified tag
public struct FeedsFilter: Filter {
    /// Creates a new feeds filter with the specified parameters.
    ///
    /// - Parameters:
    ///   - filterOperator: The operator to use for the filter comparison.
    ///   - field: The field to filter on.
    ///   - value: The value to compare against.
    public init(filterOperator: FilterOperator, field: FeedsFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    /// The field to filter on.
    public let field: FeedsFilterField
    
    /// The value to compare against in the filter.
    public let value: any FilterValue
    
    /// The operator to use for the filter comparison.
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

/// Represents a field that can be used for sorting feeds.
///
/// This type provides a type-safe way to specify which field should be used
/// when sorting feeds results.
public struct FeedsSortField: SortField {
    /// The model type associated with this sort field.
    public typealias Model = FeedData
    
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
    
    /// Sort by the creation timestamp of the feed.
    /// This field allows sorting feeds by when they were created (newest/oldest first).
    public static let createdAt: Self = FeedsSortField("created_at", localValue: \.createdAt)
    
    /// Sort by the number of followers the feed has.
    /// This field allows sorting feeds by popularity (most/least followed).
    public static let followerCount: Self = FeedsSortField("follower_count", localValue: \.followerCount)
    
    /// Sort by the number of feeds this feed is following.
    /// This field allows sorting feeds by how many feeds they follow.
    public static let followingCount: Self = FeedsSortField("following_count", localValue: \.followingCount)
    
    /// Sort by the number of members in the feed.
    /// This field allows sorting feeds by member count (most/least members).
    public static let memberCount: Self = FeedsSortField("member_count", localValue: \.memberCount)
    
    /// Sort by the last update timestamp of the feed.
    /// This field allows sorting feeds by when they were last updated (newest/oldest first).
    public static let updatedAt: Self = FeedsSortField("updated_at", localValue: \.updatedAt)
}

extension Sort where Field == FeedsSortField {
    /// The default sorting for feeds queries.
    /// Sorts by creation date in ascending order (oldest first).
    static let defaultSorting = [Sort(field: .createdAt, direction: .forward)]
}

// MARK: -

extension FeedsQuery {
    /// Converts the query to a raw API request format.
    ///
    /// - Returns: A `QueryFeedsRequest` object that can be sent to the API.
    func toRequest() -> QueryFeedsRequest {
        QueryFeedsRequest(
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() },
            watch: watch
        )
    }
}
