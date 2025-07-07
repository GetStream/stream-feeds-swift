//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation

/// An observable object representing the current state of a comment's reply list.
///
/// This class manages the state of replies for a specific comment, including
/// the list of replies, pagination information, and real-time updates from
/// WebSocket events. It automatically handles reply updates and reaction changes.
///
/// ## Usage
///
/// ```swift
/// // Access the state from a CommentReplyList
/// let replyList = client.commentReplyList(for: query)
/// let state = replyList.state
///
/// // Observe reply changes
/// state.$replies
///     .sink { replies in
///         // Update UI with new replies
///     }
///     .store(in: &cancellables)
///
/// // Check pagination status
/// if state.canLoadMore {
///     // Load more replies
/// }
///
/// // Access current replies
/// let currentReplies = state.replies
/// ```
///
/// ## Features
///
/// - **Observable State**: Uses `@Published` properties for reactive UI updates
/// - **Real-time Updates**: Automatically receives WebSocket events for reply changes
/// - **Pagination Support**: Tracks pagination state for loading more replies
/// - **Thread Safety**: All updates are performed on the main actor
/// - **Change Handlers**: Internal handlers for processing WebSocket events
///
/// ## Thread Safety
///
/// This class is designed to run on the main actor and all state updates
/// are performed on the main thread to ensure UI consistency.
@MainActor public class CommentReplyListState: ObservableObject {
    private var webSocketObserver: WebSocketObserver?
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    
    init(query: CommentRepliesQuery, events: WSEventsSubscribing) {
        self.query = query
        webSocketObserver = WebSocketObserver(parentId: query.commentId, subscribing: events, handlers: changeHandlers)
    }
    
    /// The query configuration used to fetch replies.
    public let query: CommentRepliesQuery
    
    /// All the paginated replies for the comment.
    ///
    /// This property contains the current list of replies to the comment,
    /// including any nested reply structures based on the query configuration.
    /// The list is automatically updated when replies are added, updated,
    /// or deleted through WebSocket events.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Access current replies
    /// let replies = state.replies
    ///
    /// // Use in SwiftUI
    /// ForEach(state.replies) { reply in
    ///     ReplyView(reply: reply)
    /// }
    /// ```
    @Published public private(set) var replies: [CommentData] = []
    
    // MARK: - Pagination State
    
    /// Last pagination information from the most recent API response.
    ///
    /// This property contains the pagination cursors and metadata from the
    /// last successful API request. It's used to determine if more replies
    /// can be loaded and to construct subsequent pagination requests.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Check if more replies are available
    /// if let pagination = state.pagination {
    ///     print("Next cursor: \(pagination.next ?? "none")")
    ///     print("Previous cursor: \(pagination.previous ?? "none")")
    /// }
    /// ```
    public private(set) var pagination: PaginationData?
    
    /// Indicates whether there are more replies available to load.
    ///
    /// This computed property checks if a "next" cursor exists in the
    /// pagination data, indicating that more replies can be fetched.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Check if more replies can be loaded
    /// if state.canLoadMore {
    ///     // Show "Load More" button
    ///     Button("Load More") {
    ///         // Load more replies
    ///     }
    /// }
    /// ```
    public var canLoadMore: Bool { pagination?.next != nil }
}

// MARK: - Updating the State

extension CommentReplyListState {
    struct ChangeHandlers {
        let commentUpdated: @MainActor (CommentData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            commentUpdated: { [weak self] comment in
                // Only update, do not insert
                self?.replies.replace(byId: comment)
            }
        )
    }
    
    func access<T>(_ actions: @MainActor (CommentReplyListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(with response: PaginationResult<CommentData>) {
        pagination = response.pagination
        // Can't locally sort for all the sorting keys
        replies.appendReplacingDuplicates(byId: response.models)
    }
} 
