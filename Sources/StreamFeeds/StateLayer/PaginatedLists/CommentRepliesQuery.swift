//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query configuration for fetching replies to a specific comment.
///
/// This struct defines the parameters used to fetch replies to a comment,
/// including pagination settings, sorting options, and depth configuration for
/// nested reply structures.
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
    public var sort: CommentsSort?
    
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
    public init(
        commentId: String,
        sort: CommentsSort? = nil,
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
