//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public class BookmarkFolderListState: ObservableObject {
    private var webSocketObserver: WebSocketObserver?
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    
    init(query: BookmarkFoldersQuery, events: WSEventsSubscribing) {
        self.query = query
        webSocketObserver = WebSocketObserver(subscribing: events, handlers: changeHandlers)
    }
    
    public let query: BookmarkFoldersQuery
    
    /// All the paginated folders.
    @Published public private(set) var folders: [BookmarkFolderData] = []
    
    // MARK: - Pagination State
    
    /// Last pagination information.
    public private(set) var pagination: PaginationData?
    
    /// Indicates whether there are more bookmark folders available to load.
    public var canLoadMore: Bool { pagination?.next != nil }
    
    /// The configuration used for the last query.
    private(set) var queryConfig: QueryConfiguration<BookmarkFoldersFilter, BookmarkFoldersSortField>?
    
    var bookmarksSorting: [Sort<BookmarkFoldersSortField>] {
        if let sort = queryConfig?.sort, !sort.isEmpty {
            return sort
        }
        return Sort<BookmarkFoldersSortField>.defaultSorting
    }
}

// MARK: - Updating the State

extension BookmarkFolderListState {
    struct ChangeHandlers {
        let bookmarkFolderRemoved: @MainActor (String) -> Void
        let bookmarkFolderUpdated: @MainActor (BookmarkFolderData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            bookmarkFolderRemoved: { [weak self] id in
                self?.folders.remove(byId: id)
            },
            bookmarkFolderUpdated: { [weak self] folder in
                self?.folders.replace(byId: folder)
            }
        )
    }
    
    func access<T>(_ actions: @MainActor (BookmarkFolderListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(
        with response: PaginationResult<BookmarkFolderData>,
        for queryConfig: QueryConfiguration<BookmarkFoldersFilter, BookmarkFoldersSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        folders = folders.sortedMerge(response.models, sorting: bookmarksSorting)
    }
}
