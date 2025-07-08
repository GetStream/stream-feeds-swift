//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension FeedListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let handlers: FeedListState.ChangeHandlers
        
        init(subscribing events: WSEventsSubscribing, handlers: FeedListState.ChangeHandlers) {
            self.handlers = handlers
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as FeedUpdatedEvent:
                await handlers.feedUpdated(event.feed.toModel())
            default:
                break
            }
        }
    }
}
