//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension PollVoteListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let handlers: PollVoteListState.ChangeHandlers
        
        init(subscribing events: WSEventsSubscribing, handlers: PollVoteListState.ChangeHandlers) {
            self.handlers = handlers
            // TODO: Review events
            // events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            Task {
                switch event {
                default:
                    break
                }
            }
        }
    }
} 
