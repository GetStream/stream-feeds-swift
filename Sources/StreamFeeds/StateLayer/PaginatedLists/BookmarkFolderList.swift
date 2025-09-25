//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BookmarkFolderList: Sendable {
    @MainActor private let stateBuilder: StateBuilder<BookmarkFolderListState>
    private let bookmarksRepository: BookmarksRepository

    init(query: BookmarkFoldersQuery, client: FeedsClient) {
        bookmarksRepository = client.bookmarksRepository
        self.query = query
        let eventPublisher = client.stateLayerEventPublisher
        stateBuilder = StateBuilder { BookmarkFolderListState(query: query, eventPublisher: eventPublisher) }
    }

    public let query: BookmarkFoldersQuery

    // MARK: - Accessing the State

    /// An observable object representing the current state of the bookmark list.
    @MainActor public var state: BookmarkFolderListState { stateBuilder.state }

    // MARK: - Paginating the List of BookmarkFolders

    @discardableResult
    public func get() async throws -> [BookmarkFolderData] {
        try await queryBookmarkFolders(with: query)
    }

    public func queryMoreBookmarkFolders(limit: Int? = nil) async throws -> [BookmarkFolderData] {
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
