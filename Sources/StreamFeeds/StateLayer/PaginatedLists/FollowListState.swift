//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public class FollowListState: ObservableObject {
    private var eventSubscription: StateLayerEventPublisher.Subscription?
    
    init(query: FollowsQuery, eventPublisher: StateLayerEventPublisher) {
        self.query = query
        subscribe(to: eventPublisher)
    }
    
    public let query: FollowsQuery
    
    /// All the paginated feeds.
    @Published public private(set) var follows: [FollowData] = []
    
    // MARK: - Pagination State
    
    /// Last pagination information.
    public private(set) var pagination: PaginationData?
    
    /// Indicates whether there are more follows available to load.
    public var canLoadMore: Bool { pagination?.next != nil }
    
    /// The configuration used for the last activities query.
    private(set) var queryConfig: QueryConfiguration<FollowsFilter, FollowsSortField>?
    
    var followsSorting: [Sort<FollowsSortField>] {
        if let sort = queryConfig?.sort, !sort.isEmpty {
            return sort
        }
        return Sort<FollowsSortField>.defaultSorting
    }
}

// MARK: - Updating the State

extension FollowListState {
    private func subscribe(to publisher: StateLayerEventPublisher) {
        let matchesQuery: @Sendable (FollowData) -> Bool = { [query] follow in
            guard let filter = query.filter else { return true }
            return filter.matches(follow)
        }
        eventSubscription = publisher.subscribe { [weak self] event in
            switch event {
            case let .feedFollowAdded(follow, _):
                guard matchesQuery(follow) else { return }
                await self?.access { state in
                    state.follows.sortedInsert(follow, sorting: state.followsSorting)
                }
            case let .feedFollowDeleted(follow, _):
                await self?.access { state in
                    state.follows.remove(byId: follow.id)
                }
            case let .feedFollowUpdated(follow, _):
                let matches = matchesQuery(follow)
                await self?.access { state in
                    if matches {
                        state.follows.sortedReplace(follow, nesting: nil, sorting: state.followsSorting)
                    } else {
                        state.follows.remove(byId: follow.id)
                    }
                }
            default:
                break
            }
        }
    }
    
    @discardableResult func access<T>(_ actions: @MainActor (FollowListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(
        with response: PaginationResult<FollowData>,
        for queryConfig: QueryConfiguration<FollowsFilter, FollowsSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        follows = follows.sortedMerge(response.models, sorting: followsSorting)
    }
}
