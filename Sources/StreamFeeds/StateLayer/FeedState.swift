//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation

@MainActor public class FeedState: ObservableObject {
    private var webSocketObserver: WebSocketObserver?
    lazy var changeHandlers: ChangeHandlers = makeChangeHandlers()
    
    init(feedId: String, events: WSEventsSubscribing) {
        self.feedId = feedId
        webSocketObserver = WebSocketObserver(feedId: feedId, subscribing: events, handlers: makeChangeHandlers())
    }
    
    public let feedId: String
    
    @Published public internal(set) var activities = [ActivityData]()
    @Published public internal(set) var feed: FeedData?
    @Published public internal(set) var followers = [FollowData]()
    @Published public internal(set) var following = [FollowData]()
    @Published public internal(set) var followRequests = [FollowData]()
    @Published public internal(set) var members = [FeedMemberData]()
    @Published public internal(set) var ownCapabilities = [FeedOwnCapability]()
}

// MARK: - Updating the State

extension FeedState {
    struct ChangeHandlers {
        let activityAdded: @MainActor (ActivityData) -> Void
        let activityDeleted: @MainActor (ActivityData) -> Void
        let activityUpdated: @MainActor (ActivityData) -> Void
        let bookmarkAdded: @MainActor (BookmarkData) -> Void
        let bookmarkDeleted: @MainActor (BookmarkData) -> Void
        let commentAdded: @MainActor (CommentData) -> Void
        let commentDeleted: @MainActor (CommentData) -> Void
        let feedUpdated: @MainActor (FeedData) -> Void
        let followAdded: @MainActor (FollowData) -> Void
        let followDeleted: @MainActor (FollowData) -> Void
        let followUpdated: @MainActor (FollowData) -> Void
        let reactionAdded: @MainActor (FeedsReactionData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        return ChangeHandlers(
            activityAdded: { [weak self] activity in
                self?.activities.sortedInsert(activity, using: ActivityData.defaultSorting)
            },
            activityDeleted: { [weak self] activity in
                self?.activities.sortedRemove(activity, using: ActivityData.defaultSorting)
            },
            activityUpdated: { [weak self] activity in
                self?.activities.sortedInsert(activity, using: ActivityData.defaultSorting)
            },
            bookmarkAdded: { [weak self] bookmark in
                self?.updateActivity(with: bookmark.activity.id) { activity in
                    activity.addBookmark(bookmark)
                }
            },
            bookmarkDeleted: { [weak self] bookmark in
                self?.updateActivity(with: bookmark.activity.id) { activity in
                    activity.deleteBookmark(bookmark)
                }
            },
            commentAdded: { [weak self] comment in
                self?.updateActivity(with: comment.objectId) { activity in
                    activity.addComment(comment)
                }
            },
            commentDeleted: { [weak self] comment in
                self?.updateActivity(with: comment.objectId) { activity in
                    activity.deleteComment(comment)
                }
            },
            feedUpdated: { [weak self] feed in
                self?.feed = feed
            },
            followAdded: { [weak self] follow in
                self?.addFollow(follow)
            },
            followDeleted: { [weak self] follow in
                self?.removeFollow(follow)
            },
            followUpdated: { [weak self] follow in
                self?.updateFollow(follow)
            },
            reactionAdded: { [weak self] reaction in
                self?.updateActivity(with: reaction.activityId) { activity in
                    activity.addReaction(reaction)
                }
            }
        )
    }
    
    func update(_ changes: @MainActor (FeedState) -> Void) {
        changes(self)
    }
        
    private func updateActivity(with id: String, changes: (inout ActivityData) -> Void) {
        guard let index = activities.firstIndex(where: { $0.id == id }) else { return }
        var activity = activities[index]
        changes(&activity)
        self.activities[index] = activity
    }
    
    private func addFollow(_ follow: FollowData) {
        if follow.isFollowRequest {
            followRequests.insert(byId: follow)
        } else if follow.isFollowing(feedId: feedId) {
            following.insert(byId: follow)
        } else if follow.isFollower(of: feedId) {
            followers.insert(byId: follow)
        }
    }
    
    private func removeFollow(_ follow: FollowData) {
        following.remove(byId: follow)
        followers.remove(byId: follow)
        followRequests.remove(byId: follow)
    }
    
    private func updateFollow(_ follow: FollowData) {
        // Review: currently simplified
        removeFollow(follow)
        addFollow(follow)
    }
    
    func update(with data: FeedsRepository.GetOrCreateInfo) {
        activities = data.activities
        feed = data.feed
        followers = data.followers
        following = data.following
        followRequests = data.followRequests
        members = data.members
        ownCapabilities = data.ownCapabilities
    }
}

extension ActivityResponse: Identifiable {}
