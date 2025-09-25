//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public class FeedListState: ObservableObject {
    private var eventSubscription: StateLayerEventPublisher.Subscription?

    init(query: FeedsQuery, eventPublisher: StateLayerEventPublisher) {
        self.query = query
        subscribe(to: eventPublisher)
    }

    public let query: FeedsQuery

    /// All the paginated feeds.
    @Published public private(set) var feeds: [FeedData] = []

    // MARK: - Pagination State

    /// Last pagination information.
    public private(set) var pagination: PaginationData?

    /// Indicates whether there are more feeds available to load.
    public var canLoadMore: Bool { pagination?.next != nil }

    /// The configuration used for the last activities query.
    private(set) var queryConfig: QueryConfiguration<FeedsFilter, FeedsSortField>?

    var feedsSorting: [Sort<FeedsSortField>] {
        if let sort = queryConfig?.sort, !sort.isEmpty {
            return sort
        }
        return Sort<FeedsSortField>.defaultSorting
    }
}

// MARK: - Updating the State

extension FeedListState {
    private func subscribe(to publisher: StateLayerEventPublisher) {
        eventSubscription = publisher.subscribe { [weak self] event in
            switch event {
            case .feedUpdated(let feed, _):
                await self?.access { state in
                    // Only update, do not insert
                    state.feeds.replace(byId: feed)
                }
            default:
                break
            }
        }
    }

    func access<T>(_ actions: @MainActor (FeedListState) -> T) -> T {
        actions(self)
    }

    func didPaginate(
        with response: PaginationResult<FeedData>,
        for queryConfig: QueryConfiguration<FeedsFilter, FeedsSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        feeds = feeds.sortedMerge(response.models, sorting: feedsSorting)
    }
}
