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
@MainActor public final class CommentReplyListState: ObservableObject, StateAccessing {
    private var eventSubscription: StateLayerEventPublisher.Subscription?
    private let currentUserId: String
    
    init(query: CommentRepliesQuery, currentUserId: String, eventPublisher: StateLayerEventPublisher) {
        self.currentUserId = currentUserId
        self.query = query
        subscribe(to: eventPublisher)
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
    private func subscribe(to publisher: StateLayerEventPublisher) {
        eventSubscription = publisher.subscribe { [weak self, currentUserId, query] event in
            switch event {
            case .commentAdded(let commentData, _, _):
                guard let parentId = commentData.parentId else { return }
                let threaded = ThreadedCommentData(from: commentData)
                await self?.access { state in
                    if parentId == query.commentId {
                        state.replies.sortedInsert(threaded, sorting: CommentsSort.areInIncreasingOrder(state.sortingKey))
                    } else {
                        state.replies.sortedUpdate(
                            ofId: parentId,
                            nesting: \.replies,
                            sorting: CommentsSort.areInIncreasingOrder(state.sortingKey),
                            changes: { existing in
                                existing.addReply(threaded, sort: CommentsSort.areInIncreasingOrder(state.sortingKey))
                            }
                        )
                    }
                }
            case .commentsAddedBatch(let commentDatas, _, _):
                let filteredComments = commentDatas
                    .filter { $0.parentId != nil }
                    .map { ThreadedCommentData(from: $0) }
                guard !filteredComments.isEmpty else { return }
                await self?.access { state in
                    let sorting = CommentsSort.areInIncreasingOrder(state.sortingKey)
                    for reply in filteredComments {
                        guard let parentId = reply.parentId else { continue }
                        state.replies.sortedUpdate(
                            ofId: parentId,
                            nesting: \.replies,
                            sorting: sorting,
                            changes: { existing in
                                existing.addReply(reply, sort: sorting)
                            }
                        )
                    }
                }
            case .commentDeleted(let commentData, _, _):
                await self?.access { state in
                    state.replies.remove(byId: commentData.id, nesting: \.replies)
                }
            case .commentUpdated(let commentData, _, _):
                await self?.access { state in
                    state.replies.sortedUpdate(
                        ofId: commentData.id,
                        nesting: \.replies,
                        sorting: CommentsSort.areInIncreasingOrder(state.sortingKey),
                        changes: { $0.merge(with: commentData) }
                    )
                }
            case .commentReactionAdded(let feedsReactionData, let commentData, _):
                await self?.access { state in
                    state.replies.sortedUpdate(
                        ofId: commentData.id,
                        nesting: \.replies,
                        sorting: CommentsSort.areInIncreasingOrder(state.sortingKey),
                        changes: { $0.merge(with: commentData, add: feedsReactionData, currentUserId: currentUserId) }
                    )
                }
            case .commentReactionDeleted(let feedsReactionData, let commentData, _):
                await self?.access { state in
                    state.replies.sortedUpdate(
                        ofId: commentData.id,
                        nesting: \.replies,
                        sorting: CommentsSort.areInIncreasingOrder(state.sortingKey),
                        changes: { $0.merge(with: commentData, remove: feedsReactionData, currentUserId: currentUserId) }
                    )
                }
            case .commentReactionUpdated(let feedsReactionData, let commentData, _):
                await self?.access { state in
                    state.replies.sortedUpdate(
                        ofId: commentData.id,
                        nesting: \.replies,
                        sorting: CommentsSort.areInIncreasingOrder(state.sortingKey),
                        changes: { $0.merge(with: commentData, update: feedsReactionData, currentUserId: currentUserId) }
                    )
                }
            case .userUpdated(let userData):
                await self?.access { state in
                    state.replies.updateAll(
                        where: { $0.user.id == userData.id },
                        changes: { $0.updateUser(userData) }
                    )
                }
            default:
                break
            }
        }
    }
    
    func didPaginate(with response: PaginationResult<ThreadedCommentData>) {
        pagination = response.pagination
        replies = replies.sortedMerge(response.models, sorting: CommentsSort.areInIncreasingOrder(query.sort ?? .last))
    }
}
