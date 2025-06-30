//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation

@MainActor public class FollowListState: ObservableObject {
    private var webSocketObserver: WebSocketObserver?
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    
    init(query: FollowsQuery, events: WSEventsSubscribing) {
        self.query = query
        webSocketObserver = WebSocketObserver(subscribing: events, handlers: changeHandlers)
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
    /// Handlers for various state change events.
    ///
    /// These handlers are called when WebSocket events are received and automatically update the state accordingly.
    struct ChangeHandlers {
        let followUpdated: @MainActor (FollowData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            followUpdated: { [weak self] feed in
                // Only update, do not insert
                self?.follows.replace(byId: feed)
            }
        )
    }
    
    func access<T>(_ actions: @MainActor (FollowListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(
        with response: PaginationResult<FollowData>,
        for queryConfig: QueryConfiguration<FollowsFilter, FollowsSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        follows = follows.sortedMerge(response.models, using: followsSorting)
    }
}
