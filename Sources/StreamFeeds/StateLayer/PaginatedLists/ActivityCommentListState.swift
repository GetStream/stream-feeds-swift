//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation

/// An observable object representing the current state of an activity's comment list.
///
/// This class manages the state of comments for a specific activity, including
/// the list of comments, pagination information, and real-time updates from
/// WebSocket events. It automatically handles comment additions, updates,
/// deletions, and reaction changes.
///
/// ## Usage
///
/// ```swift
/// // Access the state from an ActivityCommentList
/// let commentList = client.activityCommentList(for: query)
/// let state = commentList.state
///
/// // Observe comment changes
/// state.$comments
///     .sink { comments in
///         // Update UI with new comments
///     }
///     .store(in: &cancellables)
///
/// // Check pagination status
/// if state.canLoadMore {
///     // Load more comments
/// }
///
/// // Access current comments
/// let currentComments = state.comments
/// ```
///
/// ## Features
///
/// - **Observable State**: Uses `@Published` properties for reactive UI updates
/// - **Real-time Updates**: Automatically receives WebSocket events for comment changes
/// - **Pagination Support**: Tracks pagination state for loading more comments
/// - **Thread Safety**: All updates are performed on the main actor
/// - **Change Handlers**: Internal handlers for processing WebSocket events
///
/// ## Thread Safety
///
/// This class is designed to run on the main actor and all state updates
/// are performed on the main thread to ensure UI consistency.
@MainActor public class ActivityCommentListState: ObservableObject {
    private var webSocketObserver: WebSocketObserver?
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    
    /// Initializes a new ActivityCommentListState instance.
    ///
    /// - Parameters:
    ///   - query: The query configuration for fetching comments
    ///   - events: The WebSocket events subscriber for real-time updates
    init(query: ActivityCommentsQuery, events: WSEventsSubscribing) {
        self.query = query
        webSocketObserver = WebSocketObserver(objectId: query.objectId, objectType: query.objectType, subscribing: events, handlers: changeHandlers)
    }
    
    /// The query configuration used to fetch comments.
    public let query: ActivityCommentsQuery
    
    /// All the paginated comments for the activity.
    ///
    /// This property contains the current list of comments, including any
    /// threaded replies based on the query configuration. The list is
    /// automatically updated when new comments are added, existing comments
    /// are updated or deleted, or when reactions are added or removed.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Access current comments
    /// let comments = state.comments
    ///
    /// // Use in SwiftUI
    /// ForEach(state.comments) { comment in
    ///     CommentView(comment: comment)
    /// }
    /// ```
    @Published public internal(set) var comments: [CommentData] = []
    
    // MARK: - Pagination State
    
    /// Last pagination information from the most recent API response.
    ///
    /// This property contains the pagination cursors and metadata from the
    /// last successful API request. It's used to determine if more comments
    /// can be loaded and to construct subsequent pagination requests.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Check if more comments are available
    /// if let pagination = state.pagination {
    ///     print("Next cursor: \(pagination.next ?? "none")")
    ///     print("Previous cursor: \(pagination.previous ?? "none")")
    /// }
    /// ```
    public private(set) var pagination: PaginationData?
    
    /// Indicates whether there are more comments available to load.
    ///
    /// This computed property checks if a "next" cursor exists in the
    /// pagination data, indicating that more comments can be fetched.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Check if more comments can be loaded
    /// if state.canLoadMore {
    ///     // Show "Load More" button
    ///     Button("Load More") {
    ///         // Load more comments
    ///     }
    /// }
    /// ```
    public var canLoadMore: Bool { pagination?.next != nil }
}

// MARK: - Updating the State

extension ActivityCommentListState {
    struct ChangeHandlers {
        let commentAdded: @MainActor (CommentData) -> Void
        let commentRemoved: @MainActor (String) -> Void
        let commentUpdated: @MainActor (CommentData) -> Void
        let commentReactionAdded: @MainActor (FeedsReactionData, CommentData) -> Void
        let commentReactionRemoved: @MainActor (FeedsReactionData, CommentData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            commentAdded: { [weak self] comment in
                self?.comments.insert(byId: comment, parentId: \.parentId, nesting: \.replies)
            },
            commentRemoved: { [weak self] commentId in
                self?.comments.remove(byId: commentId, nesting: \.replies)
            },
            commentUpdated: { [weak self] comment in
                self?.comments.replace(byId: comment, nesting: \.replies)
            },
            commentReactionAdded: { [weak self] reaction, comment in
                self?.comments.update(byId: comment.id, nesting: \.replies) { existingComment in
                    existingComment.addReaction(reaction)
                }
            },
            commentReactionRemoved: { [weak self] reaction, comment in
                self?.comments.update(byId: comment.id, nesting: \.replies) { existingComment in
                    existingComment.removeReaction(reaction)
                }
            }
        )
    }
    
    func access<T>(_ actions: @MainActor (ActivityCommentListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(with response: PaginationResult<CommentData>) {
        pagination = response.pagination
        // Can't locally sort for all the sorting keys
        comments.appendReplacingDuplicates(byId: response.models)
    }
}
