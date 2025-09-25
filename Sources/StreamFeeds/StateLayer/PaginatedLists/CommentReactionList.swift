//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A class representing a paginated list of reactions for a specific comment.
///
/// This class provides methods to fetch and manage reactions for a comment, including
/// pagination support and real-time updates through WebSocket events. It maintains an
/// observable state that automatically updates when reaction-related events are received.
///
/// ## Usage
///
/// ```swift
/// // Create a reaction list for a comment
/// let reactionList = client.commentReactionList(
///     for: .init(commentId: "comment-123")
/// )
///
/// // Fetch initial reactions
/// let reactions = try await reactionList.get()
///
/// // Load more reactions if available
/// if reactionList.state.canLoadMore {
///     let moreReactions = try await reactionList.queryMoreReactions()
/// }
///
/// // Observe state changes
/// reactionList.state.$reactions
///     .sink { reactions in
///         // Handle reaction updates
///     }
///     .store(in: &cancellables)
/// ```
///
/// ## Features
///
/// - **Pagination**: Supports loading reactions in pages with configurable limits
/// - **Real-time Updates**: Automatically receives WebSocket events for reaction changes
/// - **Filtering**: Supports filtering by reaction type, user ID, and creation date
/// - **Sorting**: Configurable sorting options for reaction ordering
/// - **Observable State**: Provides reactive state management for UI updates
///
/// ## Thread Safety
///
/// This class is thread-safe and conforms to `Sendable`. All state updates are
/// performed on the main actor to ensure UI consistency.
public final class CommentReactionList: Sendable {
    @MainActor private let stateBuilder: StateBuilder<CommentReactionListState>
    private let commentsRepository: CommentsRepository
    
    init(query: CommentReactionsQuery, client: FeedsClient) {
        commentsRepository = client.commentsRepository
        self.query = query
        let eventPublisher = client.stateLayerEventPublisher
        stateBuilder = StateBuilder { [eventPublisher] in
            CommentReactionListState(
                query: query,
                eventPublisher: eventPublisher
            )
        }
    }

    /// The query configuration used to fetch comment reactions.
    ///
    /// This contains the comment ID, filters, sorting options, and pagination parameters
    /// that define how reactions should be fetched and displayed.
    public let query: CommentReactionsQuery
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the comment reaction list.
    ///
    /// This property provides access to the current reactions, pagination information,
    /// and real-time updates. The state automatically updates when WebSocket events
    /// are received for reaction additions, updates, and deletions.
    ///
    /// ```swift
    /// // Observe reaction changes
    /// reactionList.state.$reactions
    ///     .sink { reactions in
    ///         // Update UI with new reactions
    ///     }
    ///     .store(in: &cancellables)
    ///
    /// // Check if more reactions can be loaded
    /// if reactionList.state.canLoadMore {
    ///     // Load more reactions
    /// }
    /// ```
    @MainActor public var state: CommentReactionListState { stateBuilder.state }
    
    // MARK: - Paginating the List of Comment Reactions
    
    /// Fetches the initial set of reactions for the comment.
    ///
    /// This method retrieves the first page of reactions based on the query configuration.
    /// The results are automatically stored in the state and can be accessed through
    /// the `state.reactions` property.
    ///
    /// - Returns: An array of `FeedsReactionData` representing the fetched reactions
    /// - Throws: `APIError` if the network request fails or the server returns an error
    ///
    /// ## Example
    ///
    /// ```swift
    /// do {
    ///     let reactions = try await reactionList.get()
    ///     print("Fetched \(reactions.count) reactions")
    /// } catch {
    ///     print("Failed to fetch reactions: \(error)")
    /// }
    /// ```
    @discardableResult public func get() async throws -> [FeedsReactionData] {
        try await queryCommentReactions(with: query)
    }
    
    /// Loads the next page of reactions if more are available.
    ///
    /// This method fetches additional reactions using the pagination information
    /// from the previous request. If no more reactions are available, an empty
    /// array is returned.
    ///
    /// - Parameter limit: Optional limit for the number of reactions to fetch.
    ///   If not specified, uses the limit from the original query.
    /// - Returns: An array of `FeedsReactionData` representing the additional reactions.
    ///   Returns an empty array if no more reactions are available.
    /// - Throws: An error if the network request fails or the response cannot be parsed.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Check if more reactions are available
    /// guard reactionList.state.canLoadMore else { return }
    ///
    /// // Load more reactions
    /// do {
    ///     let moreReactions = try await reactionList.queryMoreReactions(limit: 20)
    ///     print("Loaded \(moreReactions.count) more reactions")
    /// } catch {
    ///     print("Failed to load more reactions: \(error)")
    /// }
    /// ```
    @discardableResult public func queryMoreReactions(limit: Int? = nil) async throws -> [FeedsReactionData] {
        let nextQuery: CommentReactionsQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            var nextQuery = query
            nextQuery.limit = limit
            nextQuery.previous = nil
            nextQuery.next = next
            return nextQuery
        }
        guard let nextQuery else { return [] }
        return try await queryCommentReactions(with: nextQuery)
    }
    
    // MARK: - Private
    
    private func queryCommentReactions(with query: CommentReactionsQuery) async throws -> [FeedsReactionData] {
        let result = try await commentsRepository.queryCommentReactions(request: query.toRequest(), commentId: query.commentId)
        await state.didPaginate(
            with: result,
            for: .init(filter: query.filter, sort: query.sort)
        )
        return result.models
    }
}
