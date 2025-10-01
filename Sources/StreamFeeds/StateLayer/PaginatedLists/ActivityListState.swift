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
    private let currentUserId: String
    private var eventSubscription: StateLayerEventPublisher.Subscription?
    
    init(query: ActivitiesQuery, currentUserId: String, eventPublisher: StateLayerEventPublisher) {
        self.currentUserId = currentUserId
        self.query = query
        subscribe(to: eventPublisher)
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
    private func subscribe(to publisher: StateLayerEventPublisher) {
        let matchesQuery: @Sendable (ActivityData) -> Bool = { [query] activity in
            guard let filter = query.filter else { return true }
            return filter.matches(activity)
        }
        eventSubscription = publisher.subscribe { [weak self, currentUserId] event in
            switch event {
            case .activityAdded(let activityData, _):
                guard matchesQuery(activityData) else { return }
                await self?.access { state in
                    state.activities.sortedInsert(activityData, sorting: state.activitiesSorting)
                }
            case .activityUpdated(let activityData, _):
                let matches = matchesQuery(activityData)
                await self?.access { state in
                    if matches {
                        state.activities.sortedInsert(activityData, sorting: state.activitiesSorting)
                    } else {
                        state.activities.remove(byId: activityData.id)
                    }
                }
            case .activityDeleted(let activityId, _):
                await self?.access { state in
                    state.activities.removeAll { $0.id == activityId }
                }
            case .activityReactionAdded(let reactionData, let activityData, _):
                guard matchesQuery(activityData) else { return }
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.id == activityData.id },
                        changes: { $0.merge(with: activityData, add: reactionData, currentUserId: currentUserId) }
                    )
                }
            case .activityReactionDeleted(let reactionData, let activityData, _):
                guard matchesQuery(activityData) else { return }
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.id == activityData.id },
                        changes: { $0.merge(with: activityData, remove: reactionData, currentUserId: currentUserId) }
                    )
                }
            case .activityReactionUpdated(let reactionData, let activityData, _):
                guard matchesQuery(activityData) else { return }
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.id == activityData.id },
                        changes: { $0.merge(with: activityData, update: reactionData, currentUserId: currentUserId) }
                    )
                }
            case .bookmarkAdded(let bookmarkData):
                guard matchesQuery(bookmarkData.activity) else { return }
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.id == bookmarkData.activity.id },
                        changes: { $0.merge(with: bookmarkData.activity, add: bookmarkData, currentUserId: currentUserId) }
                    )
                }
            case .bookmarkDeleted(let bookmarkData):
                guard matchesQuery(bookmarkData.activity) else { return }
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.id == bookmarkData.activity.id },
                        changes: { $0.merge(with: bookmarkData.activity, remove: bookmarkData, currentUserId: currentUserId) }
                    )
                }
            case .bookmarkUpdated(let bookmarkData):
                guard matchesQuery(bookmarkData.activity) else { return }
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.id == bookmarkData.activity.id },
                        changes: { $0.merge(with: bookmarkData.activity, update: bookmarkData, currentUserId: currentUserId) }
                    )
                }
            case .commentAdded(let commentData, let activityData, _):
                guard matchesQuery(activityData) else { return }
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.id == activityData.id },
                        changes: {
                            $0.merge(with: activityData)
                            $0.addComment(commentData)
                        }
                    )
                }
            case .commentDeleted(let commentData, let activityId, _):
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.id == activityId },
                        changes: { $0.deleteComment(commentData) }
                    )
                }
            case .commentUpdated(let commentData, let activityId, _):
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.id == activityId },
                        changes: { $0.updateComment(commentData) }
                    )
                }
            case .commentsAddedBatch(let commentDatas, let activityId, _):
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.id == activityId },
                        changes: { activity in
                            for commentData in commentDatas {
                                activity.addComment(commentData)
                            }
                        }
                    )
                }
            case .pollUpdated(let pollData, _):
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.poll?.id == pollData.id },
                        changes: { $0.poll?.merge(with: pollData) }
                    )
                }
            case .pollDeleted(let pollId, _):
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.poll?.id == pollId },
                        changes: { $0.poll = nil }
                    )
                }
            case .pollVoteCasted(let vote, let pollData, _):
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.poll?.id == pollData.id },
                        changes: { $0.poll?.merge(with: pollData, add: vote, currentUserId: currentUserId) }
                    )
                }
            case .pollVoteDeleted(let vote, let pollData, _):
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.poll?.id == pollData.id },
                        changes: { $0.poll?.merge(with: pollData, remove: vote, currentUserId: currentUserId) }
                    )
                }
            case .pollVoteChanged(let vote, let pollData, _):
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.poll?.id == pollData.id },
                        changes: { $0.poll?.merge(with: pollData, change: vote, currentUserId: currentUserId) }
                    )
                }
            default:
                break
            }
        }
    }
    
    @discardableResult func access<T>(_ actions: @MainActor (ActivityListState) -> T) -> T {
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
