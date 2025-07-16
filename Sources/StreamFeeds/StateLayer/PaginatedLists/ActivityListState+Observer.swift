//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension ActivityListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let handlers: ActivityListState.ChangeHandlers
        
        init(subscribing events: WSEventsSubscribing, handlers: ActivityListState.ChangeHandlers) {
            self.handlers = handlers
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as ActivityDeletedEvent:
                await handlers.activityRemoved(event.activity.toModel())
            case let event as ActivityReactionAddedEvent:
                await handlers.reactionAdded(event.reaction.toModel())
            case let event as ActivityReactionDeletedEvent:
                await handlers.reactionRemoved(event.reaction.toModel())
            case let event as BookmarkAddedEvent:
                await handlers.bookmarkAdded(event.bookmark.toModel())
            case let event as BookmarkDeletedEvent:
                await handlers.bookmarkRemoved(event.bookmark.toModel())
            case let event as CommentAddedEvent:
                await handlers.commentAdded(event.comment.toModel())
            case let event as CommentDeletedEvent:
                await handlers.commentRemoved(event.comment.toModel())
            default:
                break
            }
        }
    }
}
