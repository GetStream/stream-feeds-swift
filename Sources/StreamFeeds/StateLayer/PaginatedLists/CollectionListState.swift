//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public final class CollectionListState: ObservableObject, StateAccessing {
    private var eventSubscription: StateLayerEventPublisher.Subscription?

    init(query: CollectionsQuery, eventPublisher: StateLayerEventPublisher) {
        self.query = query
        subscribe(to: eventPublisher)
    }

    public let query: CollectionsQuery

    /// All the paginated collections.
    @Published public private(set) var collections: [CollectionData] = []

    // MARK: - Pagination State

    /// Last pagination information.
    public private(set) var pagination: PaginationData?

    /// Indicates whether there are more collections available to load.
    public var canLoadMore: Bool { pagination?.next != nil }

    /// The configuration used for the last query.
    private(set) var queryConfig: QueryConfiguration<CollectionsFilter, CollectionsSortField>?

    var collectionsSorting: [Sort<CollectionsSortField>] {
        if let sort = queryConfig?.sort, !sort.isEmpty {
            return sort
        }
        return Sort<CollectionsSortField>.defaultSorting
    }
}

// MARK: - Updating the State

extension CollectionListState {
    private func subscribe(to publisher: StateLayerEventPublisher) {
        let matchesQuery: @Sendable (CollectionData) -> Bool = { [query] collection in
            guard let filter = query.filter else { return true }
            return filter.matches(collection)
        }
        eventSubscription = publisher.subscribe { [weak self] event in
            switch event {
            case .collectionsAdded(let collections):
                let matching = collections.filter(matchesQuery)
                guard !matching.isEmpty else { return }
                await self?.access { state in
                    state.merge(matching)
                }
            case .collectionsDeleted(let references):
                await self?.access { state in
                    state.collections.removeAll { references.contains($0.reference) }
                }
            case .collectionsUpdated(let collections):
                let updates = collections.map { (collection: $0, matches: matchesQuery($0)) }
                await self?.access { state in
                    for update in updates {
                        guard let index = state.collections.firstIndex(where: { $0.reference == update.collection.reference }) else { continue }
                        if update.matches {
                            state.collections[index] = update.collection.keepingCreatedAt(of: state.collections[index])
                        } else {
                            state.collections.remove(at: index)
                        }
                    }
                    state.collections.sort(by: state.collectionsSorting.areInIncreasingOrder())
                }
            default:
                break
            }
        }
    }

    func didPaginate(
        with response: PaginationResult<CollectionData>,
        for queryConfig: QueryConfiguration<CollectionsFilter, CollectionsSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        merge(response.models)
    }

    func didRefetch(with response: PaginationResult<CollectionData>) {
        pagination = response.pagination
        collections = response.models
    }

    /// Replaces collections with the same reference and keeps the list sorted.
    private func merge(_ incoming: [CollectionData]) {
        let references = Set(incoming.map(\.reference))
        collections = (collections.filter { !references.contains($0.reference) } + incoming)
            .sorted(by: collectionsSorting.areInIncreasingOrder())
    }
}
