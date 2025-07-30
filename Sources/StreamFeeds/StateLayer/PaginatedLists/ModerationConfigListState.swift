//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

/// An observable object representing the current state of a moderation configuration list.
///
/// This class manages the state of moderation configurations, including the list of configurations,
/// pagination information, and real-time updates from WebSocket events.
/// It automatically handles configuration additions, updates, and deletions.
///
/// ## Usage
///
/// ```swift
/// // Access the state from a ModerationConfigList
/// let configList = client.moderationConfigList(for: query)
/// let state = configList.state
///
/// // Observe configuration changes
/// state.$configs
///     .sink { configs in
///         // Update UI with new configurations
///     }
///     .store(in: &cancellables)
///
/// // Check pagination status
/// if state.canLoadMore {
///     // Load more configurations
/// }
///
/// // Access current configurations
/// let currentConfigs = state.configs
/// ```
///
/// ## Features
///
/// - **Observable State**: Uses `@Published` properties for reactive UI updates
/// - **Pagination Support**: Tracks pagination state for loading more configurations
/// - **Thread Safety**: All updates are performed on the main actor
/// - **Change Handlers**: Internal handlers for processing WebSocket events
///
/// ## Thread Safety
///
/// This class is designed to run on the main actor and all state updates
/// are performed on the main thread to ensure UI consistency.
@MainActor public class ModerationConfigListState: ObservableObject {
    init(query: ModerationConfigsQuery, events: WSEventsSubscribing) {
        self.query = query
    }
    
    /// The query configuration used to fetch configurations.
    public let query: ModerationConfigsQuery
    
    /// All the paginated moderation configurations.
    ///
    /// This property contains the current list of configurations based on the query
    /// configuration. The list is automatically updated when new configurations are
    /// added, existing configurations are updated or deleted.
    @Published public internal(set) var configs: [ModerationConfigData] = []
    
    // MARK: - Pagination State
    
    /// Last pagination information from the most recent API response.
    ///
    /// This property contains the pagination metadata from the last successful
    /// API request. It's used to determine if more configurations can be loaded and
    /// to construct subsequent pagination requests.
    public private(set) var pagination: PaginationData?
    
    /// Indicates whether there are more configurations available to load.
    ///
    /// This computed property checks if a "next" cursor exists in the
    /// pagination data, indicating that more configurations can be fetched.
    public var canLoadMore: Bool { pagination?.next != nil }
    
    private(set) var queryConfig: QueryConfiguration<ModerationConfigsFilter, ModerationConfigsSortField>?
    
    var configsSorting: [Sort<ModerationConfigsSortField>] {
        if let sort = queryConfig?.sort, !sort.isEmpty {
            return sort
        }
        return Sort<ModerationConfigsSortField>.defaultSorting
    }
}

// MARK: - Updating the State

extension ModerationConfigListState {
    func access<T>(_ actions: @MainActor (ModerationConfigListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(
        with response: PaginationResult<ModerationConfigData>,
        for queryConfig: QueryConfiguration<ModerationConfigsFilter, ModerationConfigsSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        configs = configs.sortedMerge(response.models, sorting: configsSorting)
    }
}
