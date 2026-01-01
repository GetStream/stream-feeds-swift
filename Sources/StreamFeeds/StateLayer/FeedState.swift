//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

/// An observable object representing the current state of a feed.
///
/// This class manages the state of a feed including activities, followers, members, and pagination information.
/// It automatically updates when WebSocket events are received and provides change handlers for state modifications.
@MainActor public final class FeedState: ObservableObject, StateAccessing {
    private var cancellables = Set<AnyCancellable>()
    private let currentUserId: String
    let memberListState: MemberListState
    private var eventSubscription: StateLayerEventPublisher.Subscription?
    
    init(
        feedQuery: FeedQuery,
        currentUserId: String,
        eventPublisher: StateLayerEventPublisher,
        memberListState: MemberListState
    ) {
        self.currentUserId = currentUserId
        feed = feedQuery.feed
        self.feedQuery = feedQuery
        self.memberListState = memberListState
        subscribe(to: eventPublisher)
        memberListState.$members
            .assign(to: \.members, onWeak: self)
            .store(in: &cancellables)
    }
    
    /// The unique identifier of the feed.
    public let feed: FeedId
    
    /// The query used to create this feed.
    public let feedQuery: FeedQuery
    
    /// The list of activities in the feed, sorted by default sorting criteria.
    @Published public internal(set) var activities = [ActivityData]()
    
    /// The list of aggregated activities in the feed.
    @Published public internal(set) var aggregatedActivities = [AggregatedActivityData]()
    
    /// The feed data containing feed metadata and configuration.
    @Published public internal(set) var feedData: FeedData?
    
    /// The list of followers for this feed.
    @Published public internal(set) var followers = [FollowData]()
    
    /// The list of feeds that this feed is following.
    @Published public internal(set) var following = [FollowData]()
    
    /// The list of pending follow requests for this feed.
    @Published public internal(set) var followRequests = [FollowData]()
    
    /// The list of members in this feed.
    @Published public private(set) var members = [FeedMemberData]()
    
    /// The capabilities that the current user has for this feed.
    @Published public internal(set) var ownCapabilities = Set<FeedOwnCapability>()
    
    /// The list of pinned activities and its pinning state.
    @Published public private(set) var pinnedActivities = [ActivityPinData]()
    
    /// Returns information about the notification status (read / seen activities).
    @Published public private(set) var notificationStatus: NotificationStatusData?
    
    // MARK: - Pagination State
    
    /// Pagination information for activities queries.
    public private(set) var activitiesPagination: PaginationData?
    
    /// Indicates whether there are more activities available to load.
    public var canLoadMoreActivities: Bool { activitiesPagination?.next != nil }
    
    /// The configuration used for the last activities query.
    private(set) var activitiesQueryConfig: QueryConfiguration<ActivitiesFilter, ActivitiesSortField>?
    
    var activitiesSorting: [Sort<ActivitiesSortField>] {
        if let sort = activitiesQueryConfig?.sort, !sort.isEmpty {
            return sort
        }
        return Sort<ActivitiesSortField>.defaultSorting
    }
}

// MARK: - Updating the State

extension FeedState {
    private func subscribe(to publisher: StateLayerEventPublisher) {
        let matchesActivityQuery: @Sendable (ActivityData) -> Bool = { [feedQuery] activity in
            guard let filter = feedQuery.activityFilter else { return true }
            return filter.matches(activity)
        }
        eventSubscription = publisher.subscribe { [weak self, currentUserId, feed, feedQuery] event in
            switch event {
            case .activityAdded(let activityData, let eventFeedId):
                guard feed == eventFeedId else { return }
                guard matchesActivityQuery(activityData) else { return }
                await self?.access { $0.activities.sortedInsert(activityData, sorting: $0.activitiesSorting) }
            case .activityDeleted(let activityId, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.access { state in
                    state.activities.remove(byId: activityId)
                    state.pinnedActivities.removeAll(where: { $0.activity.id == activityId })
                }
            case .activityUpdated(let activityData, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.updateActivity(activityData)
            case .activityBatchUpdate(let updates):
                let added = updates.added.filter { $0.feeds.contains(feed.rawValue) }.filter(matchesActivityQuery)
                let updated = updates.updated.filter { $0.feeds.contains(feed.rawValue) }.filter(matchesActivityQuery)
                let removedIds = updates.removedIds
                guard !added.isEmpty || !updated.isEmpty || !removedIds.isEmpty else { return }
                await self?.access { state in
                    let sorting = state.activitiesSorting
                    if !added.isEmpty {
                        state.activities = state.activities.sortedMerge(added.sorted(by: sorting.areInIncreasingOrder()), sorting: sorting)
                    }
                    if !updated.isEmpty {
                        state.activities = state.activities.sortedMerge(updated.sorted(by: sorting.areInIncreasingOrder()), sorting: sorting)
                    }
                    if !removedIds.isEmpty {
                        state.activities.removeAll(where: { removedIds.contains($0.id) })
                        state.pinnedActivities.removeAll(where: { removedIds.contains($0.activity.id) })
                    }
                }
            case .activityReactionAdded(let reactionData, let activityData, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.access { state in
                    state.activities.sortedUpdate(
                        ofId: activityData.id,
                        nesting: nil,
                        sorting: state.activitiesSorting.areInIncreasingOrder(),
                        changes: { $0.merge(with: activityData, add: reactionData, currentUserId: currentUserId) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.activity.id == activityData.id },
                        changes: { $0.activity.merge(with: activityData, add: reactionData, currentUserId: currentUserId) }
                    )
                }
            case .activityReactionDeleted(let reactionData, let activityData, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.access { state in
                    state.activities.sortedUpdate(
                        ofId: activityData.id,
                        nesting: nil,
                        sorting: state.activitiesSorting.areInIncreasingOrder(),
                        changes: { $0.merge(with: activityData, remove: reactionData, currentUserId: currentUserId) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.activity.id == activityData.id },
                        changes: { $0.activity.merge(with: activityData, remove: reactionData, currentUserId: currentUserId) }
                    )
                }
            case .activityReactionUpdated(let reactionData, let activityData, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.access { state in
                    state.activities.sortedUpdate(
                        ofId: activityData.id,
                        nesting: nil,
                        sorting: state.activitiesSorting.areInIncreasingOrder(),
                        changes: { $0.merge(with: activityData, update: reactionData, currentUserId: currentUserId) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.activity.id == activityData.id },
                        changes: { $0.activity.merge(with: activityData, update: reactionData, currentUserId: currentUserId) }
                    )
                }
            case .activityPinned(let pinData, let eventFeedId):
                guard feed == eventFeedId else { return }
                if let filter = feedQuery.activityFilter, !filter.matches(pinData.activity) {
                    return
                }
                await self?.access { $0.pinnedActivities.insert(byId: pinData) }
            case .activityUnpinned(let pinData, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.access { $0.pinnedActivities.remove(byId: pinData.id) }
            case .activityMarked(let markData, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.access { state in
                    if markData.markAllRead {
                        let readActivityIds = Set(state.aggregatedActivities.map(\.activities).flatMap(\.self).map(\.id))
                        state.notificationStatus?.setAllRead(readActivityIds)
                    } else {
                        state.notificationStatus?.addReadActivities(markData.markRead)
                    }
                }
            case .bookmarkAdded(let bookmarkData):
                await self?.access { state in
                    state.activities.sortedUpdate(
                        ofId: bookmarkData.activity.id,
                        nesting: nil,
                        sorting: state.activitiesSorting.areInIncreasingOrder(),
                        changes: { $0.merge(with: bookmarkData.activity, add: bookmarkData, currentUserId: currentUserId) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.id == bookmarkData.activity.id },
                        changes: { $0.activity.merge(with: bookmarkData.activity, add: bookmarkData, currentUserId: currentUserId) }
                    )
                }
            case .bookmarkDeleted(let bookmarkData):
                await self?.access { state in
                    state.activities.sortedUpdate(
                        ofId: bookmarkData.activity.id,
                        nesting: nil,
                        sorting: state.activitiesSorting.areInIncreasingOrder(),
                        changes: { $0.merge(with: bookmarkData.activity, remove: bookmarkData, currentUserId: currentUserId) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.id == bookmarkData.activity.id },
                        changes: { $0.activity.merge(with: bookmarkData.activity, remove: bookmarkData, currentUserId: currentUserId) }
                    )
                }
            case .bookmarkUpdated(let bookmarkData):
                await self?.access { state in
                    state.activities.sortedUpdate(
                        ofId: bookmarkData.activity.id,
                        nesting: nil,
                        sorting: state.activitiesSorting.areInIncreasingOrder(),
                        changes: { $0.merge(with: bookmarkData.activity, update: bookmarkData, currentUserId: currentUserId) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.id == bookmarkData.activity.id },
                        changes: { $0.activity.merge(with: bookmarkData.activity, update: bookmarkData, currentUserId: currentUserId) }
                    )
                }
            case .commentAdded(_, let activityData, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.updateActivity(activityData)
            case .commentDeleted(let commentData, let activityId, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.access { state in
                    state.activities.sortedUpdate(
                        ofId: activityId,
                        nesting: nil,
                        sorting: state.activitiesSorting.areInIncreasingOrder(),
                        changes: { $0.deleteComment(commentData) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.id == activityId },
                        changes: { $0.activity.deleteComment(commentData) }
                    )
                }
            case .commentUpdated(let commentData, let activityId, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.access { state in
                    state.activities.sortedUpdate(
                        ofId: activityId,
                        nesting: nil,
                        sorting: state.activitiesSorting.areInIncreasingOrder(),
                        changes: { $0.updateComment(commentData) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.id == commentData.objectId },
                        changes: { $0.activity.updateComment(commentData) }
                    )
                }
            case .commentReactionAdded(let reactionData, let commentData, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.access { state in
                    state.activities.sortedUpdate(
                        ofId: commentData.objectId,
                        nesting: nil,
                        sorting: state.activitiesSorting.areInIncreasingOrder(),
                        changes: { $0.updateComment(commentData, add: reactionData, currentUserId: currentUserId) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.activity.id == commentData.objectId },
                        changes: { $0.activity.updateComment(commentData, add: reactionData, currentUserId: currentUserId) }
                    )
                }
            case .commentReactionDeleted(let reactionData, let commentData, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.access { state in
                    state.activities.sortedUpdate(
                        ofId: commentData.objectId,
                        nesting: nil,
                        sorting: state.activitiesSorting.areInIncreasingOrder(),
                        changes: { $0.updateComment(commentData, remove: reactionData, currentUserId: currentUserId) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.activity.id == commentData.objectId },
                        changes: { $0.activity.updateComment(commentData, remove: reactionData, currentUserId: currentUserId) }
                    )
                }
            case .commentReactionUpdated(let reactionData, let commentData, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.access { state in
                    state.activities.sortedUpdate(
                        ofId: commentData.objectId,
                        nesting: nil,
                        sorting: state.activitiesSorting.areInIncreasingOrder(),
                        changes: { $0.updateComment(commentData, update: reactionData, currentUserId: currentUserId) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.activity.id == commentData.objectId },
                        changes: { $0.activity.updateComment(commentData, update: reactionData, currentUserId: currentUserId) }
                    )
                }
            case .feedDeleted(let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.access { state in
                    state.activities.removeAll()
                    state.aggregatedActivities.removeAll()
                    state.feedData = nil
                    state.followers.removeAll()
                    state.following.removeAll()
                    state.followRequests.removeAll()
                    state.members.removeAll()
                    state.notificationStatus = nil
                    state.ownCapabilities.removeAll()
                    state.pinnedActivities.removeAll()
                }
            case .feedUpdated(let feedData, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.access { $0.feedData?.merge(with: feedData) }
            case .feedFollowAdded(let followData, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.addFollow(followData)
            case .feedFollowDeleted(let followData, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.removeFollow(followData)
            case .feedFollowUpdated(let followData, let eventFeedId):
                guard feed == eventFeedId else { return }
                await self?.updateFollow(followData)
            case .feedMemberAdded, .feedMemberDeleted, .feedMemberUpdated:
                // Handled by member list
                break
            case .feedOwnCapabilitiesUpdated(let capabilitiesMap):
                await self?.access { state in
                    if let capabilities = capabilitiesMap[feed] {
                        state.feedData?.setOwnCapabilities(capabilities)
                        state.ownCapabilities = capabilities
                    }
                    state.activities.updateAll(
                        where: { capabilitiesMap.contains($0.currentFeed?.feed) },
                        changes: { $0.mergeFeedOwnCapabilities(from: capabilitiesMap) }
                    )
                    state.pinnedActivities.updateAll(
                        where: { capabilitiesMap.contains($0.activity.currentFeed?.feed) },
                        changes: { $0.activity.mergeFeedOwnCapabilities(from: capabilitiesMap) }
                    )
                    state.followers.updateAll(
                        where: { capabilitiesMap.contains($0.sourceFeed.feed) || capabilitiesMap.contains($0.targetFeed.feed) },
                        changes: { $0.mergeFeedOwnCapabilities(from: capabilitiesMap) }
                    )
                    state.following.updateAll(
                        where: { capabilitiesMap.contains($0.sourceFeed.feed) || capabilitiesMap.contains($0.targetFeed.feed) },
                        changes: { $0.mergeFeedOwnCapabilities(from: capabilitiesMap) }
                    )
                    state.followRequests.updateAll(
                        where: { capabilitiesMap.contains($0.sourceFeed.feed) || capabilitiesMap.contains($0.targetFeed.feed) },
                        changes: { $0.mergeFeedOwnCapabilities(from: capabilitiesMap) }
                    )
                }
            case .pollDeleted(let pollId, let eventFeedId):
                guard eventFeedId == feed else { return }
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.poll?.id == pollId },
                        changes: { $0.poll = nil }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.activity.poll?.id == pollId },
                        changes: { $0.activity.poll = nil }
                    )
                }
            case .pollUpdated(let pollData, let eventFeedId):
                guard eventFeedId == feed else { return }
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.poll?.id == pollData.id },
                        changes: { $0.poll?.merge(with: pollData) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.activity.poll?.id == pollData.id },
                        changes: { $0.activity.poll?.merge(with: pollData) }
                    )
                }
            case .pollVoteCasted(let vote, let pollData, let eventFeedId):
                guard eventFeedId == feed else { return }
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.poll?.id == pollData.id },
                        changes: { $0.poll?.merge(with: pollData, add: vote, currentUserId: currentUserId) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.activity.poll?.id == pollData.id },
                        changes: { $0.activity.poll?.merge(with: pollData, add: vote, currentUserId: currentUserId) }
                    )
                }
            case .pollVoteDeleted(let vote, let pollData, let eventFeedId):
                guard eventFeedId == feed else { return }
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.poll?.id == pollData.id },
                        changes: { $0.poll?.merge(with: pollData, remove: vote, currentUserId: currentUserId) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.activity.poll?.id == pollData.id },
                        changes: { $0.activity.poll?.merge(with: pollData, remove: vote, currentUserId: currentUserId) }
                    )
                }
            case .pollVoteChanged(let vote, let pollData, let eventFeedId):
                guard eventFeedId == feed else { return }
                await self?.access { state in
                    state.activities.updateFirstElement(
                        where: { $0.poll?.id == pollData.id },
                        changes: { $0.poll?.merge(with: pollData, change: vote, currentUserId: currentUserId) }
                    )
                    state.pinnedActivities.updateFirstElement(
                        where: { $0.activity.poll?.id == pollData.id },
                        changes: { $0.activity.poll?.merge(with: pollData, change: vote, currentUserId: currentUserId) }
                    )
                }
            default:
                break
            }
        }
    }
    
    private func updateActivity(_ activityData: ActivityData) {
        activities.sortedUpdate(
            ofId: activityData.id,
            nesting: nil,
            sorting: activitiesSorting.areInIncreasingOrder(),
            changes: { $0.merge(with: activityData) }
        )
        pinnedActivities.updateFirstElement(
            where: { $0.activity.id == activityData.id },
            changes: { $0.activity.merge(with: activityData) }
        )
    }
    
    private func addFollow(_ follow: FollowData) {
        if follow.isFollowRequest {
            followRequests.insert(byId: follow)
        } else if follow.isFollowing(feed) {
            following.insert(byId: follow)
        } else if follow.isFollower(of: feed) {
            followers.insert(byId: follow)
            followRequests.remove(byId: follow.id)
        }
    }
    
    private func removeFollow(_ follow: FollowData) {
        following.remove(byId: follow.id)
        followers.remove(byId: follow.id)
        followRequests.remove(byId: follow.id)
    }
    
    private func updateFollow(_ follow: FollowData) {
        // Review: currently simplified
        removeFollow(follow)
        addFollow(follow)
    }
    
    func didQueryFeed(with response: FeedsRepository.GetOrCreateInfo) {
        activities = response.activities.models
        activitiesPagination = response.activities.pagination
        activitiesQueryConfig = response.activitiesQueryConfig
        feedData = response.feed
        followers = response.followers
        following = response.following
        followRequests = response.followRequests
        ownCapabilities = response.ownCapabilities
        pinnedActivities = response.pinnedActivities
        aggregatedActivities = response.aggregatedActivities
        notificationStatus = response.notificationStatus
        
        // Members are managed by the paginatable list
        memberListState.didPaginate(with: response.members, for: .empty)
    }
    
    func didPaginateActivities(
        with response: PaginationResult<ActivityData>,
        for queryConfig: QueryConfiguration<ActivitiesFilter, ActivitiesSortField>
    ) {
        activitiesPagination = response.pagination
        activitiesQueryConfig = queryConfig
        activities = activities.sortedMerge(response.models, sorting: activitiesSorting)
    }
}
