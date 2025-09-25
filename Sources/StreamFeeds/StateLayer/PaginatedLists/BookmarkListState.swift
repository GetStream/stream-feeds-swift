//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public class BookmarkListState: ObservableObject {
    private var eventSubscription: StateLayerEventPublisher.Subscription?

    init(query: BookmarksQuery, eventPublisher: StateLayerEventPublisher) {
        self.query = query
        subscribe(to: eventPublisher)
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
    private func subscribe(to publisher: StateLayerEventPublisher) {
        eventSubscription = publisher.subscribe { [weak self] event in
            switch event {
            case .bookmarkFolderDeleted(let folder):
                await self?.access { state in
                    state.updateBookmarkFolder(with: folder.id, changes: { $0.folder = nil })
                }
            case .bookmarkFolderUpdated(let folder):
                await self?.access { state in
                    state.updateBookmarkFolder(with: folder.id, changes: { $0.folder = folder })
                }
            case .bookmarkUpdated(let bookmark):
                await self?.access { state in
                    // Only update, do not insert
                    state.bookmarks.replace(byId: bookmark)
                }
            default:
                break
            }
        }
    }

    private func updateBookmarkFolder(with id: String, changes: (inout BookmarkData) -> Void) {
        guard let index = bookmarks.firstIndex(where: { $0.folder?.id == id }) else { return }
        var bookmark = bookmarks[index]
        changes(&bookmark)
        bookmarks[index] = bookmark
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
        bookmarks = bookmarks.sortedMerge(response.models, sorting: bookmarkFoldersSorting)
    }
}
