//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension FeedState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let feedId: String
        private let handlers: FeedState.ChangeHandlers
        
        init(feedId: String, subscribing events: WSEventsSubscribing, handlers: FeedState.ChangeHandlers) {
            self.feedId = feedId
            self.handlers = handlers
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) {
            Task { [handlers, feedId] in
                switch event {
                case let event as ActivityAddedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.activityAdded(ActivityData(from: event.activity))
                case let event as ActivityDeletedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.activityDeleted(ActivityData(from: event.activity))
                case let event as ActivityReactionAddedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.reactionAdded(FeedsReactionData(from: event.reaction))
                case let event as ActivityUpdatedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.activityUpdated(ActivityData(from: event.activity))
                case let event as BookmarkAddedEvent:
                    guard event.fid == feedId else { return }
                    // TODO: Verify bookmark response structure
                    guard let bookmark = event.bookmark else { return }
                    await handlers.bookmarkAdded(BookmarkData(from: bookmark))
                case let event as BookmarkDeletedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.bookmarkDeleted(BookmarkData(from: event.bookmark))
                case let event as CommentAddedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.commentAdded(CommentData(from: event.comment))
                case let event as CommentDeletedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.commentDeleted(CommentData(from: event.comment))
                case let event as FeedUpdatedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.feedUpdated(FeedData(from: event.feed))
                case let event as FollowCreatedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.followAdded(FollowData(from: event.follow))
                case let event as FollowDeletedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.followDeleted(FollowData(from: event.follow))
                case let event as FollowUpdatedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.followUpdated(FollowData(from: event.follow))
                default:
                    break
                }
            }
        }
    }
}
