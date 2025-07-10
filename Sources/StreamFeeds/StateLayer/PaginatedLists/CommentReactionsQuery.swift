//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query configuration for fetching reactions for a specific comment.
///
/// This struct defines the parameters used to fetch reactions for a comment,
/// including pagination settings, sorting options, and filtering capabilities.
///
/// ## Features
///
/// - **Pagination**: Supports `next` and `previous` cursors for efficient pagination
/// - **Sorting**: Configurable sorting options for reaction ordering
/// - **Filtering**: Supports filtering by reaction type, user ID, and creation date
/// - **Thread Safety**: Conforms to `Sendable` for safe concurrent access
public struct CommentReactionsQuery: Sendable {
    /// The unique identifier of the comment to fetch reactions for.
    public let commentId: String
    
    /// Optional filter to apply to the comment reactions query.
    /// Use this to narrow down results based on specific criteria.
    public var filter: CommentReactionsFilter?
    
    /// Maximum number of comment reactions to return in a single request.
    /// If not specified, the API will use its default limit.
    public var limit: Int?
    
    /// Pagination cursor for fetching the next page of results.
    /// This is typically provided in the response of a previous request.
    public var next: String?
    
    /// Pagination cursor for fetching the previous page of results.
    /// This is typically provided in the response of a previous request.
    public var previous: String?
    
    /// Array of sorting criteria to apply to the comment reactions.
    /// If not specified, the API will use its default sorting.
    public var sort: [Sort<CommentReactionsSortField>]?

    /// Creates a new comment reactions query with the specified parameters.
    ///
    /// - Parameters:
    ///   - commentId: The unique identifier of the comment to fetch reactions for.
    ///   - filter: Optional filter to apply to the comment reactions query.
    ///   - sort: Optional array of sorting criteria to apply to the comment reactions.
    ///   - limit: Optional maximum number of comment reactions to return in a single request.
    ///   - next: Optional pagination cursor for fetching the next page of results.
    ///   - previous: Optional pagination cursor for fetching the previous page of results.
    public init(
        commentId: String,
        filter: CommentReactionsFilter? = nil,
        sort: [Sort<CommentReactionsSortField>]? = nil,
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.commentId = commentId
        self.filter = filter
        self.limit = limit
        self.next = next
        self.previous = previous
        self.sort = sort
    }
}

// MARK: - Filters

/// Represents a field that can be used in comment reactions filtering.
///
/// This type provides a type-safe way to specify which field should be used
/// when creating filters for comment reactions queries.
public struct CommentReactionsFilterField: FilterFieldRepresentable, Sendable {
    /// The string value representing the field name in the API.
    public let value: String
    
    /// Creates a new filter field with the specified value.
    ///
    /// - Parameter value: The string value representing the field name.
    public init(value: String) {
        self.value = value
    }
}

extension CommentReactionsFilterField {
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

/// A filter that can be applied to comment reactions queries.
///
/// Use this struct to create filters that narrow down comment reaction results
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
public struct CommentReactionsFilter: Filter {
    /// Creates a new comment reactions filter with the specified parameters.
    ///
    /// - Parameters:
    ///   - filterOperator: The operator to use for the filter comparison.
    ///   - field: The field to filter on.
    ///   - value: The value to compare against.
    public init(filterOperator: FilterOperator, field: CommentReactionsFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    /// The field to filter on.
    public let field: CommentReactionsFilterField
    
    /// The value to compare against in the filter.
    public let value: any FilterValue
    
    /// The operator to use for the filter comparison.
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

/// Represents a field that can be used for sorting comment reactions.
///
/// This type provides a type-safe way to specify which field should be used
/// when sorting comment reactions results.
public struct CommentReactionsSortField: SortField {
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

extension Sort where Field == CommentReactionsSortField {
    /// The default sorting for comment reactions queries.
    /// Sorts by creation date in descending order (newest first).
    static let defaultSorting = [Sort(field: .createdAt, direction: .reverse)]
}

// MARK: -

extension CommentReactionsQuery {
    func toRequest() -> QueryCommentReactionsRequest {
        QueryCommentReactionsRequest(
            filter: filter.flatMap { $0.toRawJSON() },
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.map { $0.toRequest() }
        )
    }
} 