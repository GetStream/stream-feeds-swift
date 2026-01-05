//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A class representing a paginated list of moderation configurations.
///
/// ## Usage
///
/// ```swift
/// // Create a moderation configuration list
/// let configList = client.moderationConfigList(for: query)
///
/// // Fetch initial configurations
/// let configs = try await configList.get()
///
/// // Load more configurations if available
/// if configList.state.canLoadMore {
///     let moreConfigs = try await configList.queryMoreConfigs()
/// }
///
/// // Observe state changes
/// configList.state.$configs
///     .sink { configs in
///         // Handle configuration updates
///     }
///     .store(in: &cancellables)
/// ```
///
/// ## Features
///
/// - **Pagination**: Supports loading configurations in pages with configurable limits
/// - **Filtering**: Advanced filtering capabilities for configuration queries
/// - **Sorting**: Configurable sorting options for configuration ordering
/// - **Observable State**: Provides reactive state management for UI updates
///
/// ## Thread Safety
///
/// This class is thread-safe and conforms to `Sendable`. All state updates are
/// performed on the main actor to ensure UI consistency.
public final class ModerationConfigList: Sendable {
    @MainActor private let stateBuilder: StateBuilder<ModerationConfigListState>
    private let moderationRepository: ModerationRepository
    
    init(query: ModerationConfigsQuery, client: FeedsClient) {
        moderationRepository = client.moderationRepository
        self.query = query
        stateBuilder = StateBuilder {
            ModerationConfigListState(
                query: query
            )
        }
    }

    /// The query configuration used to fetch configurations.
    public let query: ModerationConfigsQuery
    
    // MARK: - Accessing the State
    
    /// An observable object representing the current state of the configuration list.
    ///
    /// This property provides access to the current configurations, pagination information,
    /// and real-time updates. The state automatically updates when WebSocket events
    /// are received for configuration additions, updates, and deletions.
    ///
    /// ```swift
    /// // Observe configuration changes
    /// configList.state.$configs
    ///     .sink { configs in
    ///         // Update UI with new configurations
    ///     }
    ///     .store(in: &cancellables)
    ///
    /// // Check if more configurations can be loaded
    /// if configList.state.canLoadMore {
    ///     // Load more configurations
    /// }
    /// ```
    @MainActor public var state: ModerationConfigListState { stateBuilder.state }
    
    // MARK: - Paginating the List of Configurations
    
    /// Fetches the initial set of moderation configurations.
    ///
    /// This method retrieves the first page of configurations based on the query configuration.
    /// The results are automatically stored in the state and can be accessed through
    /// the `state.configs` property.
    ///
    /// - Returns: An array of `ModerationConfigData` representing the fetched configurations
    /// - Throws: `APIError` if the network request fails or the server returns an error
    ///
    /// ## Example
    ///
    /// ```swift
    /// do {
    ///     let configs = try await configList.get()
    ///     print("Fetched \(configs.count) configurations")
    /// } catch {
    ///     print("Failed to fetch configurations: \(error)")
    /// }
    /// ```
    @discardableResult public func get() async throws -> [ModerationConfigData] {
        try await queryConfigs(with: query)
    }
    
    /// Loads the next page of configurations if more are available.
    ///
    /// This method fetches additional configurations using the pagination information
    /// from the previous request. If no more configurations are available, an empty
    /// array is returned.
    ///
    /// - Parameter limit: Optional limit for the number of configurations to fetch.
    ///   If not specified, uses the limit from the original query.
    /// - Returns: An array of `ModerationConfigData` representing the additional configurations.
    ///   Returns an empty array if no more configurations are available.
    /// - Throws: An error if the network request fails or the response cannot be parsed.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Check if more configurations are available
    /// guard configList.state.canLoadMore else { return }
    ///
    /// // Load more configurations
    /// do {
    ///     let moreConfigs = try await configList.queryMoreConfigs(limit: 20)
    ///     print("Loaded \(moreConfigs.count) more configurations")
    /// } catch {
    ///     print("Failed to load more configurations: \(error)")
    /// }
    /// ```
    @discardableResult public func queryMoreConfigs(limit: Int? = nil) async throws -> [ModerationConfigData] {
        let nextQuery: ModerationConfigsQuery? = await state.access { state in
            guard let next = state.pagination?.next else { return nil }
            return ModerationConfigsQuery(
                filter: state.queryConfig?.filter,
                sort: state.queryConfig?.sort,
                limit: limit,
                next: next,
                previous: nil
            )
        }
        guard let nextQuery else { return [] }
        return try await queryConfigs(with: nextQuery)
    }
    
    // MARK: - Private
    
    private func queryConfigs(with query: ModerationConfigsQuery) async throws -> [ModerationConfigData] {
        let result = try await moderationRepository.queryModerationConfigs(with: query)
        await state.didPaginate(
            with: result,
            for: .init(filter: query.filter, sort: query.sort)
        )
        return result.models
    }
}
