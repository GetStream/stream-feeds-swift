//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension CommentReplyListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let handlers: CommentReplyListState.ChangeHandlers
        private let parentId: String
        
        init(parentId: String, subscribing events: WSEventsSubscribing, handlers: CommentReplyListState.ChangeHandlers) {
            self.handlers = handlers
            self.parentId = parentId
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as CommentUpdatedEvent:
                guard parentId == event.comment.parentId else { return }
                await handlers.commentUpdated(event.comment.toModel())
            default:
                break
            }
        }
    }
}
