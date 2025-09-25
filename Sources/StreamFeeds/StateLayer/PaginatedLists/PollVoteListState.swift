//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public class PollVoteListState: ObservableObject {
    private var eventSubscription: StateLayerEventPublisher.Subscription?
    
    init(query: PollVotesQuery, eventPublisher: StateLayerEventPublisher) {
        self.query = query
        subscribe(to: eventPublisher)
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
    private func subscribe(to publisher: StateLayerEventPublisher) {
        let matchesQuery: @Sendable (PollVoteData) -> Bool = { [query] vote in
            guard let filter = query.filter else { return true }
            return filter.matches(vote)
        }
        eventSubscription = publisher.subscribe { [weak self, query] event in
            switch event {
            case .pollVoteCasted(let vote, let pollData, _):
                guard pollData.id == query.pollId else { return }
                guard matchesQuery(vote) else { return }
                await self?.access { state in
                    state.votes.sortedInsert(vote, sorting: state.pollVotesSorting)
                }
            case .pollVoteChanged(let vote, let pollData, _):
                guard pollData.id == query.pollId else { return }
                guard matchesQuery(vote) else { return }
                await self?.access { state in
                    state.votes.sortedReplace(vote, nesting: nil, sorting: state.pollVotesSorting)
                }
            case .pollVoteDeleted(let vote, let pollData, _):
                guard pollData.id == query.pollId else { return }
                guard matchesQuery(vote) else { return }
                await self?.access { state in
                    state.votes.remove(byId: vote.id)
                }
            default:
                break
            }
        }
    }
    
    @discardableResult func access<T>(_ actions: @MainActor (PollVoteListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(
        with response: PaginationResult<PollVoteData>,
        for queryConfig: QueryConfiguration<PollVotesFilter, PollVotesSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        votes = votes.sortedMerge(response.models, sorting: pollVotesSorting)
    }
}
