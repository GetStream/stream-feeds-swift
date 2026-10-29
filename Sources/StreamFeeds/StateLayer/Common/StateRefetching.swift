//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

protocol StateRefetching: AnyObject, Sendable {
    associatedtype Model: Sendable

    // The first page size which is refetched even when less is loaded
    var refetchLimit: Int? { get }

    // Returns nil when nothing is loaded
    func loadedCount() async -> Int?

    func fetchPage(limit: Int, next: String?) async throws -> PaginationResult<Model>

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
        // The backend's max limit for all the paginated endpoints
        let pageSize = 100
        let count = max(loadedCount, refetchLimit ?? pageSize)
        var models = [Model]()
        var pagination = PaginationData.empty
        while models.count < count {
            let page = try await fetchPage(limit: min(pageSize, count - models.count), next: pagination.next)
            models.append(contentsOf: page.models)
            pagination = page.pagination
            guard pagination.next != nil, !page.models.isEmpty else { break }
        }
        await didRefetch(PaginationResult(models: models, pagination: pagination))
    }
}
