//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public class FeedListState: ObservableObject {
    private var webSocketObserver: WebSocketObserver?
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    
    init(query: FeedsQuery, events: WSEventsSubscribing) {
        self.query = query
        webSocketObserver = WebSocketObserver(subscribing: events, handlers: changeHandlers)
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
    /// Handlers for various state change events.
    ///
    /// These handlers are called when WebSocket events are received and automatically update the state accordingly.
    struct ChangeHandlers {
        let feedUpdated: @MainActor (FeedData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            feedUpdated: { [weak self] feed in
                // Only update, do not insert
                self?.feeds.replace(byId: feed)
            }
        )
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
        feeds = feeds.sortedMerge(response.models, using: feedsSorting)
    }
}
