//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension BookmarkFolderListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let handlers: BookmarkFolderListState.ChangeHandlers
        
        init(subscribing events: WSEventsSubscribing, handlers: BookmarkFolderListState.ChangeHandlers) {
            self.handlers = handlers
            // TODO: Any events?
//            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            default:
                break
            }
        }
    }
}
