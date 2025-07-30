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
    private let currentUserId: String
    
    init(query: CommentRepliesQuery, currentUserId: String, events: WSEventsSubscribing) {
        self.currentUserId = currentUserId
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
    @Published public private(set) var replies: [ThreadedCommentData] = []
    
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
    
    var sortingKey: CommentsSort {
        query.sort ?? .last
    }
}

// MARK: - Updating the State

extension CommentReplyListState {
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
                    replies.sortedUpdate(
                        ofId: parentId,
                        nesting: \.replies,
                        sorting: CommentsSort.areInIncreasingOrder(sortingKey),
                        changes: { $0.addReply(comment, sort: CommentsSort.areInIncreasingOrder(sortingKey)) }
                    )
                } else {
                    replies.sortedInsert(comment, sorting: CommentsSort.areInIncreasingOrder(sortingKey))
                }
            },
            commentRemoved: { [weak self] commentId in
                self?.replies.remove(byId: commentId, nesting: \.replies)
            },
            commentUpdated: { [weak self] comment in
                guard let self else { return }
                replies.sortedUpdate(
                    ofId: comment.id,
                    nesting: \.replies,
                    sorting: CommentsSort.areInIncreasingOrder(sortingKey),
                    changes: { $0.setCommentData(comment) }
                )
            },
            commentReactionAdded: { [weak self] reaction, commentId in
                guard let self else { return }
                replies.sortedUpdate(
                    ofId: commentId,
                    nesting: \.replies,
                    sorting: CommentsSort.areInIncreasingOrder(sortingKey),
                    changes: { $0.addReaction(reaction, currentUserId: currentUserId) }
                )
            },
            commentReactionRemoved: { [weak self] reaction, commentId in
                guard let self else { return }
                replies.sortedUpdate(
                    ofId: commentId,
                    nesting: \.replies,
                    sorting: CommentsSort.areInIncreasingOrder(sortingKey),
                    changes: { $0.removeReaction(reaction, currentUserId: currentUserId) }
                )
            }
        )
    }
    
    func access<T>(_ actions: @MainActor (CommentReplyListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(with response: PaginationResult<ThreadedCommentData>) {
        pagination = response.pagination
        replies = replies.sortedMerge(response.models, sorting: CommentsSort.areInIncreasingOrder(query.sort ?? .last))
    }
}
