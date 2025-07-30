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
    private let currentUserId: String
    
    init(query: ActivityCommentsQuery, currentUserId: String, events: WSEventsSubscribing) {
        self.currentUserId = currentUserId
        self.query = query
        webSocketObserver = WebSocketObserver(
            objectId: query.objectId,
            objectType: query.objectType,
            subscribing: events,
            handlers: changeHandlers
        )
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
    @Published public internal(set) var comments: [ThreadedCommentData] = []
    
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
    
    var sortingKey: CommentsSort {
        query.sort ?? .last
    }
}

// MARK: - Updating the State

extension ActivityCommentListState {
    struct ChangeHandlers {
        let commentAdded: @MainActor (ThreadedCommentData) -> Void
        let commentRemoved: @MainActor (String) -> Void
        let commentUpdated: @MainActor (CommentData) -> Void
        let commentReactionAdded: @MainActor (FeedsReactionData, String) -> Void
        let commentReactionRemoved: @MainActor (FeedsReactionData, String) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            commentAdded: { [weak self] comment in
                guard let self else { return }
                if let parentId = comment.parentId {
                    comments.sortedUpdate(
                        ofId: parentId,
                        nesting: \.replies,
                        sorting: CommentsSort.areInIncreasingOrder(sortingKey),
                        changes: { existing in
                            existing.addReply(comment, sort: CommentsSort.areInIncreasingOrder(sortingKey))
                        }
                    )
                } else {
                    comments.sortedInsert(comment, sorting: CommentsSort.areInIncreasingOrder(sortingKey))
                }
            },
            commentRemoved: { [weak self] commentId in
                self?.comments.remove(byId: commentId, nesting: \.replies)
            },
            commentUpdated: { [weak self] comment in
                guard let self else { return }
                comments.sortedUpdate(
                    ofId: comment.id,
                    nesting: \.replies,
                    sorting: CommentsSort.areInIncreasingOrder(sortingKey),
                    changes: { $0.setCommentData(comment) }
                )
            },
            commentReactionAdded: { [weak self] reaction, commentId in
                guard let self else { return }
                comments.sortedUpdate(
                    ofId: commentId,
                    nesting: \.replies,
                    sorting: CommentsSort.areInIncreasingOrder(sortingKey),
                    changes: { $0.addReaction(reaction, currentUserId: currentUserId) }
                )
            },
            commentReactionRemoved: { [weak self] reaction, commentId in
                guard let self else { return }
                comments.sortedUpdate(
                    ofId: commentId,
                    nesting: \.replies,
                    sorting: CommentsSort.areInIncreasingOrder(sortingKey),
                    changes: { $0.removeReaction(reaction, currentUserId: currentUserId) }
                )
            }
        )
    }
    
    func access<T>(_ actions: @MainActor (ActivityCommentListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(with response: PaginationResult<ThreadedCommentData>) {
        pagination = response.pagination
        comments = comments.sortedMerge(response.models, sorting: CommentsSort.areInIncreasingOrder(sortingKey))
    }
}
