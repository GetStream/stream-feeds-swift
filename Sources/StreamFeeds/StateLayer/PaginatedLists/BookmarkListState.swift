//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public class BookmarkListState: ObservableObject {
    private var webSocketObserver: WebSocketObserver?
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    
    init(query: BookmarksQuery, events: WSEventsSubscribing) {
        self.query = query
        webSocketObserver = WebSocketObserver(subscribing: events, handlers: changeHandlers)
    }
    
    public let query: BookmarksQuery
    
    /// All the paginated bookmarks.
    @Published public private(set) var bookmarks: [BookmarkData] = []
    
    // MARK: - Pagination State
    
    /// Last pagination information.
    public private(set) var pagination: PaginationData?
    
    /// Indicates whether there are more bookmarks available to load.
    public var canLoadMore: Bool { pagination?.next != nil }
    
    /// The configuration used for the last query.
    private(set) var queryConfig: QueryConfiguration<BookmarksFilter, BookmarksSortField>?
    
    var bookmarkFoldersSorting: [Sort<BookmarksSortField>] {
        if let sort = queryConfig?.sort, !sort.isEmpty {
            return sort
        }
        return Sort<BookmarksSortField>.defaultSorting
    }
}

// MARK: - Updating the State

extension BookmarkListState {
    /// Handlers for various state change events.
    ///
    /// These handlers are called when WebSocket events are received and automatically update the state accordingly.
    struct ChangeHandlers {
        let bookmarkUpdated: @MainActor (BookmarkData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            bookmarkUpdated: { [weak self] feed in
                // Only update, do not insert
                self?.bookmarks.replace(byId: feed)
            }
        )
    }
    
    func access<T>(_ actions: @MainActor (BookmarkListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(
        with response: PaginationResult<BookmarkData>,
        for queryConfig: QueryConfiguration<BookmarksFilter, BookmarksSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        bookmarks = bookmarks.sortedMerge(response.models, using: bookmarkFoldersSorting)
    }
}

