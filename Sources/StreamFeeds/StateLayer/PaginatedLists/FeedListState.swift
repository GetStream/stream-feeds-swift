//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public final class FeedListState: ObservableObject, StateAccessing {
    private var canFilterLocally: Bool
    private var eventSubscription: StateLayerEventPublisher.Subscription?
    private let refetchSubject: AllocatedUnfairLock<PassthroughSubject<Void, Never>>

    init(query: FeedsQuery, eventPublisher: StateLayerEventPublisher, refetchSubject: AllocatedUnfairLock<PassthroughSubject<Void, Never>>) {
        self.query = query
        self.canFilterLocally = query.canFilterLocally
        self.refetchSubject = refetchSubject
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
        let matchesQuery: @Sendable (FeedData) -> Bool = { [query] feedData in
            guard let filter = query.filter else { return true }
            return filter.matches(feedData)
        }
        eventSubscription = publisher.subscribe { [weak self, canFilterLocally, refetchSubject] event in
            switch event {
            case .feedAdded(let feed, _):
                if canFilterLocally {
                    guard matchesQuery(feed) else { return }
                    await self?.access { state in
                        state.feeds.sortedInsert(feed, sorting: state.feedsSorting)
                    }
                } else {
                    // Refetch data for determing if the added feed is part of the current query
                    refetchSubject.withLock { $0.send() }
                }
            case .feedDeleted(let feedId):
                await self?.access { state in
                    state.feeds.remove(byId: feedId.rawValue)
                }
            case .feedUpdated(let feed, _):
                if canFilterLocally {
                    let matches = matchesQuery(feed)
                    await self?.access { state in
                        if matches {
                            state.feeds.sortedReplace(feed, nesting: nil, sorting: state.feedsSorting)
                        } else {
                            state.feeds.remove(byId: feed.id)
                        }
                    }
                } else {
                    // Simplified for reducing API calls: update could also mean that the feed does not match with the query
                    await self?.access { state in
                        state.feeds.sortedReplace(feed, nesting: nil, sorting: state.feedsSorting)
                    }
                }
            default:
                break
            }
        }
    }

    func didPaginate(
        with response: PaginationResult<FeedData>,
        for queryConfig: QueryConfiguration<FeedsFilter, FeedsSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        feeds = feeds.sortedMerge(response.models, sorting: feedsSorting)
    }
    
    func didRefetch(
        with response: PaginationResult<FeedData>,
        refetchQuery: FeedsQuery
    ) {
        guard let limit = refetchQuery.limit, limit > 0 else { return }
        let existing = feeds.dropFirst(limit)
        feeds = Array(existing).sortedMerge(response.models, sorting: feedsSorting)
    }
}
