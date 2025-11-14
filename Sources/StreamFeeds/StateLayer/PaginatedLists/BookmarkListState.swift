//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public final class BookmarkListState: ObservableObject, StateAccessing {
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
        let matchesQuery: @Sendable (BookmarkData) -> Bool = { [query] bookmark in
            guard let filter = query.filter else { return true }
            return filter.matches(bookmark)
        }
        eventSubscription = publisher.subscribe { [weak self] event in
            switch event {
            case .bookmarkFolderDeleted(let folder):
                await self?.access { state in
                    state.bookmarks.updateAll(
                        where: { $0.folder?.id == folder.id },
                        changes: { $0.folder = nil }
                    )
                }
            case .bookmarkFolderUpdated(let folder):
                await self?.access { state in
                    state.bookmarks.updateAll(
                        where: { $0.folder?.id == folder.id },
                        changes: { $0.folder = folder }
                    )
                }
            case .bookmarkUpdated(let bookmark):
                let matches = matchesQuery(bookmark)
                await self?.access { state in
                    if matches {
                        state.bookmarks.sortedReplace(bookmark, nesting: nil, sorting: state.bookmarkFoldersSorting)
                    } else {
                        state.bookmarks.remove(byId: bookmark.id)
                    }
                }
            case .feedOwnCapabilitiesUpdated(let capabilitiesMap):
                await self?.access { state in
                    state.bookmarks.updateAll(
                        where: { capabilitiesMap.contains($0.activity.currentFeed?.feed) },
                        changes: { $0.mergeFeedOwnCapabilities(from: capabilitiesMap) }
                    )
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

    func didPaginate(
        with response: PaginationResult<BookmarkData>,
        for queryConfig: QueryConfiguration<BookmarksFilter, BookmarksSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        bookmarks = bookmarks.sortedMerge(response.models, sorting: bookmarkFoldersSorting)
    }
}
