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
    private var webSocketObserver: WebSocketObserver?
    
    /// Initializes a new FeedState instance.
    ///
    /// - Parameters:
    ///   - feedQuery: The query used to create this feed
    ///   - events: The WebSocket events subscriber for real-time updates
    init(feedQuery: FeedQuery, events: WSEventsSubscribing, memberListState: MemberListState) {
        self.fid = feedQuery.fid
        self.feedQuery = feedQuery
        self.memberListState = memberListState
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
            },
            bookmarkAdded: { [weak self] bookmark in
                self?.updateActivity(with: bookmark.activity.id) { activity in
                    activity.addBookmark(bookmark)
                }
            },
            bookmarkRemoved: { [weak self] bookmark in
                self?.updateActivity(with: bookmark.activity.id) { activity in
                    activity.deleteBookmark(bookmark)
                }
            },
            commentAdded: { [weak self] comment in
                self?.updateActivity(with: comment.objectId) { activity in
                    activity.addComment(comment)
                }
            },
            commentRemoved: { [weak self] comment in
                self?.updateActivity(with: comment.objectId) { activity in
                    activity.deleteComment(comment)
                }
            },
            feedDeleted: { [weak self] in
                self?.activities.removeAll()
                self?.feed = nil
                self?.followers.removeAll()
                self?.followers.removeAll()
                self?.followers.removeAll()
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
                self?.updateActivity(with: reaction.activityId) { activity in
                    activity.addReaction(reaction)
                }
            },
            reactionRemoved: { [weak self] reaction in
                self?.updateActivity(with: reaction.activityId) { activity in
                    activity.removeReaction(reaction)
                }
            }
        )
    }
    
    /// Provides thread-safe access to the state for modifications.
    ///
    /// - Parameter actions: A closure that receives the current state and can modify it
    /// - Returns: The result of the actions closure
    func access<T>(_ actions: @MainActor (FeedState) -> T) -> T {
        actions(self)
    }
        
    /// Updates a specific activity in the activities array.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the activity to update
    ///   - changes: A closure that receives the activity and can modify it
    private func updateActivity(with id: String, changes: (inout ActivityData) -> Void) {
        guard let index = activities.firstIndex(where: { $0.id == id }) else { return }
        var activity = activities[index]
        changes(&activity)
        self.activities[index] = activity
    }
    
    /// Adds a follow to the appropriate collection based on its type.
    ///
    /// - Parameter follow: The follow data to add
    private func addFollow(_ follow: FollowData) {
        if follow.isFollowRequest {
            followRequests.insert(byId: follow)
        } else if follow.isFollowing(fid) {
            following.insert(byId: follow)
        } else if follow.isFollower(of: fid) {
            followers.insert(byId: follow)
        }
    }
    
    /// Removes a follow from all collections.
    ///
    /// - Parameter follow: The follow data to remove
    private func removeFollow(_ follow: FollowData) {
        following.remove(byId: follow.id)
        followers.remove(byId: follow.id)
        followRequests.remove(byId: follow.id)
    }
    
    /// Updates a follow by removing and re-adding it to the appropriate collection.
    ///
    /// - Parameter follow: The follow data to update
    private func updateFollow(_ follow: FollowData) {
        // Review: currently simplified
        removeFollow(follow)
        addFollow(follow)
    }
    
    /// Updates the state with feed query results.
    ///
    /// This method is called when a feed is initially queried or refreshed.
    ///
    /// - Parameter response: The response containing feed data, activities, and other information
    func didQueryFeed(with response: FeedsRepository.GetOrCreateInfo) {
        activities = response.activities.models
        activitiesPagination = response.activities.pagination
        activitiesQueryConfig = response.activitiesQueryConfig
        feed = response.feed
        followers = response.followers
        following = response.following
        followRequests = response.followRequests
        ownCapabilities = response.ownCapabilities
        
        // Members are managed by the paginatable list
        memberListState.didPaginate(with: response.members, for: .empty)
    }
    
    /// Updates the state with paginated activities results.
    ///
    /// This method is called when additional activities are loaded through pagination.
    ///
    /// - Parameters:
    ///   - response: The pagination response containing new activities
    ///   - queryConfig: The query configuration used for this pagination request
    func didPaginateActivities(
        with response: PaginationResult<ActivityData>,
        for queryConfig: QueryConfiguration<ActivitiesFilter, ActivitiesSortField>
    ) {
        activitiesPagination = response.pagination
        activitiesQueryConfig = queryConfig
        activities = activities.sortedMerge(response.models, using: activitiesSorting)
    }
}
