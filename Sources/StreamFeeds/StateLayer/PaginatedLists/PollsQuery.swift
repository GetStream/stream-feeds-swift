//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query for retrieving polls with filtering, sorting, and pagination options.
///
/// Use this struct to configure how polls should be fetched from the Stream Feeds API.
/// You can specify filters to narrow down results, sorting options, and pagination parameters.
public struct PollsQuery: Sendable {
    /// Optional filter to apply to the polls query.
    /// Use this to narrow down results based on specific criteria.
    public var filter: PollsFilter?
    
    /// Maximum number of polls to return in a single request.
    /// If not specified, the API will use its default limit.
    public var limit: Int?
    
    /// Pagination cursor for fetching the next page of results.
    /// This is typically provided in the response of a previous request.
    public var next: String?
    
    /// Pagination cursor for fetching the previous page of results.
    /// This is typically provided in the response of a previous request.
    public var previous: String?
    
    /// Array of sorting criteria to apply to the polls.
    /// If not specified, the API will use its default sorting.
    public var sort: [Sort<PollsSortField>]?

    /// Creates a new polls query with the specified parameters.
    ///
    /// - Parameters:
    ///   - filter: Optional filter to apply to the polls query.
    ///   - sort: Optional array of sorting criteria to apply to the polls.
    ///   - limit: Optional maximum number of polls to return in a single request.
    ///   - next: Optional pagination cursor for fetching the next page of results.
    ///   - previous: Optional pagination cursor for fetching the previous page of results.
    public init(
        filter: PollsFilter? = nil,
        sort: [Sort<PollsSortField>]? = nil,
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

/// Represents a field that can be used in polls filtering.
///
/// This type provides a type-safe way to specify which field should be used
/// when creating filters for polls queries.
public struct PollsFilterField: FilterFieldRepresentable, Sendable {
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
    init(codingKey: PollResponseData.CodingKeys) {
        value = codingKey.rawValue
    }
}

extension PollsFilterField {
    /// Filter by whether the poll allows answers.
    /// 
    /// **Supported operators:** `.equal`
    public static let allowAnswers = Self(codingKey: .allowAnswers)
    
    /// Filter by whether the poll allows user-suggested options.
    /// 
    /// **Supported operators:** `.equal`
    public static let allowUserSuggestedOptions = Self(codingKey: .allowUserSuggestedOptions)
    
    /// Filter by the creation timestamp of the poll.
    /// 
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let createdAt = Self(codingKey: .createdAt)
    
    /// Filter by the ID of the user who created the poll.
    /// 
    /// **Supported operators:** `.equal`, `.in`
    public static let createdById = Self(value: "created_by_id")
    
    /// Filter by the unique identifier of the poll.
    /// 
    /// **Supported operators:** `.equal`, `.in`
    public static let id = Self(codingKey: .id)
    
    /// Filter by whether the poll is closed.
    /// 
    /// **Supported operators:** `.equal`
    public static let isClosed = Self(codingKey: .isClosed)
    
    /// Filter by the maximum number of votes allowed per user.
    /// 
    /// **Supported operators:** `.equal`, `.notEqual`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let maxVotesAllowed = Self(codingKey: .maxVotesAllowed)
    
    /// Filter by the name of the poll.
    /// 
    /// **Supported operators:** `.equal`, `.in`
    public static let name = Self(codingKey: .name)
    
    /// Filter by the last update timestamp of the poll.
    /// 
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let updatedAt = Self(codingKey: .updatedAt)
    
    /// Filter by the voting visibility setting of the poll.
    /// 
    /// **Supported operators:** `.equal`
    public static let votingVisibility = Self(codingKey: .votingVisibility)
}

/// A filter that can be applied to polls queries.
///
/// Use this struct to create filters that narrow down poll results
/// based on specific field values and operators.
///
/// ## Supported Operators by Field Type
/// 
/// **String fields** (`id`, `name`, `createdById`, `votingVisibility`):
/// - `.equal` - Exact match
/// - `.in` - Match any value in a list
/// 
/// **Boolean fields** (`allowAnswers`, `allowUserSuggestedOptions`, `isClosed`):
/// - `.equal` - Exact match (true/false)
/// 
/// **Number fields** (`maxVotesAllowed`):
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
public struct PollsFilter: Filter {
    /// Creates a new polls filter with the specified parameters.
    ///
    /// - Parameters:
    ///   - filterOperator: The operator to use for the filter comparison.
    ///   - field: The field to filter on.
    ///   - value: The value to compare against.
    public init(filterOperator: FilterOperator, field: PollsFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    /// The field to filter on.
    public let field: PollsFilterField
    
    /// The value to compare against in the filter.
    public let value: any FilterValue
    
    /// The operator to use for the filter comparison.
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

/// Represents a field that can be used for sorting polls.
///
/// This type provides a type-safe way to specify which field should be used
/// when sorting polls results.
public struct PollsSortField: SortField {
    /// The model type associated with this sort field.
    public typealias Model = PollData
    
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
    
    /// Sort by the creation timestamp of the poll.
    /// This field allows sorting polls by when they were created (newest/oldest first).
    public static let createdAt = Self("created_at", localValue: \.createdAt)
    
    /// Sort by the last update timestamp of the poll.
    /// This field allows sorting polls by when they were last updated (newest/oldest first).
    public static let updatedAt = Self("updated_at", localValue: \.updatedAt)
    
    /// Sort by the number of votes the poll has received.
    /// This field allows sorting polls by popularity (most/least voted).
    public static let voteCount = Self("vote_count", localValue: \.voteCount)
    
    /// Sort by the name of the poll.
    /// This field allows sorting polls alphabetically by name.
    public static let name = Self("name", localValue: \.name)
    
    /// Sort by the unique identifier of the poll.
    /// This field allows sorting polls by their unique ID.
    public static let id = Self("id", localValue: \.id)
    
    /// Sort by whether the poll is closed.
    /// This field allows sorting polls by their closed status.
    public static let isClosed = Self("is_closed", localValue: { $0.isClosed ? 1 : 0 })
}

extension Sort where Field == PollsSortField {
    /// The default sorting for polls queries.
    /// Sorts by creation date in descending order (newest first).
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension PollsQuery {
    /// Converts the query to a raw API request format.
    ///
    /// - Returns: A `QueryPollsRequest` object that can be sent to the API.
    func toRequest() -> QueryPollsRequest {
        QueryPollsRequest(
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
}
