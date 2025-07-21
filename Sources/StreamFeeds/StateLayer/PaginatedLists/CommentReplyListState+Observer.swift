//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension CommentReplyListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let handlers: CommentReplyListState.ChangeHandlers
        private let parentId: String
        
        init(
            parentId: String,
            subscribing events: WSEventsSubscribing,
            handlers: CommentReplyListState.ChangeHandlers
        ) {
            self.handlers = handlers
            self.parentId = parentId
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as CommentAddedEvent:
                await handlers.commentAdded(ThreadedCommentData(from: event.comment.toModel()))
            case let event as CommentDeletedEvent:
                await handlers.commentRemoved(event.comment.id)
            case let event as CommentUpdatedEvent:
                await handlers.commentUpdated(event.comment.toModel())
            case let event as CommentReactionAddedEvent:
                await handlers.commentReactionAdded(event.reaction.toModel(), event.comment.id)
            case let event as CommentReactionDeletedEvent:
                await handlers.commentReactionRemoved(event.reaction.toModel(), event.comment.id)
            default:
                break
            }
        }
    }
}
