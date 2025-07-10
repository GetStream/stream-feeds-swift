//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension ActivityReactionListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let activityId: String
        private let handlers: ActivityReactionListState.ChangeHandlers
        
        init(activityId: String, subscribing events: WSEventsSubscribing, handlers: ActivityReactionListState.ChangeHandlers) {
            self.activityId = activityId
            self.handlers = handlers
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as ActivityReactionDeletedEvent:
                guard activityId == event.activity.id else { return }
                await handlers.reactionRemoved(event.reaction.toModel())
            default:
                break
            }
        }
    }
} 
