//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BookmarkFolderList: Sendable {
    private let disposableBag = DisposableBag()
    @MainActor private let stateBuilder: StateBuilder<BookmarkFolderListState>
    private let bookmarksRepository: BookmarksRepository

    init(query: BookmarkFoldersQuery, client: FeedsClient) {
        bookmarksRepository = client.bookmarksRepository
        self.query = query
        let eventPublisher = client.stateLayerEventPublisher
        stateBuilder = StateBuilder { BookmarkFolderListState(query: query, eventPublisher: eventPublisher) }
        subscribeToReconnectionRefresh(of: client, in: disposableBag)
    }

    public let query: BookmarkFoldersQuery

    // MARK: - Accessing the State

    /// An observable object representing the current state of the bookmark list.
    @MainActor public var state: BookmarkFolderListState { stateBuilder.state }

    // MARK: - Paginating the List of BookmarkFolders

    @discardableResult public func get() async throws -> [BookmarkFolderData] {
        try await queryBookmarkFolders(with: query)
    }

    @discardableResult public func queryMoreBookmarkFolders(limit: Int? = nil) async throws -> [BookmarkFolderData] {
        let nextQuery: BookmarkFoldersQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return BookmarkFoldersQuery(
                filter: state.queryConfig?.filter,
                sort: state.queryConfig?.sort,
                limit: limit,
                next: next,
                previous: nil
            )
        }
        guard let nextQuery else { return [] }
        return try await queryBookmarkFolders(with: nextQuery)
    }

    // MARK: - Private

    private func queryBookmarkFolders(with query: BookmarkFoldersQuery) async throws -> [BookmarkFolderData] {
        let result = try await bookmarksRepository.queryBookmarkFolders(with: query)
        await state.didPaginate(
            with: result,
            for: .init(filter: query.filter, sort: query.sort)
        )
        return result.models
    }
}

// MARK: - Refetching

extension BookmarkFolderList: StateRefetching {
    func loadedCount() async -> Int? {
        await state.access { $0.pagination == nil ? nil : $0.folders.count }
    }

    func fetchPage(next: String?) async throws -> PaginationResult<BookmarkFolderData> {
        var pageQuery = query
        pageQuery.next = next
        pageQuery.previous = nil
        return try await bookmarksRepository.queryBookmarkFolders(with: pageQuery)
    }

    func didRefetch(_ result: PaginationResult<BookmarkFolderData>) async {
        await state.didRefetch(with: result)
    }
}
