//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query for retrieving feed members with filtering, sorting, and pagination options.
///
/// Use this struct to configure how feed members should be fetched from the Stream Feeds API.
/// You can specify filters to narrow down results, sorting options, and pagination parameters.
public struct MembersQuery: Sendable {
    /// The feed ID to fetch members for.
    public var feed: FeedId
    
    /// Optional filter to apply to the members query.
    /// Use this to narrow down results based on specific criteria.
    public var filter: MembersFilter?
    
    /// Maximum number of members to return in a single request.
    /// If not specified, the API will use its default limit.
    public var limit: Int?
    
    /// Pagination cursor for fetching the next page of results.
    /// This is typically provided in the response of a previous request.
    public var next: String?
    
    /// Pagination cursor for fetching the previous page of results.
    /// This is typically provided in the response of a previous request.
    public var previous: String?
    
    /// Array of sorting criteria to apply to the members.
    /// If not specified, the API will use its default sorting.
    public var sort: [Sort<MembersSortField>]?

    /// Creates a new members query with the specified parameters.
    ///
    /// - Parameters:
    ///   - feed: The feed ID to fetch members for.
    ///   - filter: Optional filter to apply to the members query.
    ///   - sort: Optional array of sorting criteria to apply to the members.
    ///   - limit: Optional maximum number of members to return in a single request.
    ///   - next: Optional pagination cursor for fetching the next page of results.
    ///   - previous: Optional pagination cursor for fetching the previous page of results.
    public init(
        feed: FeedId,
        filter: MembersFilter? = nil,
        sort: [Sort<MembersSortField>]? = nil,
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.feed = feed
        self.filter = filter
        self.limit = limit
        self.next = next
        self.previous = previous
        self.sort = sort
    }
}

// MARK: - Filters

/// A filter field for feed members that defines how filter fields are represented as strings.
///
/// This protocol allows for type-safe field names while maintaining the ability to convert to string values
/// for API communication.
public struct MembersFilterField: FilterFieldRepresentable, Sendable {
    public typealias Model = FeedMemberData
    public let matcher: AnyFilterMatcher<Model>
    public let rawValue: String
    
    public init<Value>(_ rawValue: String, localValue: @escaping @Sendable (Model) -> Value?) where Value: FilterValue {
        self.rawValue = rawValue
        matcher = AnyFilterMatcher(localValue: localValue)
    }
}

extension MembersFilterField {
    /// Filter by the creation timestamp of the member.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let createdAt = Self("created_at", localValue: \.createdAt)
    
    /// Filter by the role of the member in the feed.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let role = Self("role", localValue: \.role)
    
    /// Filter by the status of the member (e.g., "accepted", "pending").
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let status = Self("status", localValue: \.status.rawValue)
    
    /// Filter by the last update timestamp of the member.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let updatedAt = Self("updated_at", localValue: \.updatedAt)
    
    /// Filter by the user ID of the member.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let userId = Self("user_id", localValue: \.user.id)
    
    /// Filter by the feed ID that the member belongs to.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let feed = Self("fid", localValue: \.localFilterData?.feed.rawValue)
}

/// A filter that can be applied to members queries.
///
/// Use this struct to create filters that narrow down member results
/// based on specific field values and operators.
///
/// ## Supported Operators by Field Type
///
/// **String fields** (`userId`, `feed`, `role`, `status`):
/// - `.equal` - Exact match
/// - `.in` - Match any value in a list
///
/// **Boolean fields** (`request`):
/// - `.equal` - Exact match (true/false)
///
/// **Date fields** (`createdAt`, `updatedAt`):
/// - `.equal` - Exact match
/// - `.greaterThan` - After the specified date
/// - `.lessThan` - Before the specified date
/// - `.greaterThanOrEqual` - On or after the specified date
/// - `.lessThanOrEqual` - On or before the specified date
public struct MembersFilter: Filter {
    /// Creates a new members filter with the specified parameters.
    ///
    /// - Parameters:
    ///   - filterOperator: The operator to use for the filter comparison.
    ///   - field: The field to filter on.
    ///   - value: The value to compare against.
    public init(filterOperator: FilterOperator, field: MembersFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    /// The field to filter on.
    public let field: MembersFilterField
    
    /// The value to compare against in the filter.
    public let value: any FilterValue
    
    /// The operator to use for the filter comparison.
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

/// A sortable field for feed members that can be used for both local and remote sorting.
///
/// This type provides the foundation for creating sortable fields that can be used
/// both for local sorting and remote API requests. It includes a comparator for local
/// sorting operations and a remote string identifier for API communication.
///
/// - Note: The associated `Model` type must conform to `Sendable` to ensure thread safety.
public struct MembersSortField: SortField {
    /// The model type associated with this sort field.
    public typealias Model = FeedMemberData
    
    /// The comparator used for local sorting.
    public let comparator: AnySortComparator<Model>
    
    /// The string value representing the field name in the API for remote sorting.
    public let rawValue: String
    
    /// Creates a new sort field with the specified parameters.
    ///
    /// - Parameters:
    ///   - rawValue: The string value representing the field name in the API.
    ///   - localValue: A closure that extracts the comparable value from the model.
    public init<Value>(_ rawValue: String, localValue: @escaping @Sendable (Model) -> Value) where Value: Comparable {
        comparator = AnySortComparator(localValue: localValue)
        self.rawValue = rawValue
    }
}

extension MembersSortField {
    /// Sort by the creation timestamp of the member.
    /// This field allows sorting members by when they were added to the feed (newest/oldest first).
    public static let createdAt = Self("created_at", localValue: \.createdAt)
    
    /// Sort by the last update timestamp of the member.
    /// This field allows sorting members by when they were last updated (newest/oldest first).
    public static let updatedAt = Self("updated_at", localValue: \.updatedAt)
    
    /// Sort by the user ID of the member.
    /// This field allows sorting members alphabetically by user ID.
    public static let userId = Self("user_id", localValue: \.user.id)
}

extension Sort where Field == MembersSortField {
    /// The default sorting for members queries.
    /// Sorts by creation date in descending order (newest first).
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension MembersQuery {
    /// Converts the query to a raw API request format.
    ///
    /// - Returns: A `QueryFeedMembersRequest` object that can be sent to the API.
    func toRequest() -> QueryFeedMembersRequest {
        QueryFeedMembersRequest(
            filter: filter.flatMap { $0.toRawJSONDictionary() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
}
