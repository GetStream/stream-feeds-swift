//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public class BookmarkFolderListState: ObservableObject {
    private var eventSubscription: StateLayerEventPublisher.Subscription?

    init(query: BookmarkFoldersQuery, eventPublisher: StateLayerEventPublisher) {
        self.query = query
        subscribe(to: eventPublisher)
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
    private func subscribe(to publisher: StateLayerEventPublisher) {
        eventSubscription = publisher.subscribe { [weak self] event in
            switch event {
            case .bookmarkFolderDeleted(let folder):
                await self?.access { state in
                    state.folders.remove(byId: folder.id)
                }
            case .bookmarkFolderUpdated(let folder):
                await self?.access { state in
                    state.folders.sortedReplace(folder, nesting: nil, sorting: state.bookmarksSorting)
                }
            default:
                break
            }
        }
    }

    @discardableResult func access<T>(_ actions: @MainActor (BookmarkFolderListState) -> T) -> T {
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
