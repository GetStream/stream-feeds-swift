//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query for retrieving poll votes with filtering, sorting, and pagination options.
///
/// Use this struct to configure how poll votes should be fetched from the Stream Feeds API.
/// You can specify filters to narrow down results, sorting options, and pagination parameters.
public struct PollVotesQuery: Sendable {
    /// The unique identifier of the poll to fetch votes for.
    public var pollId: String
    
    /// Optional user ID used for authentication.
    public var userId: String?
    
    /// Optional filter to apply to the poll votes query.
    /// Use this to narrow down results based on specific criteria.
    public var filter: PollVotesFilter?
    
    /// Maximum number of poll votes to return in a single request.
    /// If not specified, the API will use its default limit.
    public var limit: Int?
    
    /// Pagination cursor for fetching the next page of results.
    /// This is typically provided in the response of a previous request.
    public var next: String?
    
    /// Pagination cursor for fetching the previous page of results.
    /// This is typically provided in the response of a previous request.
    public var previous: String?
    
    /// Array of sorting criteria to apply to the poll votes.
    /// If not specified, the API will use its default sorting.
    public var sort: [Sort<PollVotesSortField>]?

    /// Creates a new poll votes query with the specified parameters.
    ///
    /// - Parameters:
    ///   - pollId: The unique identifier of the poll to fetch votes for.
    ///   - userId: Optional user ID used for authentication.
    ///   - filter: Optional filter to apply to the poll votes query.
    ///   - sort: Optional array of sorting criteria to apply to the poll votes.
    ///   - limit: Optional maximum number of poll votes to return in a single request.
    ///   - next: Optional pagination cursor for fetching the next page of results.
    ///   - previous: Optional pagination cursor for fetching the previous page of results.
    public init(
        pollId: String,
        userId: String? = nil,
        filter: PollVotesFilter? = nil,
        sort: [Sort<PollVotesSortField>]? = nil,
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.filter = filter
        self.limit = limit
        self.next = next
        self.previous = previous
        self.pollId = pollId
        self.sort = sort
        self.userId = userId
    }
}

// MARK: - Filters

/// Represents a field that can be used in poll votes filtering.
///
/// This type provides a type-safe way to specify which field should be used
/// when creating filters for poll votes queries.
public struct PollVotesFilterField: FilterFieldRepresentable, Sendable {
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
    init(codingKey: PollVoteResponseData.CodingKeys) {
        value = codingKey.rawValue
    }
}

extension PollVotesFilterField {
    /// Filter by the creation timestamp of the poll vote.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let createdAt = Self(codingKey: .createdAt)
    
    /// Filter by the unique identifier of the poll vote.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let id = Self(codingKey: .id)
    
    /// Filter by whether the vote is an answer (true/false).
    ///
    /// **Supported operators:** `.equal`
    public static let isAnswer = Self(value: "is_answer")
    
    /// Filter by the option ID that was voted for.
    ///
    /// **Supported operators:** `.equal`, `.in`, `.exists`
    public static let optionId = Self(value: "option_id")
    
    /// Filter by the user ID who cast the vote.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let userId = Self(value: "user_id")
    
    /// Filter by the poll ID that the vote belongs to.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let pollId = Self(value: "poll_id")
    
    /// Filter by the last update timestamp of the poll vote.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let updatedAt = Self(value: "updated_at")
}

/// A filter that can be applied to poll votes queries.
///
/// Use this struct to create filters that narrow down poll vote results
/// based on specific field values and operators.
///
/// ## Supported Operators by Field Type
///
/// **String fields** (`id`, `pollId`, `userId`, `optionId`):
/// - `.equal` - Exact match
/// - `.in` - Match any value in a list
/// - `.exists` - Field exists (only for `optionId`)
///
/// **Boolean fields** (`isAnswer`):
/// - `.equal` - Exact match (true/false)
///
/// **Date fields** (`createdAt`, `updatedAt`):
/// - `.equal` - Exact match
/// - `.greaterThan` - After the specified date
/// - `.lessThan` - Before the specified date
/// - `.greaterThanOrEqual` - On or after the specified date
/// - `.lessThanOrEqual` - On or before the specified date
public struct PollVotesFilter: Filter {
    /// Creates a new poll votes filter with the specified parameters.
    ///
    /// - Parameters:
    ///   - filterOperator: The operator to use for the filter comparison.
    ///   - field: The field to filter on.
    ///   - value: The value to compare against.
    public init(filterOperator: FilterOperator, field: PollVotesFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    /// The field to filter on.
    public let field: PollVotesFilterField
    
    /// The value to compare against in the filter.
    public let value: any FilterValue
    
    /// The operator to use for the filter comparison.
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

/// Represents a field that can be used for sorting poll votes.
///
/// This type provides a type-safe way to specify which field should be used
/// when sorting poll votes results.
public struct PollVotesSortField: SortField {
    /// The model type associated with this sort field.
    public typealias Model = PollVoteData
    
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
    
    /// Sort by the answer text of the poll option.
    /// This field allows sorting poll votes by the text content of the selected option.
    public static let answerText = Self("answer_text", localValue: { $0.answerText ?? "" })
    
    /// Sort by the unique identifier of the poll vote.
    /// This field allows sorting poll votes by their unique ID.
    public static let id = Self("id", localValue: \.id)
    
    /// Sort by the creation timestamp of the poll vote.
    /// This field allows sorting poll votes by when they were created (newest/oldest first).
    public static let createdAt = Self("created_at", localValue: \.createdAt)
    
    /// Sort by the last update timestamp of the poll vote.
    /// This field allows sorting poll votes by when they were last updated (newest/oldest first).
    public static let updatedAt = Self("updated_at", localValue: \.updatedAt)
}

extension Sort where Field == PollVotesSortField {
    /// The default sorting for poll votes queries.
    /// Sorts by creation date in descending order (newest first).
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension PollVotesQuery {
    func toRequest() -> QueryPollVotesRequest {
        QueryPollVotesRequest(
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
}
