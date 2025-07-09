//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query for retrieving comments with filtering, sorting, and pagination options.
///
/// Use this struct to configure how comments should be fetched from the Stream Feeds API.
/// You can specify filters to narrow down results, sorting options, and pagination parameters.
///
/// ## Example Usage
/// ```swift
/// // Simple query with basic filter
/// let query = CommentsQuery(
///     filter: CommentsFilter(
///         filterOperator: .equal,
///         field: .objectId,
///         value: "activity-123"
///     ),
///     sort: .best,
///     limit: 20
/// )
/// 
/// // Complex query with multiple filters
/// let complexQuery = CommentsQuery(
///     filter: CommentsFilter(
///         filterOperator: .and,
///         filters: [
///             CommentsFilter(filterOperator: .equal, field: .objectId, value: "activity-123"),
///             CommentsFilter(filterOperator: .greaterThan, field: .score, value: 5.0),
///             CommentsFilter(filterOperator: .equal, field: .status, value: "active")
///         ]
///     ),
///     sort: .top,
///     limit: 50
/// )
/// ```
public struct CommentsQuery: Sendable {
    /// Filter criteria for the comments query.
    /// 
    /// This filter can be a simple single filter or a complex combination of multiple filters
    /// using logical operators (`.and`, `.or`). The filter determines which comments are
    /// included in the query results based on field values and comparison operators.
    public var filter: CommentsFilter?
    
    /// The sorting strategy to apply to the comments.
    /// 
    /// Available options:
    /// - `.first` - Chronological order (oldest first)
    /// - `.last` - Reverse chronological order (newest first)
    /// - `.top` - By popularity (most upvotes first)
    /// - `.best` - By quality score (best quality first)
    /// - `.controversial` - By controversy level (most controversial first)
    public var sort: CommentsSort?
    
    /// Maximum number of comments to return in a single request.
    /// If not specified, the API will use its default limit.
    public var limit: Int?
    
    /// Pagination cursor for fetching the next page of results.
    /// This is typically provided in the response of a previous request.
    public var next: String?
    
    /// Pagination cursor for fetching the previous page of results.
    /// This is typically provided in the response of a previous request.
    public var previous: String?
    
    /// Creates a new comments query with the specified parameters.
    ///
    /// - Parameters:
    ///   - filter: The filter criteria to apply to the comments query.
    ///   - sort: Optional sorting strategy to apply to the comments.
    ///   - limit: Optional maximum number of comments to return in a single request.
    ///   - next: Optional pagination cursor for fetching the next page of results.
    ///   - previous: Optional pagination cursor for fetching the previous page of results.
    public init(
        filter: CommentsFilter?,
        sort: CommentsSort? = nil,
        limit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.filter = filter
        self.sort = sort
        self.limit = limit
        self.next = next
        self.previous = previous
    }
}

// MARK: - Filters

/// Represents a field that can be used in comments filtering.
///
/// This type provides a type-safe way to specify which field should be used
/// when creating filters for comments queries.
public struct CommentsFilterField: FilterFieldRepresentable, Hashable, Sendable {
    /// The string value representing the field name in the API.
    public let value: String
    
    /// Creates a new filter field with the specified value.
    ///
    /// - Parameter value: The string value representing the field name.
    public init(value: String) {
        self.value = value
    }
}

extension CommentsFilterField {
    /// Filter by the unique identifier of the comment.
    /// 
    /// **Supported operators:** `.equal`, `.in`
    public static let id = Self(value: "id")
    
    /// Filter by the user ID who created the comment.
    /// 
    /// **Supported operators:** `.equal`, `.in`
    public static let userId = Self(value: "user_id")
    
    /// Filter by the type of object the comment belongs to (e.g., "activity", "post").
    /// 
    /// **Supported operators:** `.equal`, `.notEqual`, `.in`
    public static let objectType = Self(value: "object_type")
    
    /// Filter by the ID of the object the comment belongs to.
    /// 
    /// **Supported operators:** `.equal`, `.in`
    public static let objectId = Self(value: "object_id")
    
    /// Filter by the ID of the parent comment (for replies).
    /// 
    /// **Supported operators:** `.equal`, `.in`
    public static let parentId = Self(value: "parent_id")
    
    /// Filter by the text content of the comment.
    /// 
    /// **Supported operators:** `.q` (full-text search)
    public static let commentText = Self(value: "comment_text")
    
    /// Filter by the status of the comment (e.g., "active", "deleted", "moderated").
    /// 
    /// **Supported operators:** `.equal`, `.in`
    public static let status = Self(value: "status")
    
    /// Filter by the number of upvotes the comment has received.
    /// 
    /// **Supported operators:** `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let upvoteCount = Self(value: "upvote_count")
    
    /// Filter by the number of downvotes the comment has received.
    /// 
    /// **Supported operators:** `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let downvoteCount = Self(value: "downvote_count")
    
    /// Filter by the number of replies the comment has received.
    /// 
    /// **Supported operators:** `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let replyCount = Self(value: "reply_count")
    
    /// Filter by the score of the comment.
    /// 
    /// **Supported operators:** `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let score = Self(value: "score")
    
    /// Filter by the confidence score of the comment.
    /// 
    /// **Supported operators:** `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let confidenceScore = Self(value: "confidence_score")
    
    /// Filter by the controversy score of the comment.
    /// 
    /// **Supported operators:** `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let controversyScore = Self(value: "controversy_score")
    
    /// Filter by the creation timestamp of the comment.
    /// 
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let createdAt = Self(value: "created_at")
}

/// A filter that can be applied to comments queries.
///
/// Use this struct to create filters that narrow down comment results
/// based on specific field values and operators. This provides a type-safe
/// way to build complex queries for retrieving comments from the Stream Feeds API.
///
/// ## Supported Operators by Field Type
/// 
/// **String fields** (`id`, `userId`, `objectId`, `parentId`):
/// - `.equal` - Exact match
/// - `.in` - Match any value in a list
/// 
/// **Object type fields** (`objectType`):
/// - `.equal` - Exact match
/// - `.in` - Match any value in a list
/// 
/// **Text search fields** (`commentText`):
/// - `.q` - Full-text search query
/// 
/// **Status fields** (`status`):
/// - `.equal` - Exact match
/// - `.in` - Match any value in a list
/// 
/// **Number fields** (`upvoteCount`, `downvoteCount`, `replyCount`, `score`, `confidenceScore`, `controversyScore`):
/// - `.greaterThan` - Greater than the specified value
/// - `.lessThan` - Less than the specified value
/// - `.greaterThanOrEqual` - Greater than or equal to the specified value
/// - `.lessThanOrEqual` - Less than or equal to the specified value
/// 
/// **Date fields** (`createdAt`):
/// - `.equal` - Exact match
/// - `.greaterThan` - After the specified date
/// - `.lessThan` - Before the specified date
/// - `.greaterThanOrEqual` - On or after the specified date
/// - `.lessThanOrEqual` - On or before the specified date
public struct CommentsFilter: Filter {
    /// Creates a new comments filter with the specified parameters.
    ///
    /// - Parameters:
    ///   - filterOperator: The operator to use for the filter comparison.
    ///   - field: The field to filter on.
    ///   - value: The value to compare against.
    public init(filterOperator: FilterOperator, field: CommentsFilterField, value: any FilterValue) {
        self.filterOperator = filterOperator
        self.field = field
        self.value = value
    }
    
    /// The field to filter on.
    public let field: CommentsFilterField
    
    /// The value to compare against in the filter.
    public let value: any FilterValue
    
    /// The operator to use for the filter comparison.
    public let filterOperator: FilterOperator
}

// MARK: - Sorting

/// Represents sorting options for comments queries.
public struct CommentsSort: RawRepresentable, Sendable {
    /// The raw string value representing the sort option in the API.
    public let rawValue: String
    
    /// Creates a new sort option with the specified raw value.
    ///
    /// - Parameter rawValue: The raw string value representing the sort option.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    /// Sort by creation date (oldest first).
    /// This is useful for displaying comments in chronological order.
    public static let first = Self(rawValue: "first")
    
    /// Sort by creation date (newest first).
    /// This is useful for displaying the most recent comments first.
    public static let last = Self(rawValue: "last")
    
    /// Sort by upvote count (highest first).
    /// This is useful for displaying the most popular comments first.
    public static let top = Self(rawValue: "top")
    
    /// Sort by quality score (best quality first).
    /// This uses a combination of factors to determine comment quality.
    public static let best = Self(rawValue: "best")
    
    /// Sort by controversy level (most controversial first).
    /// This is useful for highlighting discussions with mixed opinions.
    public static let controversial = Self(rawValue: "controversial")
}

// MARK: -

extension CommentsQuery {
    /// Converts the query to a raw API request format.
    ///
    /// This method transforms the filter dictionary into the format expected by the API,
    /// converting string arrays to RawJSON arrays for each filter field. The conversion
    /// handles different field types appropriately:
    /// 
    /// - **String fields**: Converted to exact match or "in" list filters
    /// - **Text fields**: Converted to full-text search queries
    /// - **Number fields**: Converted to range comparison filters
    /// - **Date fields**: Converted to date range filters
    ///
    /// ## Filter Conversion Examples
    /// ```swift
    /// // Input filter
    /// filter: [.activityIds: ["activity-123"]]
    /// 
    /// // Converted to API format
    /// filter: ["activity_ids": ["activity-123"]]
    /// ```
    ///
    /// - Returns: A `QueryCommentsRequest` object that can be sent to the API.
    func toRequest() -> QueryCommentsRequest {
        QueryCommentsRequest(
            filter: filter?.toRawJSON() ?? [:],
            limit: limit,
            next: next,
            prev: previous,
            sort: sort?.rawValue
        )
    }
}
