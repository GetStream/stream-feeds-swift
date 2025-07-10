//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public class PollVoteListState: ObservableObject {
    private var webSocketObserver: WebSocketObserver?
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    
    init(query: PollVotesQuery, events: WSEventsSubscribing) {
        self.query = query
        webSocketObserver = WebSocketObserver(pollId: query.pollId, subscribing: events, handlers: changeHandlers)
    }
    
    public let query: PollVotesQuery
    
    /// All the paginated poll votes.
    @Published public private(set) var votes: [PollVoteData] = []
    
    // MARK: - Pagination State
    
    /// Last pagination information.
    public private(set) var pagination: PaginationData?
    
    /// Indicates whether there are more poll votes available to load.
    public var canLoadMore: Bool { pagination?.next != nil }
    
    /// The configuration used for the last query.
    private(set) var queryConfig: QueryConfiguration<PollVotesFilter, PollVotesSortField>?
    
    var pollVotesSorting: [Sort<PollVotesSortField>] {
        if let sort = queryConfig?.sort, !sort.isEmpty {
            return sort
        }
        return Sort<PollVotesSortField>.defaultSorting
    }
}

// MARK: - Updating the State

extension PollVoteListState {
    struct ChangeHandlers {
        let pollVoteRemoved: @MainActor (String) -> Void
        let pollVoteUpdated: @MainActor (PollVoteData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            pollVoteRemoved: { [weak self] voteId in
                self?.votes.remove(byId: voteId)
            },
            pollVoteUpdated: { [weak self] pollVote in
                guard let sorting = self?.pollVotesSorting else { return }
                self?.votes.sortedReplace(pollVote, using: sorting)
            }
        )
    }
    
    func access<T>(_ actions: @MainActor (PollVoteListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(
        with response: PaginationResult<PollVoteData>,
        for queryConfig: QueryConfiguration<PollVotesFilter, PollVotesSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        votes = votes.sortedMerge(response.models, using: pollVotesSorting)
    }
}
