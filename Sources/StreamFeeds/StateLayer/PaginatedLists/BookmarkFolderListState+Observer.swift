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
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as BookmarkFolderDeletedEvent:
                await handlers.bookmarkFolderRemoved(event.bookmarkFolder.id)
            case let event as BookmarkFolderUpdatedEvent:
                await handlers.bookmarkFolderUpdated(event.bookmarkFolder.toModel())
            default:
                break
            }
        }
    }
}
