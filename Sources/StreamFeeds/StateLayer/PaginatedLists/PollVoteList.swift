//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class PollVoteList: Sendable {
    @MainActor private let stateBuilder: StateBuilder<PollVoteListState>
    private let pollsRepository: PollsRepository
    
    init(query: PollVotesQuery, client: FeedsClient) {
        pollsRepository = client.pollsRepository
        self.query = query
        let eventPublisher = client.stateLayerEventPublisher
        stateBuilder = StateBuilder { [eventPublisher] in
            PollVoteListState(
                query: query,
                eventPublisher: eventPublisher
            )
        }
    }

    public let query: PollVotesQuery
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the poll vote list.
    @MainActor public var state: PollVoteListState { stateBuilder.state }
    
    // MARK: - Paginating the List of Poll Votes
    
    @discardableResult public func get() async throws -> [PollVoteData] {
        try await queryPollVotes(with: query)
    }
    
    @discardableResult public func queryMorePollVotes(limit: Int? = nil) async throws -> [PollVoteData] {
        let nextQuery: PollVotesQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return PollVotesQuery(
                pollId: query.pollId,
                userId: query.userId,
                filter: state.queryConfig?.filter,
                sort: state.queryConfig?.sort,
                limit: limit,
                next: next,
                previous: nil
            )
        }
        guard let nextQuery else { return [] }
        return try await queryPollVotes(with: nextQuery)
    }
    
    // MARK: - Private
    
    private func queryPollVotes(with query: PollVotesQuery) async throws -> [PollVoteData] {
        let result = try await pollsRepository.queryPollVotes(
            pollId: query.pollId,
            userId: query.userId,
            request: query.toRequest()
        )
        await state.didPaginate(
            with: result,
            for: .init(filter: query.filter, sort: query.sort)
        )
        return result.models
    }
}
