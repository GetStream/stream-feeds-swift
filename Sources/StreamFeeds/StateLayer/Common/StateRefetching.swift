//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

protocol StateRefetching: AnyObject, Sendable {
    associatedtype Model: Identifiable & Sendable
    func loadedCount() async -> Int?
    func fetchPage(next: String?) async throws -> PaginationResult<Model>
    func didRefetch(_ result: PaginationResult<Model>) async
}

extension StateRefetching {
    func subscribeToReconnectionRefresh(of client: FeedsClient, in disposableBag: DisposableBag) {
        if client.feedsConfig.isAutomaticSyncOnReconnectEnabled {
            client.subscribeToReconnection(in: disposableBag) { [weak self] in try await self?.refetch() }
        }
    }

    func refetch() async throws {
        guard let loadedCount = await loadedCount() else { return }
        var models = [Model]()
        var pagination = PaginationData.empty
        // Pages use the query's limit and at least the first page is refetched
        while true {
            let page = try await fetchPage(next: pagination.next)
            try Task.checkCancellation()
            // Items can move to a later page while refetching
            let pageIds = Set(page.models.map(\.id))
            let addsNewModels = !pageIds.isSubset(of: models.map(\.id))
            models.removeAll { pageIds.contains($0.id) }
            models.append(contentsOf: page.models)
            pagination = page.pagination
            guard addsNewModels, models.count < loadedCount, pagination.next != nil else { break }
        }
        await didRefetch(PaginationResult(models: models, pagination: pagination))
    }
}

protocol CursorPaginatedQuery: Sendable {
    var next: String? { get set }
    var previous: String? { get set }
}

extension CursorPaginatedQuery {
    func page(next: String?) -> Self {
        guard let next else { return self }
        var query = self
        query.next = next
        query.previous = nil
        return query
    }
}

@MainActor protocol PaginatedListState {
    associatedtype Model: Identifiable & Sendable
    var pagination: PaginationData? { get }
    var models: [Model] { get }
    func didRefetch(with response: PaginationResult<Model>)
}

protocol PaginatedListRefetching: StateRefetching {
    associatedtype Query: CursorPaginatedQuery
    associatedtype State: PaginatedListState where State.Model == Model
    var query: Query { get }
    @MainActor var state: State { get }
    func fetchPage(with query: Query) async throws -> PaginationResult<Model>
}

extension PaginatedListRefetching {
    @MainActor func loadedCount() async -> Int? {
        state.pagination == nil ? nil : state.models.count
    }

    func fetchPage(next: String?) async throws -> PaginationResult<Model> {
        try await fetchPage(with: query.page(next: next))
    }

    @MainActor func didRefetch(_ result: PaginationResult<Model>) async {
        state.didRefetch(with: result)
    }
}
