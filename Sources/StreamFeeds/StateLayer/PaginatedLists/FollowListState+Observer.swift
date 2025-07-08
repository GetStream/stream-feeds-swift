//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension FollowListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let handlers: FollowListState.ChangeHandlers
        
        init(subscribing events: WSEventsSubscribing, handlers: FollowListState.ChangeHandlers) {
            self.handlers = handlers
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as FollowUpdatedEvent:
                await handlers.followUpdated(event.follow.toModel())
            default:
                break
            }
        }
    }
}
