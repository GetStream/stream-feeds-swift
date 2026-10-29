//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BookmarkList: Sendable {
    private let disposableBag = DisposableBag()
    @MainActor private let stateBuilder: StateBuilder<BookmarkListState>
    private let bookmarksRepository: BookmarksRepository
    private let eventPublisher: StateLayerEventPublisher
    private let ownCapabilitiesRepository: OwnCapabilitiesRepository

    init(query: BookmarksQuery, client: FeedsClient) {
        bookmarksRepository = client.bookmarksRepository
        eventPublisher = client.stateLayerEventPublisher
        ownCapabilitiesRepository = client.ownCapabilitiesRepository
        self.query = query
        let eventPublisher = client.stateLayerEventPublisher
        stateBuilder = StateBuilder { BookmarkListState(query: query, eventPublisher: eventPublisher) }
        subscribeToReconnectionRefresh(of: client, in: disposableBag)
    }

    public let query: BookmarksQuery

    // MARK: - Accessing the State

    /// An observable object representing the current state of the bookmark list.
    @MainActor public var state: BookmarkListState { stateBuilder.state }

    // MARK: - Paginating the List of Bookmarks

    @discardableResult public func get() async throws -> [BookmarkData] {
        try await queryBookmarks(with: query)
    }

    @discardableResult public func queryMoreBookmarks(limit: Int? = nil) async throws -> [BookmarkData] {
        let nextQuery: BookmarksQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return BookmarksQuery(
                filter: state.queryConfig?.filter,
                sort: state.queryConfig?.sort,
                limit: limit,
                next: next,
                previous: nil
            )
        }
        guard let nextQuery else { return [] }
        return try await queryBookmarks(with: nextQuery)
    }

    // MARK: - Private

    private func queryBookmarks(with query: BookmarksQuery) async throws -> [BookmarkData] {
        let result = try await bookmarksRepository.queryBookmarks(with: query)
        await state.didPaginate(
            with: result,
            for: .init(filter: query.filter, sort: query.sort)
        )
        if let updated = ownCapabilitiesRepository.saveCapabilities(in: result.models.compactMap(\.activity.currentFeed)) {
            await eventPublisher.sendEvent(.feedOwnCapabilitiesUpdated(updated))
        }
        return result.models
    }
}

// MARK: - Refetching

extension BookmarkList: StateRefetching {
    var refetchLimit: Int? { query.limit }

    func loadedCount() async -> Int? {
        await state.access { $0.pagination == nil ? nil : $0.bookmarks.count }
    }

    func fetchPage(limit: Int, next: String?) async throws -> PaginationResult<BookmarkData> {
        var pageQuery = query
        pageQuery.limit = limit
        pageQuery.next = next
        pageQuery.previous = nil
        return try await bookmarksRepository.queryBookmarks(with: pageQuery)
    }

    func didRefetch(_ result: PaginationResult<BookmarkData>) async {
        await state.didRefetch(with: result)
        if let updated = ownCapabilitiesRepository.saveCapabilities(in: result.models.compactMap(\.activity.currentFeed)) {
            await eventPublisher.sendEvent(.feedOwnCapabilitiesUpdated(updated))
        }
    }
}
