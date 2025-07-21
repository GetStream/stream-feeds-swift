//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension ActivityCommentListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let handlers: ActivityCommentListState.ChangeHandlers
        private let objectId: String
        private let objectType: String
        
        init(objectId: String, objectType: String, subscribing events: WSEventsSubscribing, handlers: ActivityCommentListState.ChangeHandlers) {
            self.handlers = handlers
            self.objectId = objectId
            self.objectType = objectType
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as CommentAddedEvent:
                guard objectId == event.comment.objectId, objectType == event.comment.objectType else { return }
                await handlers.commentAdded(ThreadedCommentData(from: event.comment.toModel()))
            case let event as CommentDeletedEvent:
                guard objectId == event.comment.objectId, objectType == event.comment.objectType else { return }
                await handlers.commentRemoved(event.comment.id)
            case let event as CommentUpdatedEvent:
                guard objectId == event.comment.objectId, objectType == event.comment.objectType else { return }
                await handlers.commentUpdated(event.comment.toModel())
            case let event as CommentReactionAddedEvent:
                guard objectId == event.comment.objectId, objectType == event.comment.objectType else { return }
                await handlers.commentReactionAdded(event.reaction.toModel(), event.comment.id)
            case let event as CommentReactionDeletedEvent:
                guard objectId == event.comment.objectId, objectType == event.comment.objectType else { return }
                await handlers.commentReactionRemoved(event.reaction.toModel(), event.comment.id)
            default:
                break
            }
        }
    }
}
