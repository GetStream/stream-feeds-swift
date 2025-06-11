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
                    await handlers.commentAdded(event.comment.toModel())
                case let event as CommentDeletedEvent:
                    guard event.fid == feedsId else { return }
                    await handlers.commentDeleted(event.comment.toModel())
                case let event as CommentUpdatedEvent:
                    guard event.fid == feedsId else { return }
                    await handlers.commentUpdated(event.comment.toModel())
                case let event as CommentReactionAddedEvent:
                    guard event.fid == feedsId else { return }
                    let comment = event.comment.toModel()
                    let reaction = event.reaction.toModel()
                    await handlers.commentReactionAdded(reaction, comment)
                case let event as CommentReactionDeletedEvent:
                    guard event.fid == feedsId else { return }
                    let comment = event.comment.toModel()
                    let reaction = event.reaction.toModel()
                    await handlers.commentReactionDeleted(reaction, comment)
                case let event as PollClosedEvent:
                    await handlers.pollClosed(event.poll.toModel())
                case let event as PollDeletedEvent:
                    await handlers.pollDeleted(event.poll.toModel())
                case let event as PollUpdatedEvent:
                    await handlers.pollUpdated(event.poll.toModel())
                case let event as PollVoteCastedFeedEvent:
                    let poll = event.poll.toModel()
                    let vote = event.pollVote.toModel()
                    await handlers.pollVoteCasted(vote, poll)
                case let event as PollVoteChangedFeedEvent:
                    let poll = event.poll.toModel()
                    let vote = event.pollVote.toModel()
                    await handlers.pollVoteChanged(vote, poll)
                case let event as PollVoteRemovedFeedEvent:
                    let poll = event.poll.toModel()
                    let vote = event.pollVote.toModel()
                    await handlers.pollVoteRemoved(vote, poll)
                default:
                    break
                }
            }
        }
    }
}
