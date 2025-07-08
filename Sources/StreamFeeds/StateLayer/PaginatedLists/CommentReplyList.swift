//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A class representing a paginated list of replies for a specific comment.
///
/// This class provides methods to fetch and manage replies to a comment, including
/// pagination support and real-time updates through WebSocket events. It maintains an
/// observable state that automatically updates when reply-related events are received.
///
/// ## Usage
///
/// ```swift
/// // Create a reply list for a comment
/// let replyList = client.commentReplyList(
///     for: .init(commentId: "comment-123")
/// )
///
/// // Fetch initial replies
/// let replies = try await replyList.get()
///
/// // Load more replies if available
/// if replyList.state.canLoadMore {
///     let moreReplies = try await replyList.queryMoreReplies()
/// }
///
/// // Observe state changes
/// replyList.state.$replies
///     .sink { replies in
///         // Handle reply updates
///     }
///     .store(in: &cancellables)
/// ```
///
/// ## Features
///
/// - **Pagination**: Supports loading replies in pages with configurable limits
/// - **Real-time Updates**: Automatically receives WebSocket events for reply changes
/// - **Threaded Replies**: Supports nested reply structures with depth control
/// - **Reactions**: Tracks reply reactions and updates in real-time
/// - **Observable State**: Provides reactive state management for UI updates
///
/// ## Thread Safety
///
/// This class is thread-safe and conforms to `Sendable`. All state updates are
/// performed on the main actor to ensure UI consistency.
public final class CommentReplyList: Sendable {
    @MainActor private let stateBuilder: StateBuilder<CommentReplyListState>
    private let commentsRepository: CommentsRepository
    
    /// Initializes a new CommentReplyList instance.
    ///
    /// - Parameters:
    ///   - query: The query configuration for fetching replies
    ///   - client: The feeds client instance
    init(query: CommentRepliesQuery, client: FeedsClient) {
        commentsRepository = client.commentsRepository
        self.query = query
        let events = client.eventsMiddleware
        stateBuilder = StateBuilder { CommentReplyListState(query: query, events: events) }
    }

    /// The query configuration used to fetch replies.
    public let query: CommentRepliesQuery
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the reply list.
    ///
    /// This property provides access to the current replies, pagination information,
    /// and real-time updates. The state automatically updates when WebSocket events
    /// are received for reply additions, updates, deletions, and reactions.
    ///
    /// ```swift
    /// // Observe reply changes
    /// replyList.state.$replies
    ///     .sink { replies in
    ///         // Update UI with new replies
    ///     }
    ///     .store(in: &cancellables)
    ///
    /// // Check if more replies can be loaded
    /// if replyList.state.canLoadMore {
    ///     // Load more replies
    /// }
    /// ```
    @MainActor public var state: CommentReplyListState { stateBuilder.state }
    
    // MARK: - Paginating the List of Comments
    
    /// Fetches the initial set of replies for the comment.
    ///
    /// This method retrieves the first page of replies based on the query configuration.
    /// The results are automatically stored in the state and can be accessed through
    /// the `state.replies` property.
    ///
    /// - Returns: An array of `CommentData` representing the fetched replies
    /// - Throws: `APIError` if the network request fails or the server returns an error
    ///
    /// ## Example
    ///
    /// ```swift
    /// do {
    ///     let replies = try await replyList.get()
    ///     print("Fetched \(replies.count) replies")
    /// } catch {
    ///     print("Failed to fetch replies: \(error)")
    /// }
    /// ```
    @discardableResult
    public func get() async throws -> [CommentData] {
        try await queryReplies(with: query)
    }
    
    /// Loads the next page of replies if more are available.
    ///
    /// This method fetches additional replies using the pagination information
    /// from the previous request. If no more replies are available, an empty
    /// array is returned.
    ///
    /// - Parameter limit: Optional limit for the number of replies to fetch.
    ///   If not specified, uses the limit from the original query.
    /// - Returns: An array of `CommentData` representing the additional replies.
    ///   Returns an empty array if no more replies are available.
    /// - Throws: An error if the network request fails or the response cannot be parsed.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Check if more replies are available
    /// guard replyList.state.canLoadMore else { return }
    ///
    /// // Load more replies
    /// do {
    ///     let moreReplies = try await replyList.queryMoreReplies(limit: 20)
    ///     print("Loaded \(moreReplies.count) more replies")
    /// } catch {
    ///     print("Failed to load more replies: \(error)")
    /// }
    /// ```
    public func queryMoreReplies(limit: Int? = nil) async throws -> [CommentData] {
        let nextQuery: CommentRepliesQuery? = await state.access { state in
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
    
    private func queryReplies(with query: CommentRepliesQuery) async throws -> [CommentData] {
        let result = try await commentsRepository.getCommentReplies(with: query)
        await state.didPaginate(with: result)
        return result.models
    }
}
