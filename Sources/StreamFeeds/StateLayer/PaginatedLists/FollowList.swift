//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowList: Sendable {
    @MainActor private let stateBuilder: StateBuilder<FollowListState>
    private let feedsRepository: FeedsRepository
    
    init(query: FollowsQuery, client: FeedsClient) {
        feedsRepository = client.feedsRepository
        self.query = query
        let events = client.eventsMiddleware
        stateBuilder = StateBuilder { FollowListState(query: query, events: events) }
    }

    public let query: FollowsQuery
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the follow list.
    @MainActor public var state: FollowListState { stateBuilder.state }
    
    // MARK: - Paginating the List of Follows
    
    @discardableResult
    public func get() async throws -> [FollowData] {
        try await queryFollows(with: query)
    }
    
    public func queryMoreFollows(limit: Int? = nil) async throws -> [FollowData] {
        let nextQuery: FollowsQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return FollowsQuery(
                filter: state.queryConfig?.filter,
                sort: state.queryConfig?.sort,
                limit: limit,
                next: next,
                previous: nil
            )
        }
        guard let nextQuery else { return [] }
        return try await queryFollows(with: nextQuery)
    }
    
    // MARK: - Private
    
    private func queryFollows(with query: FollowsQuery) async throws -> [FollowData] {
        let result = try await feedsRepository.queryFollows(request: query.toRequest())
        await state.didPaginate(
            with: result,
            for: .init(filter: query.filter, sort: query.sort)
        )
        return result.models
    }
}
