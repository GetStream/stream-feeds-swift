//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

/// An observable object representing the current state of a feed.
///
/// This class manages the state of a feed including activities, followers, members, and pagination information.
/// It automatically updates when WebSocket events are received and provides change handlers for state modifications.
@MainActor public class FeedState: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    let memberListState: MemberListState
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    let currentUserId: String
    private var webSocketObserver: WebSocketObserver?
    
    init(feedQuery: FeedQuery, currentUserId: String, events: WSEventsSubscribing, memberListState: MemberListState) {
        fid = feedQuery.fid
        self.feedQuery = feedQuery
        self.memberListState = memberListState
        self.currentUserId = currentUserId
        webSocketObserver = WebSocketObserver(fid: feedQuery.fid, subscribing: events, handlers: changeHandlers)
        memberListState.$members
            .assign(to: \.members, onWeak: self)
            .store(in: &cancellables)
    }
    
    /// The unique identifier of the feed.
    public let fid: FeedId
    
    /// The query used to create this feed.
    public let feedQuery: FeedQuery
    
    /// The list of activities in the feed, sorted by default sorting criteria.
    @Published public internal(set) var activities = [ActivityData]()
    
    /// The list of aggregated activities in the feed.
    @Published public internal(set) var aggregatedActivities = [AggregatedActivityData]()
    
    /// The feed data containing feed metadata and configuration.
    @Published public internal(set) var feed: FeedData?
    
    /// The list of followers for this feed.
    @Published public internal(set) var followers = [FollowData]()
    
    /// The list of feeds that this feed is following.
    @Published public internal(set) var following = [FollowData]()
    
    /// The list of pending follow requests for this feed.
    @Published public internal(set) var followRequests = [FollowData]()
    
    /// The list of members in this feed.
    @Published public private(set) var members = [FeedMemberData]()
    
    /// The capabilities that the current user has for this feed.
    @Published public internal(set) var ownCapabilities = [FeedOwnCapability]()
    
    /// The list of pinned activities and its pinning state.
    @Published public private(set) var pinnedActivities = [ActivityPinData]()
    
    /// Returns information about the notification status (read / seen activities).
    @Published public private(set) var notificationStatus: NotificationStatusResponse?
    
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
    /// Handlers for various state change events.
    ///
    /// These handlers are called when WebSocket events are received and automatically update the state accordingly.
    struct ChangeHandlers {
        let activityAdded: @MainActor (ActivityData) -> Void
        let activityRemoved: @MainActor (ActivityData) -> Void
        let activityUpdated: @MainActor (ActivityData) -> Void
        let activityPinned: @MainActor (ActivityPinData) -> Void
        let activityUnpinned: @MainActor (String) -> Void
        let activityMarked: @MainActor (MarkActivityData) -> Void
        let bookmarkAdded: @MainActor (BookmarkData) -> Void
        let bookmarkRemoved: @MainActor (BookmarkData) -> Void
        let commentAdded: @MainActor (CommentData) -> Void
        let commentRemoved: @MainActor (CommentData) -> Void
        let feedDeleted: @MainActor () -> Void
        let feedUpdated: @MainActor (FeedData) -> Void
        let followAdded: @MainActor (FollowData) -> Void
        let followRemoved: @MainActor (FollowData) -> Void
        let followUpdated: @MainActor (FollowData) -> Void
        let reactionAdded: @MainActor (FeedsReactionData) -> Void
        let reactionRemoved: @MainActor (FeedsReactionData) -> Void
    }
    
    /// Creates the change handlers for state updates.
    ///
    /// - Returns: A ChangeHandlers instance with all the necessary update functions
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            activityAdded: { [weak self] activity in
                guard let sorting = self?.activitiesSorting else { return }
                self?.activities.sortedInsert(activity, using: sorting)
            },
            activityRemoved: { [weak self] activity in
                guard let sorting = self?.activitiesSorting else { return }
                self?.activities.sortedRemove(activity, using: sorting)
            },
            activityUpdated: { [weak self] activity in
                guard let sorting = self?.activitiesSorting else { return }
                self?.activities.sortedInsert(activity, using: sorting)
                self?.pinnedActivities.updateFirstElement(
                    where: { $0.activity.id == activity.id },
                    changes: { $0.activity = activity }
                )
            },
            activityPinned: { [weak self] pinned in
                self?.pinnedActivities.insert(byId: pinned)
            },
            activityUnpinned: { [weak self] activityId in
                guard let index = self?.pinnedActivities.firstIndex(where: { $0.activity.id == activityId }) else { return }
                self?.pinnedActivities.remove(at: index)
            },
            activityMarked: { [weak self] markData in
                if markData.markAllRead == true {
                    let aggregatedActivities = self?.aggregatedActivities ?? []
                    var readIds = [String]()
                    for aggregated in aggregatedActivities {
                        let acitivtyIds = aggregated.activities.map(\.id)
                        readIds.append(contentsOf: acitivtyIds)
                    }
                    self?.notificationStatus = NotificationStatusResponse(
                        lastSeenAt: self?.notificationStatus?.lastSeenAt,
                        readActivities: readIds,
                        unread: 0,
                        unseen: self?.notificationStatus?.unseen ?? 0
                    )
                } else {
                    var readActivities = self?.notificationStatus?.readActivities ?? []
                    if let markRead = markData.markRead {
                        readActivities.append(contentsOf: markRead)
                    }
                    var unreadCount = self?.notificationStatus?.unread ?? 0
                    unreadCount = max(unreadCount - 1, 0)
                    self?.notificationStatus = NotificationStatusResponse(
                        lastSeenAt: self?.notificationStatus?.lastSeenAt,
                        readActivities: readActivities,
                        unread: unreadCount,
                        unseen: self?.notificationStatus?.unseen ?? 0
                    )
                }
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
            feedDeleted: { [weak self] in
                self?.activities.removeAll()
                self?.feed = nil
                self?.followers.removeAll()
                self?.following.removeAll()
                self?.followRequests.removeAll()
                self?.members.removeAll()
                self?.ownCapabilities.removeAll()
                
            },
            feedUpdated: { [weak self] feed in
                self?.feed = feed
            },
            followAdded: { [weak self] follow in
                self?.addFollow(follow)
            },
            followRemoved: { [weak self] follow in
                self?.removeFollow(follow)
            },
            followUpdated: { [weak self] follow in
                self?.updateFollow(follow)
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
    
    func access<T>(_ actions: @MainActor (FeedState) -> T) -> T {
        actions(self)
    }
    
    private func addFollow(_ follow: FollowData) {
        if follow.isFollowRequest {
            followRequests.insert(byId: follow)
        } else if follow.isFollowing(fid) {
            following.insert(byId: follow)
        } else if follow.isFollower(of: fid) {
            followers.insert(byId: follow)
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
        feed = response.feed
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
        activities = activities.sortedMerge(response.models, using: activitiesSorting)
    }
}
