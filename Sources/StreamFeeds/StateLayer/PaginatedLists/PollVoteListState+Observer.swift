//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension PollVoteListState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let handlers: PollVoteListState.ChangeHandlers
        private let pollId: String
        
        init(pollId: String, subscribing events: WSEventsSubscribing, handlers: PollVoteListState.ChangeHandlers) {
            self.handlers = handlers
            self.pollId = pollId
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as PollVoteChangedFeedEvent:
                guard event.poll.id == pollId else { return }
                await handlers.pollVoteUpdated(event.pollVote.toModel())
            case let event as PollVoteRemovedFeedEvent:
                guard event.poll.id == pollId else { return }
                await handlers.pollVoteRemoved(event.pollVote.id)
            default:
                break
            }
        }
    }
}
