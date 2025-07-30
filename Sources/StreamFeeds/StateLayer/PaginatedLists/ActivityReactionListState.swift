//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

/// An observable state object that manages the current state of an activity reaction list.
///
/// This class provides reactive state management for a collection of activity reactions.
/// It automatically handles real-time updates when reactions are added or removed from the activity,
/// and maintains pagination state for loading additional reactions.
///
/// ## Observable Properties
///
/// The state object publishes changes to its properties, allowing you to observe updates:
///
/// ```swift
/// reactionList.state.$reactions
///     .sink { reactions in
///         // Update UI when reactions change
///     }
///     .store(in: &cancellables)
/// ```
///
/// ## Real-time Updates
///
/// The state automatically updates when WebSocket events are received:
/// - When reactions are removed from the activity
/// - When new pages of reactions are loaded
///
/// ## Thread Safety
///
/// This class is marked with `@MainActor` and should only be accessed from the main thread.
@MainActor public class ActivityReactionListState: ObservableObject {
    private var webSocketObserver: WebSocketObserver?
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    
    init(query: ActivityReactionsQuery, events: WSEventsSubscribing) {
        self.query = query
        webSocketObserver = WebSocketObserver(activityId: query.activityId, subscribing: events, handlers: changeHandlers)
    }
    
    /// The query configuration used to fetch activity reactions.
    ///
    /// This contains the activity ID, filters, sorting options, and pagination parameters
    /// that define how reactions should be fetched and displayed.
    public let query: ActivityReactionsQuery
    
    /// The current collection of activity reactions.
    ///
    /// This array contains all the reactions that have been loaded for the activity.
    /// The reactions are automatically sorted according to the query configuration.
    /// Changes to this array are published and can be observed for UI updates.
    ///
    /// ```swift
    /// reactionList.state.$reactions
    ///     .sink { reactions in
    ///         // Update your UI with the new reactions
    ///         updateReactionUI(with: reactions)
    ///     }
    ///     .store(in: &cancellables)
    /// ```
    @Published public private(set) var reactions: [FeedsReactionData] = []
    
    // MARK: - Pagination State
    
    /// The pagination information from the last query.
    ///
    /// This contains the pagination cursors (`next` and `previous`) that can be used
    /// to fetch additional pages of reactions. The pagination data is automatically
    /// updated when new pages are loaded.
    public private(set) var pagination: PaginationData?
    
    /// Indicates whether there are more reactions available to load.
    ///
    /// This property returns `true` if there are additional pages of reactions available
    /// to fetch. You can use this to determine whether to show a "Load More" button
    /// or implement infinite scrolling.
    public var canLoadMore: Bool { pagination?.next != nil }
    
    /// The configuration used for the last activity reactions query.
    ///
    /// This contains the filter and sort configuration that was used for the most recent
    /// query. It's used internally to maintain consistent sorting when new pages are loaded.
    private(set) var queryConfig: QueryConfiguration<ActivityReactionsFilter, ActivityReactionsSortField>?
    
    var reactionsSorting: [Sort<ActivityReactionsSortField>] {
        if let sort = queryConfig?.sort, !sort.isEmpty {
            return sort
        }
        return Sort<ActivityReactionsSortField>.defaultSorting
    }
}

// MARK: - Updating the State

extension ActivityReactionListState {
    struct ChangeHandlers {
        let reactionRemoved: @MainActor (FeedsReactionData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            reactionRemoved: { [weak self] reaction in
                self?.reactions.remove(byId: reaction.id)
            }
        )
    }
    
    func access<T>(_ actions: @MainActor (ActivityReactionListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(
        with response: PaginationResult<FeedsReactionData>,
        for queryConfig: QueryConfiguration<ActivityReactionsFilter, ActivityReactionsSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        reactions = reactions.sortedMerge(response.models, sorting: reactionsSorting)
    }
}
