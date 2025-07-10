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
    public var fid: FeedId
    
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
    ///   - fid: The feed ID to fetch members for.
    ///   - filter: Optional filter to apply to the members query.
    ///   - sort: Optional array of sorting criteria to apply to the members.
    ///   - limit: Optional maximum number of members to return in a single request.
    ///   - next: Optional pagination cursor for fetching the next page of results.
    ///   - previous: Optional pagination cursor for fetching the previous page of results.
    public init(
        fid: FeedId,
        filter: MembersFilter? = nil,
        sort: [Sort<MembersSortField>]? = nil,
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.fid = fid
        self.filter = filter
        self.limit = limit
        self.next = next
        self.previous = previous
        self.sort = sort
    }
}

// MARK: - Filters

/// Represents a field that can be used in members filtering.
///
/// This type provides a type-safe way to specify which field should be used
/// when creating filters for members queries.
public struct MembersFilterField: FilterFieldRepresentable, Sendable {
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
    init(codingKey: FeedMemberResponse.CodingKeys) {
        value = codingKey.rawValue
    }
}

extension MembersFilterField {
    /// Filter by the creation timestamp of the member.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let createdAt = Self(codingKey: .createdAt)
    
    /// Filter by the role of the member in the feed.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let role = Self(codingKey: .role)
    
    /// Filter by the status of the member (e.g., "accepted", "pending").
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let status = Self(codingKey: .status)
    
    /// Filter by the last update timestamp of the member.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let updatedAt = Self(codingKey: .updatedAt)
    
    /// Filter by the user ID of the member.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let userId = Self(value: "user_id")
    
    /// Filter by the feed ID that the member belongs to.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let fid = Self(value: "fid")
    
    /// Filter by whether the member is a request (true/false).
    ///
    /// **Supported operators:** `.equal`
    public static let request = Self(value: "request")
}

/// A filter that can be applied to members queries.
///
/// Use this struct to create filters that narrow down member results
/// based on specific field values and operators.
///
/// ## Supported Operators by Field Type
///
/// **String fields** (`userId`, `fid`, `role`, `status`):
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

/// Represents a field that can be used for sorting members.
///
/// This type provides a type-safe way to specify which field should be used
/// when sorting members results.
public struct MembersSortField: SortField {
    /// The model type associated with this sort field.
    public typealias Model = FeedMemberData
    
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
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
}
