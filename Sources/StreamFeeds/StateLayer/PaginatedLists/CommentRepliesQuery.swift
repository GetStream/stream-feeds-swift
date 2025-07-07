//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query configuration for fetching replies to a specific comment.
///
/// This struct defines the parameters used to fetch replies to a comment,
/// including pagination settings, sorting options, and depth configuration for
/// nested reply structures.
///
/// ## Usage
///
/// ```swift
/// // Create a basic query for comment replies
/// let query = CommentRepliesQuery(
///     commentId: "comment-123"
/// )
///
/// // Create a query with custom parameters
/// let query = CommentRepliesQuery(
///     commentId: "comment-123",
///     sort: "created_at",
///     depth: 2,
///     limit: 20,
///     repliesLimit: 5
/// )
///
/// // Use the query to create a reply list
/// let replyList = client.commentReplyList(for: query)
/// ```
///
/// ## Features
///
/// - **Pagination**: Supports `next` and `previous` cursors for efficient pagination
/// - **Sorting**: Configurable sorting options for reply ordering
/// - **Depth Control**: Limits the depth of nested reply structures
/// - **Reply Limits**: Controls the number of nested replies to fetch per reply
/// - **Thread Safety**: Conforms to `Sendable` for safe concurrent access
public struct CommentRepliesQuery: Sendable {
    /// The unique identifier of the comment to fetch replies for.
    public var commentId: String
    
    /// The maximum depth of nested replies to fetch.
    ///
    /// This parameter controls how many levels of nested replies to include.
    /// For example, a depth of 2 will include replies and their direct replies,
    /// but not replies to replies to replies.
    ///
    /// - `nil`: No depth limit
    /// - `1`: Only direct replies to the comment
    /// - `2`: Replies and their direct replies
    /// - `3`: Replies, replies to replies, and replies to replies to replies
    public var depth: Int?
    
    /// The maximum number of replies to fetch per request.
    ///
    /// This parameter controls the page size for pagination. Larger values
    /// reduce the number of API calls needed but may increase response time.
    ///
    /// - `nil`: Use server default
    public var limit: Int?
    
    /// The pagination cursor for fetching the next page of replies.
    ///
    /// This cursor is provided by the server in the pagination response and
    /// should be used to fetch the next page of results.
    public var next: String?
    
    /// The pagination cursor for fetching the previous page of replies.
    ///
    /// This cursor is provided by the server in the pagination response and
    /// should be used to fetch the previous page of results.
    public var previous: String?
    
    /// The maximum number of nested replies to fetch per reply.
    ///
    /// This parameter controls how many nested replies are included for each
    /// reply in the response. It's useful for limiting the size of deeply
    /// threaded reply structures.
    public var repliesLimit: Int?
    
    /// The sorting criteria for replies.
    ///
    /// This parameter determines the order in which replies are returned.
    /// Common sorting options include:
    ///
    /// - `"created_at"`: Sort by creation time (newest first)
    /// - `"-created_at"`: Sort by creation time (oldest first)
    /// - `"updated_at"`: Sort by last update time
    /// - `"score"`: Sort by reply score
    /// - `"reaction_count"`: Sort by number of reactions
    ///
    /// - `nil`: Use server default sorting
    public var sort: CommentRepliesSort?
    
    /// Initializes a new CommentRepliesQuery instance.
    ///
    /// - Parameters:
    ///   - commentId: The unique identifier of the comment to fetch replies for
    ///   - sort: Optional sorting criteria for replies
    ///   - depth: Optional maximum depth for nested replies
    ///   - limit: Optional maximum number of replies per request
    ///   - repliesLimit: Optional maximum number of nested replies per reply
    ///   - next: Optional pagination cursor for next page
    ///   - previous: Optional pagination cursor for previous page
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Basic query
    /// let query = CommentRepliesQuery(
    ///     commentId: "comment-123"
    /// )
    ///
    /// // Advanced query with all parameters
    /// let query = CommentRepliesQuery(
    ///     commentId: "comment-123",
    ///     sort: "created_at",
    ///     depth: 2,
    ///     limit: 25,
    ///     repliesLimit: 10,
    ///     next: "cursor-123",
    ///     previous: nil
    /// )
    /// ```
    public init(
        commentId: String,
        sort: String? = nil,
        depth: Int? = nil,
        limit: Int? = nil,
        repliesLimit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.commentId = commentId
        self.depth = depth
        self.sort = sort
        self.repliesLimit = repliesLimit
        self.limit = limit
        self.next = next
        self.previous = previous
    }
}

// MARK: - Sorting

/// A type alias for reply sorting criteria.
///
/// This type represents the sorting string used to order replies in the response.
/// Common values include:
///
/// - `"created_at"`: Sort by creation time (newest first)
/// - `"-created_at"`: Sort by creation time (oldest first)
/// - `"updated_at"`: Sort by last update time
/// - `"score"`: Sort by reply score
/// - `"reaction_count"`: Sort by number of reactions
///
/// ## Example
///
/// ```swift
/// let query = CommentRepliesQuery(
///     commentId: "comment-123",
///     sort: "created_at"  // Newest replies first
/// )
/// ```
public typealias CommentRepliesSort = String
