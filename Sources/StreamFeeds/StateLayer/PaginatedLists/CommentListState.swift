//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation

@MainActor public final class CommentListState: ObservableObject, StateAccessing {
    private let currentUserId: String
    private var eventSubscription: StateLayerEventPublisher.Subscription?
    
    init(query: CommentsQuery, currentUserId: String, eventPublisher: StateLayerEventPublisher) {
        self.currentUserId = currentUserId
        self.query = query
        subscribe(to: eventPublisher)
    }
    
    public let query: CommentsQuery
    
    /// All the paginated comments.
    @Published public private(set) var comments: [CommentData] = []
    
    // MARK: - Pagination State
    
    /// Last pagination information.
    public private(set) var pagination: PaginationData?
    
    /// Indicates whether there are more comments available to load.
    public var canLoadMore: Bool { pagination?.next != nil }
    
    /// The configuration used for the last query.
    private(set) var queryConfig: (filter: CommentsFilter?, sort: CommentsSort?)?
    
    private var sortingKey: CommentsSort {
        queryConfig?.sort ?? .last
    }
}

// MARK: - Updating the State

extension CommentListState {
    private func subscribe(to publisher: StateLayerEventPublisher) {
        let matchesQuery: @Sendable (CommentData) -> Bool = { [query] data in
            guard let filter = query.filter else { return true }
            return filter.matches(data)
        }
        eventSubscription = publisher.subscribe { [weak self, currentUserId] event in
            switch event {
            case .commentAdded(let commentData, _, _):
                guard matchesQuery(commentData) else { return }
                await self?.access { state in
                    state.comments.sortedInsert(commentData, sorting: CommentsSort.areInIncreasingOrder(state.sortingKey))
                }
            case .commentsAddedBatch(let commentDatas, _, _):
                let filteredComments = commentDatas.filter { matchesQuery($0) }
                guard !filteredComments.isEmpty else { return }
                await self?.access { state in
                    let sorting = CommentsSort.areInIncreasingOrder(state.sortingKey)
                    state.comments = state.comments.sortedMerge(filteredComments.sorted(by: sorting), sorting: sorting)
                }
            case .commentDeleted(let commentData, _, _):
                guard matchesQuery(commentData) else { return }
                await self?.access { $0.comments.remove(byId: commentData.id) }
            case .commentUpdated(let commentData, _, _):
                let matches = matchesQuery(commentData)
                await self?.access { state in
                    if matches {
                        state.comments.sortedReplace(
                            commentData,
                            nesting: nil,
                            sorting: CommentsSort.areInIncreasingOrder(state.sortingKey)
                        )
                    } else {
                        state.comments.remove(byId: commentData.id)
                    }
                }
            case .commentReactionAdded(let feedsReactionData, let commentData, _):
                guard matchesQuery(commentData) else { return }
                await self?.access { state in
                    state.comments.sortedUpdate(
                        ofId: commentData.id,
                        nesting: nil,
                        sorting: CommentsSort.areInIncreasingOrder(state.sortingKey),
                        changes: { $0.merge(with: commentData, add: feedsReactionData, currentUserId: currentUserId) }
                    )
                }
            case .commentReactionDeleted(let feedsReactionData, let commentData, _):
                guard matchesQuery(commentData) else { return }
                await self?.access { state in
                    state.comments.sortedUpdate(
                        ofId: commentData.id,
                        nesting: nil,
                        sorting: CommentsSort.areInIncreasingOrder(state.sortingKey),
                        changes: { $0.merge(with: commentData, remove: feedsReactionData, currentUserId: currentUserId) }
                    )
                }
            case .commentReactionUpdated(let feedsReactionData, let commentData, _):
                guard matchesQuery(commentData) else { return }
                await self?.access { state in
                    state.comments.sortedUpdate(
                        ofId: commentData.id,
                        nesting: nil,
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
    
    func didPaginate(
        with response: PaginationResult<CommentData>,
        filter: CommentsFilter?,
        sort: CommentsSort?
    ) {
        pagination = response.pagination
        queryConfig = (filter, sort)
        comments = comments.sortedMerge(response.models, sorting: CommentsSort.areInIncreasingOrder(sortingKey))
    }
}
