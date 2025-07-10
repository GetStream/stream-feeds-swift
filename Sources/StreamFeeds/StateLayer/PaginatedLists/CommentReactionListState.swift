//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

/// An observable state object that manages the current state of a comment reaction list.
///
/// This class provides reactive state management for a collection of comment reactions.
/// It automatically handles real-time updates when reactions are added or removed from the comment,
/// and maintains pagination state for loading additional reactions.
///
/// ## Observable Properties
///
/// The state object publishes changes to its properties, allowing you to observe updates:
///
/// ```swift
/// commentReactionList.state.$reactions
///     .sink { reactions in
///         // Update UI when reactions change
///     }
///     .store(in: &cancellables)
/// ```
///
/// ## Real-time Updates
///
/// The state automatically updates when WebSocket events are received.
///
/// ## Thread Safety
///
/// This class is marked with `@MainActor` and should only be accessed from the main thread.
@MainActor public class CommentReactionListState: ObservableObject {
    private var webSocketObserver: WebSocketObserver?
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    
    init(query: CommentReactionsQuery, events: WSEventsSubscribing) {
        self.query = query
        webSocketObserver = WebSocketObserver(commentId: query.commentId, subscribing: events, handlers: changeHandlers)
    }
    
    /// The query configuration used to fetch comment reactions.
    ///
    /// This contains the comment ID, filters, sorting options, and pagination parameters
    /// that define how reactions should be fetched and displayed.
    public let query: CommentReactionsQuery
    
    /// The current collection of comment reactions.
    ///
    /// This array contains all the reactions that have been loaded for the comment.
    /// The reactions are automatically sorted according to the query configuration.
    /// Changes to this array are published and can be observed for UI updates.
    ///
    /// ```swift
    /// commentReactionList.state.$reactions
    ///     .sink { reactions in
    ///         // Update your UI with the new reactions
    ///         updateReactionUI(with: reactions)
    ///     }
    ///     .store(in: &cancellables)
    /// ```
    @Published public private(set) var reactions: [FeedsReactionData] = []
    
    // MARK: - Pagination State
    
    /// The pagination information from the last query.
    ///
    /// This contains the pagination cursors (`next` and `previous`) that can be used
    /// to fetch additional pages of reactions. The pagination data is automatically
    /// updated when new pages are loaded.
    public private(set) var pagination: PaginationData?
    
    /// Indicates whether there are more reactions available to load.
    ///
    /// This property returns `true` if there are additional pages of reactions available
    /// to fetch. You can use this to determine whether to show a "Load More" button
    /// or implement infinite scrolling.
    ///
    /// ```swift
    /// if commentReactionList.state.canLoadMore {
    ///     // Show load more button or trigger automatic loading
    ///     loadMoreButton.isEnabled = true
    /// }
    /// ```
    public var canLoadMore: Bool { pagination?.next != nil }
    
    /// The configuration used for the last comment reactions query.
    ///
    /// This contains the filter and sort configuration that was used for the most recent
    /// query. It's used internally to maintain consistent sorting when new pages are loaded.
    private(set) var queryConfig: QueryConfiguration<CommentReactionsFilter, CommentReactionsSortField>?
    
    /// The sorting criteria used for organizing reactions.
    ///
    /// This computed property returns the sorting configuration that should be used
    /// for organizing the reactions. If no custom sorting was specified in the query,
    /// it defaults to sorting by creation date in descending order (newest first).
    var reactionsSorting: [Sort<CommentReactionsSortField>] {
        if let sort = queryConfig?.sort, !sort.isEmpty {
            return sort
        }
        return Sort<CommentReactionsSortField>.defaultSorting
    }
}

// MARK: - Updating the State

extension CommentReactionListState {
    struct ChangeHandlers {
        let reactionRemoved: @MainActor (FeedsReactionData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            reactionRemoved: { [weak self] reaction in
                self?.reactions.remove(byId: reaction.id)
            }
        )
    }
    
    func access<T>(_ actions: @MainActor (CommentReactionListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(
        with response: PaginationResult<FeedsReactionData>,
        for queryConfig: QueryConfiguration<CommentReactionsFilter, CommentReactionsSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        reactions = reactions.sortedMerge(response.models, using: reactionsSorting)
    }
} 
