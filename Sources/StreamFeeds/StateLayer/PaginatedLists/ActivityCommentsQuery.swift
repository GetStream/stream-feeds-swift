//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query configuration for fetching comments for a specific activity.
///
/// This struct defines the parameters used to fetch comments for an activity,
/// including pagination settings, sorting options, and depth configuration for
/// threaded comments.
///
/// ## Usage
///
/// ```swift
/// // Create a basic query for activity comments
/// let query = ActivityCommentsQuery(
///     objectId: "activity-123",
///     objectType: "activity"
/// )
///
/// // Create a query with custom parameters
/// let query = ActivityCommentsQuery(
///     objectId: "activity-123",
///     objectType: "activity",
///     sort: "created_at",
///     depth: 3,
///     limit: 20,
///     repliesLimit: 5
/// )
///
/// // Use the query to create a comment list
/// let commentList = client.activityCommentList(for: query)
/// ```
///
/// ## Features
///
/// - **Pagination**: Supports `next` and `previous` cursors for efficient pagination
/// - **Sorting**: Configurable sorting options for comment ordering
/// - **Depth Control**: Limits the depth of threaded comment replies
/// - **Reply Limits**: Controls the number of replies to fetch per comment
/// - **Thread Safety**: Conforms to `Sendable` for safe concurrent access
public struct ActivityCommentsQuery: Sendable {
    /// The unique identifier of the activity to fetch comments for.
    public let objectId: String
    
    /// The type of object (typically "activity" for activity comments).
    public let objectType: String
    
    /// The maximum depth of threaded comments to fetch.
    ///
    /// This parameter controls how many levels of nested replies to include.
    /// For example, a depth of 2 will include comments and their direct replies,
    /// but not replies to replies.
    ///
    /// - `nil`: No depth limit (fetch all levels)
    /// - `1`: Only top-level comments
    /// - `2`: Comments and their direct replies
    /// - `3`: Comments, replies, and replies to replies
    public var depth: Int?
    
    /// The maximum number of comments to fetch per request.
    ///
    /// This parameter controls the page size for pagination. Larger values
    /// reduce the number of API calls needed but may increase response time.
    ///
    /// - `nil`: Use server default (typically 25)
    /// - `10-50`: Recommended range for most use cases
    /// - `>50`: May impact performance
    public var limit: Int?
    
    /// The pagination cursor for fetching the next page of comments.
    ///
    /// This cursor is provided by the server in the pagination response and
    /// should be used to fetch the next page of results.
    public var next: String?
    
    /// The pagination cursor for fetching the previous page of comments.
    ///
    /// This cursor is provided by the server in the pagination response and
    /// should be used to fetch the previous page of results.
    public var previous: String?
    
    /// The maximum number of replies to fetch per comment.
    ///
    /// This parameter controls how many replies are included for each comment
    /// in the response. It's useful for limiting the size of threaded comments.
    ///
    /// - `nil`: Fetch all replies (subject to depth limit)
    /// - `5-10`: Recommended for most use cases
    /// - `>20`: May impact performance
    public var repliesLimit: Int?
    
    /// The sorting criteria for comments.
    ///
    /// This parameter determines the order in which comments are returned.
    /// Common sorting options include:
    ///
    /// - `"created_at"`: Sort by creation time (newest first)
    /// - `"-created_at"`: Sort by creation time (oldest first)
    /// - `"updated_at"`: Sort by last update time
    /// - `"score"`: Sort by comment score
    /// - `"reaction_count"`: Sort by number of reactions
    ///
    /// - `nil`: Use server default sorting
    public var sort: CommentRepliesSort?
    
    /// Initializes a new ActivityCommentsQuery instance.
    ///
    /// - Parameters:
    ///   - objectId: The unique identifier of the activity
    ///   - objectType: The type of object (typically "activity")
    ///   - sort: Optional sorting criteria for comments
    ///   - depth: Optional maximum depth for threaded comments
    ///   - limit: Optional maximum number of comments per request
    ///   - repliesLimit: Optional maximum number of replies per comment
    ///   - next: Optional pagination cursor for next page
    ///   - previous: Optional pagination cursor for previous page
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Basic query
    /// let query = ActivityCommentsQuery(
    ///     objectId: "activity-123",
    ///     objectType: "activity"
    /// )
    ///
    /// // Advanced query with all parameters
    /// let query = ActivityCommentsQuery(
    ///     objectId: "activity-123",
    ///     objectType: "activity",
    ///     sort: "created_at",
    ///     depth: 3,
    ///     limit: 25,
    ///     repliesLimit: 10,
    ///     next: "cursor-123",
    ///     previous: nil
    /// )
    /// ```
    public init(
        objectId: String,
        objectType: String,
        sort: ActivityCommentsSort? = nil,
        depth: Int? = nil,
        limit: Int? = nil,
        repliesLimit: Int? = nil,
        next: String? = nil,
        previous: String? = nil
    ) {
        self.objectId = objectId
        self.objectType = objectType
        self.depth = depth
        self.sort = sort
        self.repliesLimit = repliesLimit
        self.limit = limit
        self.next = next
        self.previous = previous
    }
}

// MARK: - Sorting

/// A type alias for comment sorting criteria.
///
/// This type represents the sorting string used to order comments in the response.
/// Common values include:
///
/// - `"created_at"`: Sort by creation time (newest first)
/// - `"-created_at"`: Sort by creation time (oldest first)
/// - `"updated_at"`: Sort by last update time
/// - `"score"`: Sort by comment score
/// - `"reaction_count"`: Sort by number of reactions
///
/// ## Example
///
/// ```swift
/// let query = ActivityCommentsQuery(
///     objectId: "activity-123",
///     objectType: "activity",
///     sort: "created_at"  // Newest comments first
/// )
/// ```
public typealias ActivityCommentsSort = String
