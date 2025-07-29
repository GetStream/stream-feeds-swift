//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation

@MainActor public class CommentListState: ObservableObject {
    private var webSocketObserver: WebSocketObserver?
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    
    init(query: CommentsQuery, events: WSEventsSubscribing) {
        self.query = query
        webSocketObserver = WebSocketObserver(subscribing: events, handlers: changeHandlers)
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
    struct ChangeHandlers {
        let commentRemoved: @MainActor (String) -> Void
        let commentUpdated: @MainActor (CommentData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            commentRemoved: { [weak self] commentId in
                self?.comments.remove(byId: commentId)
            },
            commentUpdated: { [weak self] comment in
                guard let self else { return }
                // Only update, do not insert
                comments.sortedReplace(
                    comment,
                    nesting: nil,
                    sorting: CommentsSort.areInIncreasingOrder(sortingKey)
                )
            }
        )
    }
    
    func access<T>(_ actions: @MainActor (CommentListState) -> T) -> T {
        actions(self)
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
