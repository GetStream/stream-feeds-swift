//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

extension ActivityState {
    final class WebSocketObserver: WSEventsSubscriber {
        private let activityId: String
        private let feedsId: String
        private let handlers: ActivityState.ChangeHandlers
        
        init(
            activityId: String,
            feedsId: String,
            subscribing events: WSEventsSubscribing,
            handlers: ActivityState.ChangeHandlers
        ) {
            self.activityId = activityId
            self.feedsId = feedsId
            self.handlers = handlers
            events.add(subscriber: self)
        }
        
        // MARK: - Event Subscription
        
        func onEvent(_ event: any Event) {
            Task { [handlers, feedsId] in
                switch event {
                case let event as CommentAddedEvent:
                    guard event.fid == feedsId else { return }
                    await handlers.commentAdded(CommentData(from: event.comment))
                case let event as CommentDeletedEvent:
                    guard event.fid == feedsId else { return }
                    await handlers.commentDeleted(CommentData(from: event.comment))
                case let event as CommentUpdatedEvent:
                    guard event.fid == feedsId else { return }
                    await handlers.commentUpdated(CommentData(from: event.comment))
                case let event as CommentReactionAddedEvent:
                    guard event.fid == feedsId else { return }
                    let comment = CommentData(from: event.comment)
                    let reaction = FeedsReactionData(from: event.reaction)
                    await handlers.commentReactionAdded(reaction, comment)
                case let event as CommentReactionDeletedEvent:
                    guard event.fid == feedsId else { return }
                    let comment = CommentData(from: event.comment)
                    let reaction = FeedsReactionData(from: event.reaction)
                    await handlers.commentReactionDeleted(reaction, comment)
                case let event as PollClosedEvent:
                    await handlers.pollClosed(PollData(from: event.poll))
                case let event as PollDeletedEvent:
                    await handlers.pollDeleted(PollData(from: event.poll))
                case let event as PollUpdatedEvent:
                    await handlers.pollUpdated(PollData(from: event.poll))
                case let event as PollVoteCastedEvent:
                    let poll = PollData(from: event.poll)
                    let vote = PollVoteData(from: event.pollVote)
                    await handlers.pollVoteCasted(vote, poll)
                case let event as PollVoteChangedEvent:
                    let poll = PollData(from: event.poll)
                    let vote = PollVoteData(from: event.pollVote)
                    await handlers.pollVoteChanged(vote, poll)
                case let event as PollVoteRemovedEvent:
                    let poll = PollData(from: event.poll)
                    let vote = PollVoteData(from: event.pollVote)
                    await handlers.pollVoteRemoved(vote, poll)
                default:
                    break
                }
            }
        }
    }
}
