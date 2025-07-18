//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension ActivityState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let activityId: String
        private let fid: String
        private let handlers: ActivityState.ChangeHandlers
        
        init(
            activityId: String,
            fid: FeedId,
            subscribing events: WSEventsSubscribing,
            handlers: ActivityState.ChangeHandlers
        ) {
            self.activityId = activityId
            self.fid = fid.rawValue
            self.handlers = handlers
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) async {
            switch event {
            case let event as PollClosedFeedEvent:
                guard fid == event.fid else { return }
                await handlers.pollClosed(event.poll.toModel())
            case let event as PollDeletedFeedEvent:
                guard fid == event.fid else { return }
                await handlers.pollDeleted(event.poll.id)
            case let event as PollUpdatedFeedEvent:
                guard fid == event.fid else { return }
                await handlers.pollUpdated(event.poll.toModel())
            case let event as PollVoteCastedFeedEvent:
                guard fid == event.fid else { return }
                let poll = event.poll.toModel()
                let vote = event.pollVote.toModel()
                await handlers.pollVoteCasted(vote, poll)
            case let event as PollVoteChangedFeedEvent:
                guard fid == event.fid else { return }
                let poll = event.poll.toModel()
                let vote = event.pollVote.toModel()
                await handlers.pollVoteChanged(vote, poll)
            case let event as PollVoteRemovedFeedEvent:
                guard fid == event.fid else { return }
                let poll = event.poll.toModel()
                let vote = event.pollVote.toModel()
                await handlers.pollVoteRemoved(vote, poll)
            default:
                break
            }
        }
    }
}
