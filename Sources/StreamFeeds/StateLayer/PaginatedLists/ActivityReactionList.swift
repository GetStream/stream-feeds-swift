//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A list of activity reactions that provides pagination, filtering, and real-time updates.
///
/// This class manages a collection of reactions for a specific activity. It provides methods
/// to fetch reactions with pagination support and automatically handles real-time updates
/// when reactions are added or removed from the activity.
///
/// ## Usage
///
/// ```swift
/// let query = ActivityReactionsQuery(activityId: "activity-123")
/// let reactionList = client.activityReactionList(for: query)
/// 
/// // Fetch initial reactions
/// let reactions = try await reactionList.get()
/// 
/// // Load more reactions if available
/// if reactionList.state.canLoadMore {
///     let moreReactions = try await reactionList.queryMoreReactions()
/// }
/// 
/// // Observe state changes
/// reactionList.state.$reactions
///     .sink { reactions in
///         print("Updated reactions: \(reactions.count)")
///     }
///     .store(in: &cancellables)
/// ```
///
/// ## Real-time Updates
///
/// The list automatically updates when reactions are added or removed from the activity
/// through WebSocket events. The state is observable and will notify subscribers of changes.
public final class ActivityReactionList: Sendable {
    @MainActor private let stateBuilder: StateBuilder<ActivityReactionListState>
    private let activitiesRepository: ActivitiesRepository
    
    init(query: ActivityReactionsQuery, client: FeedsClient) {
        activitiesRepository = client.activitiesRepository
        self.query = query
        let events = client.eventsMiddleware
        stateBuilder = StateBuilder { ActivityReactionListState(query: query, events: events) }
    }

    /// The query configuration used to fetch activity reactions.
    ///
    /// This contains the activity ID, filters, sorting options, and pagination parameters
    /// that define how reactions should be fetched and displayed.
    public let query: ActivityReactionsQuery
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the activity reaction list.
    ///
    /// This state object contains the current reactions, pagination information, and loading state.
    /// You can observe changes to this state to update your UI when reactions are added, removed,
    /// or when new pages are loaded.
    ///
    /// ```swift
    /// reactionList.state.$reactions
    ///     .sink { reactions in
    ///         // Update UI with new reactions
    ///     }
    ///     .store(in: &cancellables)
    /// ```
    @MainActor public var state: ActivityReactionListState { stateBuilder.state }
    
    // MARK: - Paginating the List of Activity Reactions
    
    /// Fetches the initial page of activity reactions.
    ///
    /// This method retrieves the first page of reactions for the activity based on the query configuration.
    /// The results are automatically stored in the state and can be accessed through `state.reactions`.
    ///
    /// - Returns: An array of reaction data for the activity
    /// - Throws: `APIError` if the network request fails or the server returns an error
    ///
    /// - Example:
    ///   ```swift
    ///   let reactions = try await reactionList.get()
    ///   print("Fetched \(reactions.count) reactions")
    ///   ```
    @discardableResult
    public func get() async throws -> [FeedsReactionData] {
        try await queryActivityReactions(with: query)
    }
    
    /// Fetches the next page of activity reactions.
    ///
    /// This method retrieves additional reactions if more are available. The method uses the pagination
    /// cursor from the previous request to fetch the next page of results.
    ///
    /// - Parameter limit: Optional limit for the number of reactions to fetch. If not specified,
    ///   uses the default limit from the original query.
    /// - Returns: An array of additional reaction data for the activity
    /// - Throws: `APIError` if the network request fails or the server returns an error
    ///
    /// - Example:
    ///   ```swift
    ///   if reactionList.state.canLoadMore {
    ///       let moreReactions = try await reactionList.queryMoreReactions(limit: 20)
    ///       print("Loaded \(moreReactions.count) more reactions")
    ///   }
    ///   ```
    public func queryMoreReactions(limit: Int? = nil) async throws -> [FeedsReactionData] {
        let nextQuery: ActivityReactionsQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return ActivityReactionsQuery(
                activityId: state.query.activityId,
                filter: state.queryConfig?.filter,
                sort: state.queryConfig?.sort,
                limit: limit,
                next: next,
                previous: nil
            )
        }
        guard let nextQuery else { return [] }
        return try await queryActivityReactions(with: nextQuery)
    }
    
    // MARK: - Private
    
    private func queryActivityReactions(with query: ActivityReactionsQuery) async throws -> [FeedsReactionData] {
        let result = try await activitiesRepository.queryActivityReactions(request: query.toRequest(), activityId: query.activityId)
        await state.didPaginate(
            with: result,
            for: .init(filter: query.filter, sort: query.sort)
        )
        return result.models
    }
} 