//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A paginated list of activities that supports real-time updates and filtering.
///
/// `ActivityList` provides a convenient way to fetch, paginate, and observe activities
/// with automatic real-time updates via WebSocket events. It manages the state of activities
/// and provides methods for loading more activities as needed.
public final class ActivityList: Sendable {
    @MainActor private let stateBuilder: StateBuilder<ActivityListState>
    private let activitiesRepository: ActivitiesRepository
    private let eventPublisher: StateLayerEventPublisher
    private let ownCapabilitiesRepository: OwnCapabilitiesRepository
    
    init(query: ActivitiesQuery, client: FeedsClient) {
        activitiesRepository = client.activitiesRepository
        eventPublisher = client.stateLayerEventPublisher
        ownCapabilitiesRepository = client.ownCapabilitiesRepository
        self.query = query
        let currentUserId = client.user.id
        stateBuilder = StateBuilder { [eventPublisher] in
            ActivityListState(
                query: query,
                currentUserId: currentUserId,
                eventPublisher: eventPublisher
            )
        }
    }

    /// The query configuration used for fetching activities.
    ///
    /// This property contains the filtering, sorting, and pagination parameters
    /// that define how activities should be fetched and displayed.
    public let query: ActivitiesQuery
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the activity list.
    @MainActor public var state: ActivityListState { stateBuilder.state }
    
    // MARK: - Paginating the List of Activities
    
    /// Fetches the initial set of activities based on the current query configuration.
    ///
    /// This method retrieves the first page of activities using the filtering and sorting
    /// parameters defined in the query. The results are automatically stored in the state
    /// and can be observed through the `state.activities` property.
    ///
    /// - Returns: An array of `ActivityData` objects representing the fetched activities
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult public func get() async throws -> [ActivityData] {
        try await queryActivities(with: query)
    }
    
    /// Fetches the next page of activities if available.
    ///
    /// This method retrieves additional activities using the pagination cursor from the
    /// previous request. The new activities are automatically merged with the existing
    /// activities in the state, maintaining the proper sort order.
    ///
    /// - Parameter limit: Optional limit for the number of activities to fetch.
    ///   If not specified, uses the default limit from the original query.
    /// - Returns: An array of `ActivityData` objects representing the additional activities.
    ///   Returns an empty array if no more activities are available.
    /// - Throws: `APIError` if the network request fails or the server returns an error
    @discardableResult public func queryMoreActivities(limit: Int? = nil) async throws -> [ActivityData] {
        let nextQuery: ActivitiesQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return ActivitiesQuery(
                filter: state.queryConfig?.filter,
                sort: state.queryConfig?.sort,
                limit: limit,
                next: next,
                previous: nil
            )
        }
        guard let nextQuery else { return [] }
        return try await queryActivities(with: nextQuery)
    }
    
    // MARK: - Private
    
    private func queryActivities(with query: ActivitiesQuery) async throws -> [ActivityData] {
        let result = try await activitiesRepository.queryActivities(with: query)
        await state.didPaginate(
            with: result,
            for: .init(filter: query.filter, sort: query.sort)
        )
        if let updated = ownCapabilitiesRepository.saveCapabilities(in: result.models.compactMap(\.currentFeed)) {
            await eventPublisher.sendEvent(.feedOwnCapabilitiesUpdated(updated))
        }
        return result.models
    }
}
