//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension PollListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let handlers: PollListState.ChangeHandlers
        
        init(subscribing events: WSEventsSubscribing, handlers: PollListState.ChangeHandlers) {
            self.handlers = handlers
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as PollUpdatedFeedEvent:
                await handlers.pollUpdated(event.poll.toModel())
            default:
                break
            }
        }
    }
} 
