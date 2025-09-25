//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public class PollListState: ObservableObject {
    private let currentUserId: String
    private var eventSubscription: StateLayerEventPublisher.Subscription?
    
    init(query: PollsQuery, eventPublisher: StateLayerEventPublisher, currentUserId: String) {
        self.currentUserId = currentUserId
        self.query = query
        subscribe(to: eventPublisher)
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
    private func subscribe(to publisher: StateLayerEventPublisher) {
        let matchesQuery: @Sendable (PollData) -> Bool = { [query] poll in
            guard let filter = query.filter else { return true }
            return filter.matches(poll)
        }
        eventSubscription = publisher.subscribe { [weak self, currentUserId] event in
            switch event {
            case let .pollDeleted(pollId, _):
                await self?.access { state in
                    state.polls.remove(byId: pollId)
                }
            case let .pollUpdated(poll, _):
                await self?.access { state in
                    state.polls.sortedReplace(poll, nesting: nil, sorting: state.pollsSorting)
                }
            case .pollVoteCasted(let vote, let pollData, _):
                guard matchesQuery(pollData) else { return }
                await self?.access { state in
                    state.polls.sortedUpdate(
                        ofId: pollData.id,
                        nesting: nil,
                        sorting: state.pollsSorting.areInIncreasingOrder(),
                        changes: { $0.merge(with: pollData, add: vote, currentUserId: currentUserId) }
                    )
                }
            case .pollVoteDeleted(let vote, let pollData, _):
                guard matchesQuery(pollData) else { return }
                await self?.access { state in
                    state.polls.sortedUpdate(
                        ofId: pollData.id,
                        nesting: nil,
                        sorting: state.pollsSorting.areInIncreasingOrder(),
                        changes: { $0.merge(with: pollData, remove: vote, currentUserId: currentUserId) }
                    )
                }
            case .pollVoteChanged(let vote, let pollData, _):
                guard matchesQuery(pollData) else { return }
                await self?.access { state in
                    state.polls.sortedUpdate(
                        ofId: pollData.id,
                        nesting: nil,
                        sorting: state.pollsSorting.areInIncreasingOrder(),
                        changes: { $0.merge(with: pollData, change: vote, currentUserId: currentUserId) }
                    )
                }
            default:
                break
            }
        }
    }
    
    @discardableResult func access<T>(_ actions: @MainActor (PollListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(
        with response: PaginationResult<PollData>,
        for queryConfig: QueryConfiguration<PollsFilter, PollsSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        polls = polls.sortedMerge(response.models, sorting: pollsSorting)
    }
}
