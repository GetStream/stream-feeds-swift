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
        
        func onEvent(_ event: any Event) {
            Task { [handlers, fid] in
                switch event {
                case let event as CommentAddedEvent:
                    guard event.fid == fid else { return }
                    await handlers.commentAdded(event.comment.toModel())
                case let event as CommentDeletedEvent:
                    guard event.fid == fid else { return }
                    await handlers.commentRemoved(event.comment.toModel())
                case let event as CommentUpdatedEvent:
                    guard event.fid == fid else { return }
                    await handlers.commentUpdated(event.comment.toModel())
                case let event as CommentReactionAddedEvent:
                    guard event.fid == fid else { return }
                    let comment = event.comment.toModel()
                    let reaction = event.reaction.toModel()
                    await handlers.commentReactionAdded(reaction, comment)
                case let event as CommentReactionDeletedEvent:
                    guard event.fid == fid else { return }
                    let comment = event.comment.toModel()
                    let reaction = event.reaction.toModel()
                    await handlers.commentReactionRemoved(reaction, comment)
                case let event as PollClosedFeedEvent:
                    await handlers.pollClosed(event.poll.toModel())
                case let event as PollDeletedFeedEvent:
                    await handlers.pollDeleted(event.poll.id)
                case let event as PollUpdatedFeedEvent:
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
