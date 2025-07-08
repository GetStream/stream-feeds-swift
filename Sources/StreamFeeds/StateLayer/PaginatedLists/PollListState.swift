//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public class PollListState: ObservableObject {
    private var webSocketObserver: WebSocketObserver?
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    
    init(query: PollsQuery, events: WSEventsSubscribing) {
        self.query = query
        webSocketObserver = WebSocketObserver(subscribing: events, handlers: changeHandlers)
    }
    
    public let query: PollsQuery
    
    /// All the paginated polls.
    @Published public private(set) var polls: [PollData] = []
    
    // MARK: - Pagination State
    
    /// Last pagination information.
    public private(set) var pagination: PaginationData?
    
    /// Indicates whether there are more polls available to load.
    public var canLoadMore: Bool { pagination?.next != nil }
    
    /// The configuration used for the last query.
    private(set) var queryConfig: QueryConfiguration<PollsFilter, PollsSortField>?
    
    var pollsSorting: [Sort<PollsSortField>] {
        if let sort = queryConfig?.sort, !sort.isEmpty {
            return sort
        }
        return Sort<PollsSortField>.defaultSorting
    }
}

// MARK: - Updating the State

extension PollListState {
    struct ChangeHandlers {
        let pollUpdated: @MainActor (PollData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            pollUpdated: { [weak self] poll in
                // Only update, do not insert
                self?.polls.replace(byId: poll)
            }
        )
    }
    
    func access<T>(_ actions: @MainActor (PollListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(
        with response: PaginationResult<PollData>,
        for queryConfig: QueryConfiguration<PollsFilter, PollsSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        polls = polls.sortedMerge(response.models, using: pollsSorting)
    }
}
