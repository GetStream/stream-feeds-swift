//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

protocol StateRefetching: AnyObject, Sendable {
    associatedtype Model: Identifiable & Sendable

    // Returns nil when nothing is loaded
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
            models.removeAll { pageIds.contains($0.id) }
            models.append(contentsOf: page.models)
            pagination = page.pagination
            guard models.count < loadedCount, pagination.next != nil, !page.models.isEmpty else { break }
        }
        await didRefetch(PaginationResult(models: models, pagination: pagination))
    }
}
