//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A class representing a paginated list of comments for a specific activity.
///
/// This class provides methods to fetch and manage comments for an activity, including
/// pagination support and real-time updates through WebSocket events. It maintains an
/// observable state that automatically updates when comment-related events are received.
///
/// ## Usage
///
/// ```swift
/// // Create a comment list for an activity
/// let commentList = client.activityCommentList(
///     for: .init(objectId: "activity-123", objectType: "activity")
/// )
///
/// // Fetch initial comments
/// let comments = try await commentList.get()
///
/// // Load more comments if available
/// if commentList.state.canLoadMore {
///     let moreComments = try await commentList.queryMoreReplies()
/// }
///
/// // Observe state changes
/// commentList.state.$comments
///     .sink { comments in
///         // Handle comment updates
///     }
///     .store(in: &cancellables)
/// ```
///
/// ## Features
///
/// - **Pagination**: Supports loading comments in pages with configurable limits
/// - **Real-time Updates**: Automatically receives WebSocket events for comment changes
/// - **Threaded Comments**: Supports nested comment replies
/// - **Reactions**: Tracks comment reactions and updates in real-time
/// - **Observable State**: Provides reactive state management for UI updates
///
/// ## Thread Safety
///
/// This class is thread-safe and conforms to `Sendable`. All state updates are
/// performed on the main actor to ensure UI consistency.
public final class ActivityCommentList: Sendable {
    @MainActor private let stateBuilder: StateBuilder<ActivityCommentListState>
    private let commentsRepository: CommentsRepository
    
    init(query: ActivityCommentsQuery, client: FeedsClient) {
        self.commentsRepository = client.commentsRepository
        self.query = query
        let events = client.eventsMiddleware
        stateBuilder = StateBuilder { ActivityCommentListState(query: query, events: events) }
    }

    /// The query configuration used to fetch comments.
    public let query: ActivityCommentsQuery
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the comment list.
    ///
    /// This property provides access to the current comments, pagination information,
    /// and real-time updates. The state automatically updates when WebSocket events
    /// are received for comment additions, updates, deletions, and reactions.
    ///
    /// ```swift
    /// // Observe comment changes
    /// commentList.state.$comments
    ///     .sink { comments in
    ///         // Update UI with new comments
    ///     }
    ///     .store(in: &cancellables)
    ///
    /// // Check if more comments can be loaded
    /// if commentList.state.canLoadMore {
    ///     // Load more comments
    /// }
    /// ```
    @MainActor public var state: ActivityCommentListState { stateBuilder.state }
    
    // MARK: - Paginating the List of Comments
    
    /// Fetches the initial set of comments for the activity.
    ///
    /// This method retrieves the first page of comments based on the query configuration.
    /// The results are automatically stored in the state and can be accessed through
    /// the `state.comments` property.
    ///
    /// - Returns: An array of `CommentData` representing the fetched comments
    /// - Throws: `APIError` if the network request fails or the server returns an error
    ///
    /// ## Example
    ///
    /// ```swift
    /// do {
    ///     let comments = try await commentList.get()
    ///     print("Fetched \(comments.count) comments")
    /// } catch {
    ///     print("Failed to fetch comments: \(error)")
    /// }
    /// ```
    @discardableResult
    public func get() async throws -> [CommentData] {
        try await queryReplies(with: query)
    }
    
    /// Loads the next page of comments if more are available.
    ///
    /// This method fetches additional comments using the pagination information
    /// from the previous request. If no more comments are available, an empty
    /// array is returned.
    ///
    /// - Parameter limit: Optional limit for the number of comments to fetch.
    ///   If not specified, uses the limit from the original query.
    /// - Returns: An array of `CommentData` representing the additional comments.
    ///   Returns an empty array if no more comments are available.
    /// - Throws: An error if the network request fails or the response cannot be parsed.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Check if more comments are available
    /// guard commentList.state.canLoadMore else { return }
    ///
    /// // Load more comments
    /// do {
    ///     let moreComments = try await commentList.queryMoreReplies(limit: 20)
    ///     print("Loaded \(moreComments.count) more comments")
    /// } catch {
    ///     print("Failed to load more comments: \(error)")
    /// }
    /// ```
    public func queryMoreReplies(limit: Int? = nil) async throws -> [CommentData] {
        let nextQuery: ActivityCommentsQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            var nextQuery = query
            nextQuery.limit = limit
            nextQuery.previous = nil
            nextQuery.next = next
            return nextQuery
        }
        guard let nextQuery else { return [] }
        return try await queryReplies(with: nextQuery)
    }
    
    // MARK: - Private
    
    /// Fetches comments using the specified query and updates the state.
    ///
    /// - Parameter query: The query configuration for fetching comments
    /// - Returns: An array of `CommentData` representing the fetched comments
    /// - Throws: An error if the network request fails or the response cannot be parsed
    private func queryReplies(with query: ActivityCommentsQuery) async throws -> [CommentData] {
        let result = try await commentsRepository.getComments(with: query)
        await state.didPaginate(with: result)
        return result.models
    }
} 
