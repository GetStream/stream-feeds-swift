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
    private(set) var queryConfig: (filter: [CommentsFilterField: [String]], sort: CommentsSort?)?
}

// MARK: - Updating the State

extension CommentListState {
    struct ChangeHandlers {
        let commentUpdated: @MainActor (CommentData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            commentUpdated: { [weak self] comment in
                // Only update, do not insert
                self?.comments.replace(byId: comment)
            }
        )
    }
    
    func access<T>(_ actions: @MainActor (CommentListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(
        with response: PaginationResult<CommentData>,
        filter: [CommentsFilterField: [String]],
        sort: CommentsSort?
    ) {
        pagination = response.pagination
        queryConfig = (filter, sort)
        // Can't locally sort for all the sorting keys
        comments.appendReplacingDuplicates(byId: response.models)
    }
}
