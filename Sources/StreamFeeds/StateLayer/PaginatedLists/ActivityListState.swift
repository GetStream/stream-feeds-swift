//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

/// An observable state object that manages the activities list and handles real-time updates.
///
/// `ActivityListState` provides a reactive interface for observing changes to the activities list,
/// including pagination state and real-time updates from WebSocket events. It automatically
/// handles sorting, merging, and updating activities as they change.
///
/// ## Example Usage
/// ```swift
/// let activityList = client.activityList(for: query)
/// await activityList.state.$activities.sink { activities in
///     // Update UI with new activities
/// }
/// ```
@MainActor public class ActivityListState: ObservableObject {
    private var webSocketObserver: WebSocketObserver?
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    private let currentUserId: String
    
    init(query: ActivitiesQuery, currentUserId: String, events: WSEventsSubscribing) {
        self.currentUserId = currentUserId
        self.query = query
        webSocketObserver = WebSocketObserver(subscribing: events, handlers: changeHandlers)
    }
    
    /// The query configuration used for fetching activities.
    ///
    /// This property contains the filtering, sorting, and pagination parameters
    /// that define how activities should be fetched and displayed.
    public let query: ActivitiesQuery
    
    /// All the paginated activities in the current list.
    ///
    /// This property contains all activities that have been fetched and merged,
    /// maintaining the proper sort order. It automatically updates when new activities
    /// are loaded, when real-time events occur, or when activities are modified.
    ///
    /// - Note: This property is `@Published` and can be observed for UI updates.
    ///   Changes to this property will trigger SwiftUI view updates automatically.
    @Published public private(set) var activities: [ActivityData] = []
    
    // MARK: - Pagination State
    
    /// Last pagination information from the most recent request.
    ///
    /// This property contains the pagination cursors and metadata from the last
    /// successful request. It is used to determine if more activities can be loaded
    /// and to construct subsequent pagination requests.
    public private(set) var pagination: PaginationData?
    
    /// Indicates whether there are more activities available to load.
    ///
    /// This computed property checks if a next page cursor exists in the pagination data.
    /// Use this property to determine whether to show "Load More" buttons or implement
    /// infinite scrolling in your UI.
    public var canLoadMore: Bool { pagination?.next != nil }
    
    /// The configuration used for the last activities query.
    private(set) var queryConfig: QueryConfiguration<ActivitiesFilter, ActivitiesSortField>?
    
    var activitiesSorting: [Sort<ActivitiesSortField>] {
        if let sort = queryConfig?.sort, !sort.isEmpty {
            return sort
        }
        return Sort<ActivitiesSortField>.defaultSorting
    }
}

// MARK: - Updating the State

extension ActivityListState {
    struct ChangeHandlers {
        let activityRemoved: @MainActor (ActivityData) -> Void
        let activityUpdated: @MainActor (ActivityData) -> Void
        let bookmarkAdded: @MainActor (BookmarkData) -> Void
        let bookmarkRemoved: @MainActor (BookmarkData) -> Void
        let commentAdded: @MainActor (CommentData) -> Void
        let commentRemoved: @MainActor (CommentData) -> Void
        let reactionAdded: @MainActor (FeedsReactionData) -> Void
        let reactionRemoved: @MainActor (FeedsReactionData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            activityRemoved: { [weak self] activity in
                guard let sorting = self?.activitiesSorting else { return }
                self?.activities.sortedRemove(activity, nesting: nil, sorting: sorting)
            },
            activityUpdated: { [weak self] activity in
                guard let sorting = self?.activitiesSorting else { return }
                self?.activities.sortedInsert(activity, sorting: sorting)
            },
            bookmarkAdded: { [weak self] bookmark in
                guard let self else { return }
                activities.updateFirstElement(
                    where: { $0.id == bookmark.activity.id },
                    changes: { $0.addBookmark(bookmark, currentUserId: currentUserId) }
                )
            },
            bookmarkRemoved: { [weak self] bookmark in
                guard let self else { return }
                activities.updateFirstElement(
                    where: { $0.id == bookmark.activity.id },
                    changes: { $0.deleteBookmark(bookmark, currentUserId: currentUserId) }
                )
            },
            commentAdded: { [weak self] comment in
                self?.activities.updateFirstElement(
                    where: { $0.id == comment.objectId },
                    changes: { $0.addComment(comment) }
                )
            },
            commentRemoved: { [weak self] comment in
                self?.activities.updateFirstElement(
                    where: { $0.id == comment.objectId },
                    changes: { $0.deleteComment(comment) }
                )
            },
            reactionAdded: { [weak self] reaction in
                guard let self else { return }
                activities.updateFirstElement(
                    where: { $0.id == reaction.activityId },
                    changes: { $0.addReaction(reaction, currentUserId: currentUserId) }
                )
            },
            reactionRemoved: { [weak self] reaction in
                guard let self else { return }
                activities.updateFirstElement(
                    where: { $0.id == reaction.activityId },
                    changes: { $0.removeReaction(reaction, currentUserId: currentUserId) }
                )
            }
        )
    }
    
    func access<T>(_ actions: @MainActor (ActivityListState) -> T) -> T {
        actions(self)
    }
    
    func didPaginate(
        with response: PaginationResult<ActivityData>,
        for queryConfig: QueryConfiguration<ActivitiesFilter, ActivitiesSortField>
    ) {
        pagination = response.pagination
        self.queryConfig = queryConfig
        activities = activities.sortedMerge(response.models, sorting: activitiesSorting)
    }
}
