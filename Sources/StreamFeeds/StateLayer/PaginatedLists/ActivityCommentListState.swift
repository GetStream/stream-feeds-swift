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
@MainActor public final class ActivityCommentListState: ObservableObject, StateAccessing {
    private let currentUserId: String
    private var eventSubscription: StateLayerEventPublisher.Subscription?
    
    init(query: ActivityCommentsQuery, currentUserId: String, eventPublisher: StateLayerEventPublisher) {
        self.currentUserId = currentUserId
        self.query = query
        subscribe(to: eventPublisher)
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
    @Published public private(set) var comments: [ThreadedCommentData] = []
    
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
    private func subscribe(to publisher: StateLayerEventPublisher) {
        eventSubscription = publisher.subscribe { [weak self, currentUserId, query] event in
            switch event {
            case .activityDeleted(let activityId, _):
                guard query.objectId == activityId else { return }
                await self?.access { state in
                    state.comments.removeAll()
                }
            case .commentAdded(let commentData, _, _):
                guard query.objectId == commentData.objectId, query.objectType == commentData.objectType else { return }
                await self?.access { state in
                    if let parentId = commentData.parentId {
                        state.comments.sortedUpdate(
                            ofId: parentId,
                            nesting: \.replies,
                            sorting: CommentsSort.areInIncreasingOrder(state.sortingKey),
                            changes: { existing in
                                existing.addReply(ThreadedCommentData(from: commentData), sort: CommentsSort.areInIncreasingOrder(state.sortingKey))
                            }
                        )
                    } else {
                        state.comments.sortedInsert(ThreadedCommentData(from: commentData), sorting: CommentsSort.areInIncreasingOrder(state.sortingKey))
                    }
                }
            case .commentsAddedBatch(let commentDatas, _, _):
                let filteredComments = commentDatas.filter { query.objectId == $0.objectId && query.objectType == $0.objectType }
                guard !filteredComments.isEmpty else { return }
                let divided = filteredComments.divideIntoParentsAndReplies()
                let parents = divided.parents.map { ThreadedCommentData(from: $0) }
                let replies = divided.replies.map { ThreadedCommentData(from: $0) }
                await self?.access { state in
                    let sorting = CommentsSort.areInIncreasingOrder(state.sortingKey)
                    if !parents.isEmpty {
                        state.comments = state.comments.sortedMerge(parents.sorted(by: sorting), sorting: sorting)
                    }
                    if !replies.isEmpty {
                        for reply in replies {
                            guard let parentId = reply.parentId else { continue }
                            state.comments.sortedUpdate(
                                ofId: parentId,
                                nesting: \.replies,
                                sorting: sorting,
                                changes: { existing in
                                    existing.addReply(reply, sort: sorting)
                                }
                            )
                        }
                    }
                }
            case .commentDeleted(let commentData, _, _):
                guard query.objectId == commentData.objectId, query.objectType == commentData.objectType else { return }
                await self?.access { $0.comments.remove(byId: commentData.id, nesting: \.replies) }
            case .commentUpdated(let commentData, _, _):
                guard query.objectId == commentData.objectId, query.objectType == commentData.objectType else { return }
                await self?.access { state in
                    state.comments.sortedUpdate(
                        ofId: commentData.id,
                        nesting: \.replies,
                        sorting: CommentsSort.areInIncreasingOrder(state.sortingKey),
                        changes: { $0.merge(with: commentData) }
                    )
                }
            case .commentReactionAdded(let feedsReactionData, let commentData, _):
                guard query.objectId == commentData.objectId, query.objectType == commentData.objectType else { return }
                await self?.access { state in
                    state.comments.sortedUpdate(
                        ofId: commentData.id,
                        nesting: \.replies,
                        sorting: CommentsSort.areInIncreasingOrder(state.sortingKey),
                        changes: { $0.merge(with: commentData, add: feedsReactionData, currentUserId: currentUserId) }
                    )
                }
            case .commentReactionDeleted(let feedsReactionData, let commentData, _):
                guard query.objectId == commentData.objectId, query.objectType == commentData.objectType else { return }
                await self?.access { state in
                    state.comments.sortedUpdate(
                        ofId: commentData.id,
                        nesting: \.replies,
                        sorting: CommentsSort.areInIncreasingOrder(state.sortingKey),
                        changes: { $0.merge(with: commentData, remove: feedsReactionData, currentUserId: currentUserId) }
                    )
                }
            case .commentReactionUpdated(let feedsReactionData, let commentData, _):
                guard query.objectId == commentData.objectId, query.objectType == commentData.objectType else { return }
                await self?.access { state in
                    state.comments.sortedUpdate(
                        ofId: commentData.id,
                        nesting: \.replies,
                        sorting: CommentsSort.areInIncreasingOrder(state.sortingKey),
                        changes: { $0.merge(with: commentData, update: feedsReactionData, currentUserId: currentUserId) }
                    )
                }
            case .userUpdated(let userData):
                await self?.access { state in
                    state.comments.updateAll(
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
        comments = comments.sortedMerge(response.models, sorting: CommentsSort.areInIncreasingOrder(sortingKey))
    }
}
