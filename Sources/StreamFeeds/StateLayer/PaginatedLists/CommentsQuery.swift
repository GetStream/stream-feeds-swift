//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query for retrieving comments with filtering, sorting, and pagination options.
///
/// Use this struct to configure how comments should be fetched from the Stream Feeds API.
/// You can specify filters to narrow down results, sorting options, and pagination parameters.
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

/// A filter field for comments that defines how filter fields are represented as strings.
///
/// This protocol allows for type-safe field names while maintaining the ability to convert to string values
/// for API communication.
public struct CommentsFilterField: FilterFieldRepresentable, Sendable {
    public typealias Model = CommentData
    public let matcher: AnyFilterMatcher<Model>
    public let rawValue: String
    
    public init<Value>(_ rawValue: String, localValue: @escaping @Sendable (Model) -> Value?) where Value: FilterValue {
        self.rawValue = rawValue
        matcher = AnyFilterMatcher(localValue: localValue)
    }
}

extension CommentsFilterField {
    /// Filter by the unique identifier of the comment.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let id = Self("id", localValue: \.id)
    
    /// Filter by the user ID who created the comment.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let userId = Self("user_id", localValue: \.user.id)
    
    /// Filter by the type of object the comment belongs to (e.g., "activity", "post").
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let objectType = Self("object_type", localValue: \.objectType)
    
    /// Filter by the ID of the object the comment belongs to.
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let objectId = Self("object_id", localValue: \.objectId)
    
    /// Filter by the ID of the parent comment (for replies).
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let parentId = Self("parent_id", localValue: \.parentId)
    
    /// Filter by the text content of the comment.
    ///
    /// **Supported operators:** `.q` (full-text search)
    public static let commentText = Self("comment_text", localValue: \.text)
    
    /// Filter by the status of the comment (e.g., "active", "deleted", "moderated").
    ///
    /// **Supported operators:** `.equal`, `.in`
    public static let status = Self("status", localValue: \.status)
    
    /// Filter by the number of upvotes the comment has received.
    ///
    /// **Supported operators:** `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let upvoteCount = Self("upvote_count", localValue: \.upvoteCount)
    
    /// Filter by the number of downvotes the comment has received.
    ///
    /// **Supported operators:** `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let downvoteCount = Self("downvote_count", localValue: \.downvoteCount)
    
    /// Filter by the number of replies the comment has received.
    ///
    /// **Supported operators:** `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let replyCount = Self("reply_count", localValue: \.replyCount)
    
    /// Filter by the score of the comment.
    ///
    /// **Supported operators:** `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let score = Self("score", localValue: \.score)
    
    /// Filter by the confidence score of the comment.
    ///
    /// **Supported operators:** `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let confidenceScore = Self("confidence_score", localValue: \.confidenceScore)
    
    /// Filter by the controversy score of the comment.
    ///
    /// **Supported operators:** `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let controversyScore = Self("controversy_score", localValue: \.controversyScore)
    
    /// Filter by the creation timestamp of the comment.
    ///
    /// **Supported operators:** `.equal`, `.greaterThan`, `.lessThan`, `.greaterThanOrEqual`, `.lessThanOrEqual`
    public static let createdAt = Self("created_at", localValue: \.createdAt)
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
public typealias CommentsSort = QueryCommentsRequest.QueryCommentsRequestSort

protocol CommentsSortDataFields {
    var createdAt: Date { get }
    var confidenceScore: Float { get }
    var controversyScore: Float? { get }
    var score: Int { get }
}

extension CommentsSort {
    static func areInIncreasingOrder(_ sort: CommentsSort) -> (CommentsSortDataFields, CommentsSortDataFields) -> Bool {
        { lhs, rhs in
            switch sort {
            case .top:
                if lhs.score != rhs.score {
                    return lhs.score > rhs.score
                }
                return lhs.createdAt > rhs.createdAt
            case .best:
                if lhs.confidenceScore != rhs.confidenceScore {
                    return lhs.confidenceScore > rhs.confidenceScore
                }
                return lhs.createdAt > rhs.createdAt
            case .controversial:
                let lhsControversy = lhs.controversyScore ?? -1
                let rhsControversy = rhs.controversyScore ?? -1
                if lhsControversy != rhsControversy {
                    return lhsControversy > rhsControversy
                }
                return false
            case .first:
                return lhs.createdAt < rhs.createdAt
            case .last:
                return lhs.createdAt > rhs.createdAt
            case .unknown:
                return lhs.createdAt > rhs.createdAt
            }
        }
    }
}

// MARK: -

extension CommentsQuery {
    func toRequest() -> QueryCommentsRequest {
        QueryCommentsRequest(
            filter: filter?.toRawJSONDictionary() ?? [:],
            limit: limit,
            next: next,
            prev: previous,
            sort: sort
        )
    }
}
