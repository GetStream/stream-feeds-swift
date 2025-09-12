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

/// A filter field for feeds that defines how filter fields are represented as strings.
///
/// This protocol allows for type-safe field names while maintaining the ability to convert to string values
/// for API communication.
public struct FeedsFilterField: FilterFieldRepresentable, Sendable {
    public typealias Model = FeedData
    public let matcher: AnyFilterMatcher<Model>
    public let rawValue: String
    
    public init<Value>(_ rawValue: String, localValue: @escaping @Sendable (Model) -> Value?) where Value: FilterValue {
        self.rawValue = rawValue
        matcher = AnyFilterMatcher(localValue: localValue)
    }
    
    init<Value>(remoteCodingKey: FeedResponse.CodingKeys, localValue: @escaping @Sendable (Model) -> Value?) where Value: FilterValue {
        self.init(remoteCodingKey.rawValue, localValue: localValue)
    }
}

extension FeedsFilterField {
    /// Filter by the unique identifier of the feed.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let id = Self("id", localValue: \.id)
    
    /// Filter by the group ID of the feed.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let groupId = Self("group_id", localValue: \.groupId)
    
    /// Filter by the feed ID of the feed.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let feed = Self("feed", localValue: \.feed.rawValue)
    
    /// Filter by the creation timestamp of the feed.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let createdAt = Self("created_at", localValue: \.createdAt)
    
    /// Filter by the ID of the user who created the feed.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let createdById = Self("created_by_id", localValue: \.createdBy.id)
    
    /// Filter by the name of the user who created the feed.
    ///
    /// **Supported operators:** `.equal`, `.customQ`, `.customAutocomplete`
    public static let createdByName = Self("created_by.name", localValue: \.createdBy.name)
    
    /// Filter by the description of the feed.
    ///
    /// **Supported operators:** `.equal`, `.customQ`, `.customAutocomplete`
    public static let description = Self("description", localValue: \.description)
    
    /// Filter by the number of followers the feed has.
    ///
    /// **Supported operators:** `.equal`, `.notEqual`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let followerCount = Self("follower_count", localValue: \.followerCount)
    
    /// Filter by the number of feeds this feed is following.
    ///
    /// **Supported operators:** `.equal`, `.notEqual`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let followingCount = Self("following_count", localValue: \.followingCount)
    
    /// Filter by the number of members in the feed.
    ///
    /// **Supported operators:** `.equal`, `.notEqual`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let memberCount = Self("member_count", localValue: \.memberCount)
    
    /// Filter by specific members in the feed.
    ///
    /// **Supported operators:** `.in`
    public static let members = Self("members", localValue: \.memberIds)
    
    /// Filter by the name of the feed.
    ///
    /// **Supported operators:** `.equal`, `.customQ`, `.customAutocomplete`
    public static let name = Self("name", localValue: \.name)
    
    /// Filter by the last update timestamp of the feed.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let updatedAt = Self("updated_at", localValue: \.updatedAt)
    
    /// Filter by the visibility setting of the feed.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let visibility = Self("visibility", localValue: \.visibility)
    
    /// Filter by feeds that this feed is following.
    ///
    /// **Supported operators:** `.in`
    public static let followingFeeds = Self("following_feeds", localValue: \.followingFeedIds)
    
    /// Filter by filter tags associated with the feed.
    ///
    /// **Supported operators:** `.equal`, `.in`, `.customContains`
    public static let filterTags = Self("filter_tags", localValue: \.filterTags)
}

/// A filter that can be applied to feeds queries.
///
/// Use this struct to create filters that narrow down feed results
/// based on specific field values and operators.
///
/// ## Supported Operators by Field Type
///
/// **String fields** (`id`, `groupId`, `feed`, `createdById`, `visibility`):
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

/// A sortable field for feeds that can be used for both local and remote sorting.
///
/// This type provides the foundation for creating sortable fields that can be used
/// both for local sorting and remote API requests. It includes a comparator for local
/// sorting operations and a remote string identifier for API communication.
///
/// - Note: The associated `Model` type must conform to `Sendable` to ensure thread safety.
public struct FeedsSortField: SortField {
    /// The model type associated with this sort field.
    public typealias Model = FeedData
    
    /// The comparator used for local sorting.
    public let comparator: AnySortComparator<Model>
    
    /// The string value representing the field name in the API for remote sorting.
    public let rawValue: String
    
    public init<Value>(_ rawValue: String, localValue: @escaping @Sendable (Model) -> Value) where Value: Comparable {
        comparator = AnySortComparator(localValue: localValue)
        self.rawValue = rawValue
    }
    
    /// Sort by the creation timestamp of the feed.
    /// This field allows sorting feeds by when they were created (newest/oldest first).
    public static let createdAt = Self("created_at", localValue: \.createdAt)
    
    /// Sort by the number of followers the feed has.
    /// This field allows sorting feeds by popularity (most/least followed).
    public static let followerCount = Self("follower_count", localValue: \.followerCount)
    
    /// Sort by the number of feeds this feed is following.
    /// This field allows sorting feeds by how many feeds they follow.
    public static let followingCount = Self("following_count", localValue: \.followingCount)
    
    /// Sort by the number of members in the feed.
    /// This field allows sorting feeds by member count (most/least members).
    public static let memberCount = Self("member_count", localValue: \.memberCount)
    
    /// Sort by the last update timestamp of the feed.
    /// This field allows sorting feeds by when they were last updated (newest/oldest first).
    public static let updatedAt = Self("updated_at", localValue: \.updatedAt)
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
