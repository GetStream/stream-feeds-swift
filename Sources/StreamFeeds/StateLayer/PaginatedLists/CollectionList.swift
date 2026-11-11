//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A paginated list of collections matching a query.
///
/// The list updates when this client creates, updates or deletes collections.
public final class CollectionList: Sendable {
    private let disposableBag = DisposableBag()
    @MainActor private let stateBuilder: StateBuilder<CollectionListState>
    private let activitiesRepository: ActivitiesRepository

    init(query: CollectionsQuery, client: FeedsClient) {
        activitiesRepository = client.activitiesRepository
        self.query = query
        let eventPublisher = client.stateLayerEventPublisher
        stateBuilder = StateBuilder { CollectionListState(query: query, eventPublisher: eventPublisher) }
        subscribeToReconnectionRefresh(of: client, in: disposableBag)
    }

    /// The query used for fetching collections.
    public let query: CollectionsQuery

    // MARK: - Accessing the State

    /// An observable object representing the current state of the collection list.
    @MainActor public var state: CollectionListState { stateBuilder.state }

    // MARK: - Paginating the List of Collections

    /// Fetches the first page of collections.
    ///
    /// - Returns: The collections of the first page.
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult public func get() async throws -> [CollectionData] {
        try await queryCollections(with: query)
    }

    /// Fetches the next page of collections.
    ///
    /// - Parameter limit: The maximum number of collections to fetch. If `nil`, uses the API default.
    /// - Returns: The collections of the next page, or an empty array when there are no more pages.
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult public func queryMoreCollections(limit: Int? = nil) async throws -> [CollectionData] {
        let nextQuery: CollectionsQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return CollectionsQuery(
                filter: state.queryConfig?.filter,
                sort: state.queryConfig?.sort,
                limit: limit,
                next: next,
                previous: nil
            )
        }
        guard let nextQuery else { return [] }
        return try await queryCollections(with: nextQuery)
    }

    // MARK: - Private

    private func queryCollections(with query: CollectionsQuery) async throws -> [CollectionData] {
        let result = try await activitiesRepository.queryCollections(with: query)
        await state.didPaginate(
            with: result,
            for: .init(filter: query.filter, sort: query.sort)
        )
        return result.models
    }
}

// MARK: - Refetching

extension CollectionList: StateRefetching {
    /// Refetching needs an `Identifiable` model, and a collection's `id` is only unique within its name.
    struct RefetchedCollection: Identifiable, Sendable {
        let collection: CollectionData
        var id: String { collection.reference }
    }

    @MainActor func loadedCount() async -> Int? {
        state.pagination == nil ? nil : state.collections.count
    }

    func fetchPage(next: String?) async throws -> PaginationResult<RefetchedCollection> {
        let result = try await activitiesRepository.queryCollections(with: query.page(next: next))
        return PaginationResult(models: result.models.map(RefetchedCollection.init), pagination: result.pagination)
    }

    @MainActor func didRefetch(_ result: PaginationResult<RefetchedCollection>) async {
        state.didRefetch(with: PaginationResult(models: result.models.map(\.collection), pagination: result.pagination))
    }
}

extension CollectionsQuery: CursorPaginatedQuery {}
