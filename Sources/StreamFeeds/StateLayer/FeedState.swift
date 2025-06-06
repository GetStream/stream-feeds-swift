//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation

@MainActor public class FeedState: ObservableObject {
    private let webSocketObserver: WebSocketObserver
    private(set) lazy var changeHandlers = makeChangeHandlers()
    
    init(feedId: String, events: WSEventsSubscribing) {
        self.feedId = feedId
        webSocketObserver = WebSocketObserver(feedId: feedId)
        webSocketObserver.startObserving(events, handlers: changeHandlers)
    }
    
    public let feedId: String
    
    @Published public internal(set) var activities = [ActivityInfo]()
    @Published public internal(set) var feed: FeedInfo?
    @Published public internal(set) var followers = [FollowInfo]()
    @Published public internal(set) var following = [FollowInfo]()
    @Published public internal(set) var followRequests = [FollowInfo]()
    @Published public internal(set) var members = [FeedMemberResponse]()
    @Published public internal(set) var ownCapabilities = [OwnCapability]()
}

// MARK: - Updating the State

extension FeedState {
    struct ChangeHandlers {
        let activityAdded: @MainActor (ActivityInfo) -> Void
        let activityDeleted: @MainActor (ActivityInfo) -> Void
        let activityUpdated: @MainActor (ActivityInfo) -> Void
        let bookmarkAdded: @MainActor (BookmarkInfo) -> Void
        let bookmarkDeleted: @MainActor (BookmarkInfo) -> Void
        let commentAdded: @MainActor (CommentInfo) -> Void
        let commentDeleted: @MainActor (CommentInfo) -> Void
        let feedUpdated: @MainActor (FeedInfo) -> Void
        let followAdded: @MainActor (FollowInfo) -> Void
        let followDeleted: @MainActor (FollowInfo) -> Void
        let followUpdated: @MainActor (FollowInfo) -> Void
        let reactionAdded: @MainActor (ActivityReactionInfo) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        return ChangeHandlers(
            activityAdded: { [weak self] activity in
                self?.activities.sortedInsert(activity, using: ActivityInfo.defaultSorting)
            },
            activityDeleted: { [weak self] activity in
                self?.activities.sortedRemove(activity, using: ActivityInfo.defaultSorting)
            },
            activityUpdated: { [weak self] activity in
                self?.activities.sortedInsert(activity, using: ActivityInfo.defaultSorting)
            },
            bookmarkAdded: { [weak self] bookmark in
                self?.updateActivity(with: bookmark.activityId) { activity in
                    activity.addBookmark(bookmark)
                }
            },
            bookmarkDeleted: { [weak self] bookmark in
                self?.updateActivity(with: bookmark.activityId) { activity in
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
        
    private func updateActivity(with id: String, changes: (inout ActivityInfo) -> Void) {
        guard let index = activities.firstIndex(where: { $0.id == id }) else { return }
        var activity = activities[index]
        changes(&activity)
        self.activities[index] = activity
    }
    
    private func addFollow(_ follow: FollowInfo) {
        if follow.isFollowRequest {
            followRequests.insert(byId: follow)
        } else if follow.isFollowing(feedId: feedId) {
            following.insert(byId: follow)
        } else if follow.isFollower(of: feedId) {
            followers.insert(byId: follow)
        }
    }
    
    private func removeFollow(_ follow: FollowInfo) {
        following.remove(byId: follow)
        followers.remove(byId: follow)
        followRequests.remove(byId: follow)
    }
    
    private func updateFollow(_ follow: FollowInfo) {
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
