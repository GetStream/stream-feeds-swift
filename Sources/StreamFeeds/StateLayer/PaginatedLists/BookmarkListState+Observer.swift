//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension BookmarkListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let handlers: BookmarkListState.ChangeHandlers
        
        init(subscribing events: WSEventsSubscribing, handlers: BookmarkListState.ChangeHandlers) {
            self.handlers = handlers
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as BookmarkUpdatedEvent:
                await handlers.bookmarkUpdated(event.bookmark.toModel())
            default:
                break
            }
        }
    }
}
