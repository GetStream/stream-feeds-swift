//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension FeedState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let feedId: String
        
        init(feedId: String) {
            self.feedId = feedId
        }
        
        private var handlers: FeedState.ChangeHandlers?
        
        @MainActor func startObserving(_ events: WSEventsSubscribing, handlers: FeedState.ChangeHandlers) {
            self.handlers = handlers
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) {
            Task {
                guard let handlers else { return }
                switch event {
                case let event as ActivityAddedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.activityAdded(ActivityInfo(from: event.activity))
                case let event as ActivityDeletedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.activityDeleted(ActivityInfo(from: event.activity))
                case let event as ActivityReactionAddedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.reactionAdded(ActivityReactionInfo(from: event.reaction))
                case let event as ActivityUpdatedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.activityUpdated(ActivityInfo(from: event.activity))
                case let event as BookmarkAddedEvent:
                    guard event.fid == feedId else { return }
                    // TODO: Verify bookmark response structure
                    guard let bookmark = event.bookmark else { return }
                    await handlers.bookmarkAdded(BookmarkInfo(from: bookmark))
                case let event as BookmarkDeletedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.bookmarkDeleted(BookmarkInfo(from: event.bookmark))
                case let event as CommentAddedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.commentAdded(CommentInfo(from: event.comment))
                case let event as CommentDeletedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.commentDeleted(CommentInfo(from: event.comment))
                case let event as FollowCreatedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.followAdded(FollowInfo(from: event.follow))
                case let event as FollowDeletedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.followDeleted(FollowInfo(from: event.follow))
                case let event as FollowUpdatedEvent:
                    guard event.fid == feedId else { return }
                    await handlers.followUpdated(FollowInfo(from: event.follow))
                default:
                    break
                }
            }
        }
    }
}
