//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension CommentListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let handlers: CommentListState.ChangeHandlers
        
        init(subscribing events: WSEventsSubscribing, handlers: CommentListState.ChangeHandlers) {
            self.handlers = handlers
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) {
            Task { [handlers] in
                switch event {
                case let event as CommentUpdatedEvent:
                    await handlers.commentUpdated(event.comment.toModel())
                default:
                    break
                }
            }
        }
    }
} 
