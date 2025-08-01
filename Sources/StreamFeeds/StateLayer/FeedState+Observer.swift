//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension FeedState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let fid: String
        private let handlers: FeedState.ChangeHandlers
        
        init(fid: FeedId, subscribing events: WSEventsSubscribing, handlers: FeedState.ChangeHandlers) {
            self.fid = fid.rawValue
            self.handlers = handlers
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as ActivityAddedEvent:
                guard event.fid == fid else { return }
                // Remove after FEEDS-546
                let activity = event.activity
                if event.activity.createdAt < Date(timeIntervalSinceReferenceDate: 0) {
                    activity.createdAt = event.createdAt
                }
                await handlers.activityAdded(activity.toModel())
            case let event as ActivityDeletedEvent:
                guard event.fid == fid else { return }
                await handlers.activityRemoved(event.activity.toModel())
            case let event as ActivityReactionAddedEvent:
                guard event.fid == fid else { return }
                await handlers.reactionAdded(event.reaction.toModel())
            case let event as ActivityReactionDeletedEvent:
                guard event.fid == fid else { return }
                await handlers.reactionRemoved(event.reaction.toModel())
            case let event as ActivityUpdatedEvent:
                guard event.fid == fid else { return }
                await handlers.activityUpdated(event.activity.toModel())
            case let event as ActivityPinnedEvent:
                guard event.fid == fid else { return }
                await handlers.activityPinned(event.pinnedActivity.toModel())
            case let event as ActivityUnpinnedEvent:
                guard event.fid == fid else { return }
                await handlers.activityUnpinned(event.pinnedActivity.activity.id)
            case let event as ActivityMarkEvent:
                guard event.fid == fid else { return }
                await handlers.activityMarked(event.toModel())
            case let event as BookmarkAddedEvent:
                guard event.bookmark.activity.feeds.contains(fid) else { return }
                await handlers.bookmarkAdded(event.bookmark.toModel())
            case let event as BookmarkDeletedEvent:
                guard event.bookmark.activity.feeds.contains(fid) else { return }
                await handlers.bookmarkRemoved(event.bookmark.toModel())
            case let event as CommentAddedEvent:
                guard event.fid == fid else { return }
                await handlers.commentAdded(event.comment.toModel())
            case let event as CommentDeletedEvent:
                guard event.fid == fid else { return }
                await handlers.commentRemoved(event.comment.toModel())
            case let event as FeedDeletedEvent:
                guard event.fid == fid else { return }
                await handlers.feedDeleted()
            case let event as FeedUpdatedEvent:
                guard event.fid == fid else { return }
                await handlers.feedUpdated(event.feed.toModel())
            case let event as FollowCreatedEvent:
                guard event.fid == fid else { return }
                await handlers.followAdded(event.follow.toModel())
            case let event as FollowDeletedEvent:
                guard event.fid == fid else { return }
                await handlers.followRemoved(event.follow.toModel())
            case let event as FollowUpdatedEvent:
                guard event.fid == fid else { return }
                await handlers.followUpdated(event.follow.toModel())
            case is FeedMemberRemovedEvent:
                break // handled by MemberListState
            case is FeedMemberUpdatedEvent:
                break // handled by MemberListState
            default:
                break
            }
        }
    }
}
