//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension CommentReactionListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let commentId: String
        private let handlers: CommentReactionListState.ChangeHandlers
        
        init(commentId: String, subscribing events: WSEventsSubscribing, handlers: CommentReactionListState.ChangeHandlers) {
            self.commentId = commentId
            self.handlers = handlers
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as CommentReactionDeletedEvent:
                guard commentId == event.comment.id else { return }
                await handlers.reactionRemoved(event.reaction.toModel())
            default:
                break
            }
        }
    }
}
