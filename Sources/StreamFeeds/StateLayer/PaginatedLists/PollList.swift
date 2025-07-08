//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A list of polls that can be queried and paginated.
///
/// This class provides a way to fetch and manage a collection of polls with support for filtering,
/// sorting, and pagination. It maintains an observable state that can be used in SwiftUI views.
public final class PollList: Sendable {
    @MainActor private let stateBuilder: StateBuilder<PollListState>
    private let pollsRepository: PollsRepository
    
    init(query: PollsQuery, client: FeedsClient) {
        pollsRepository = client.pollsRepository
        self.query = query
        let events = client.eventsMiddleware
        stateBuilder = StateBuilder { PollListState(query: query, events: events) }
    }

    public let query: PollsQuery
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the poll list.
    @MainActor public var state: PollListState { stateBuilder.state }
    
    // MARK: - Paginating the List of Polls
    
    /// Fetches the initial list of polls based on the current query.
    ///
    /// This method retrieves the first page of polls matching the query criteria.
    /// The results are automatically stored in the state and can be accessed via the `state.polls` property.
    ///
    /// - Returns: An array of poll data matching the query criteria
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func get() async throws -> [PollData] {
        try await queryPolls(with: query)
    }
    
    /// Loads more polls using the next page token from the previous query.
    ///
    /// This method fetches additional polls if there are more available based on the current query.
    /// The new polls are automatically merged with the existing ones in the state.
    ///
    /// - Parameter limit: Optional limit for the number of polls to load. If `nil`, uses the default limit.
    /// - Returns: An array of additional poll data
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult
    public func queryMorePolls(limit: Int? = nil) async throws -> [PollData] {
        let nextQuery: PollsQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return PollsQuery(
                filter: state.queryConfig?.filter,
                sort: state.queryConfig?.sort,
                limit: limit,
                next: next,
                previous: nil
            )
        }
        guard let nextQuery else { return [] }
        return try await queryPolls(with: nextQuery)
    }
    
    // MARK: - Private
    
    private func queryPolls(with query: PollsQuery) async throws -> [PollData] {
        let result = try await pollsRepository.queryPolls(with: query)
        await state.didPaginate(
            with: result,
            for: .init(filter: query.filter, sort: query.sort)
        )
        return result.models
    }
}
