//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedList: Sendable {
    @MainActor private let stateBuilder: StateBuilder<FeedListState>
    private let feedsRepository: FeedsRepository
    
    init(query: FeedsQuery, client: FeedsClient) {
        self.feedsRepository = client.feedsRepository
        self.query = query
        let events = client.eventsMiddleware
        stateBuilder = StateBuilder { FeedListState(query: query, events: events) }
    }

    public let query: FeedsQuery
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the feed list.
    @MainActor public var state: FeedListState { stateBuilder.state }
    
    // MARK: - Paginating the List of Feeds
    
    @discardableResult
    public func get() async throws -> [FeedData] {
        try await queryFeeds(with: query)
    }
    
    public func queryMoreFeeds(limit: Int? = nil) async throws -> [FeedData] {
        let nextQuery: FeedsQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return FeedsQuery(
                filter: state.queryConfig?.filter,
                sort: state.queryConfig?.sort,
                limit: limit,
                next: next,
                previous: nil,
                watch: query.watch
            )
        }
        guard let nextQuery else { return [] }
        return try await queryFeeds(with: nextQuery)
    }
    
    // MARK: - Private
    
    private func queryFeeds(with query: FeedsQuery) async throws -> [FeedData] {
        let result = try await feedsRepository.queryFeeds(with: query)
        await state.didPaginate(
            with: result,
            for: .init(filter: query.filter, sort: query.sort)
        )
        return result.models
    }
}
