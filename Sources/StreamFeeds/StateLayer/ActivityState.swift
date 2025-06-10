//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public class ActivityState: ObservableObject {
    private(set) lazy var changeHandlers = makeChangeHandlers()
    private var webSocketObserver: WebSocketObserver?
    
    init(activityId: String, feedsId: String, events: WSEventsSubscribing) {
        let webSocketObserver = WebSocketObserver(
            activityId: activityId,
            feedsId: feedsId,
            subscribing: events,
            handlers: changeHandlers
        )
        self.webSocketObserver = webSocketObserver
    }
    
    @Published public private(set) var activity: ActivityData?
    
    @Published public internal(set) var comments = [CommentData]()
    
    @Published public internal(set) var poll: PollData?
}

// MARK: - Updating the State

extension ActivityState {
    struct ChangeHandlers: Sendable {
        let activityUpdated: @MainActor (ActivityData) -> Void
        let commentAdded: @MainActor (CommentData) -> Void
        let commentDeleted: @MainActor (CommentData) -> Void
        let commentUpdated: @MainActor (CommentData) -> Void
        let commentReactionAdded: @MainActor (FeedsReactionData, CommentData) -> Void
        let commentReactionDeleted: @MainActor (FeedsReactionData, CommentData) -> Void
        let pollClosed: @MainActor (PollData) -> Void
        let pollDeleted: @MainActor (PollData) -> Void
        let pollUpdated: @MainActor (PollData) -> Void
        let pollVoteCasted: @MainActor (PollVoteData, PollData) -> Void
        let pollVoteChanged: @MainActor (PollVoteData, PollData) -> Void
        let pollVoteRemoved: @MainActor (PollVoteData, PollData) -> Void
    }
    
    private func makeChangeHandlers() -> ChangeHandlers {
        ChangeHandlers(
            activityUpdated: { [weak self] activity in
                self?.updateActivity(activity)
            },
            commentAdded: { [weak self] comment in
                if let parentId = comment.parentId {
                    // TODO: Deeper nesting
                    self?.updateComment(with: parentId) { parentComment in
                        parentComment.addReply(comment)
                    }
                } else {
                    self?.comments.sortedInsert(comment, using: CommentData.defaultSorting)
                }
            },
            commentDeleted: { [weak self] comment in
                if let parentId = comment.parentId {
                    // TODO: Deeper nesting
                    self?.updateComment(with: parentId) { parentComment in
                        parentComment.removeReply(comment)
                    }
                } else {
                    self?.comments.sortedRemove(comment, using: CommentData.defaultSorting)
                }
            },
            commentUpdated: { [weak self] comment in
                if let parentId = comment.parentId {
                    // TODO: Deeper nesting
                    self?.updateComment(with: parentId) { parentComment in
                        parentComment.replaceReply(comment)
                    }
                } else {
                    self?.comments.sortedReplace(comment, using: CommentData.defaultSorting)
                }
            },
            commentReactionAdded: { [weak self] reaction, comment in
                self?.comments.sortedReplace(comment, using: CommentData.defaultSorting)
            },
            commentReactionDeleted: { [weak self] reaction, comment in
                self?.comments.sortedReplace(comment, using: CommentData.defaultSorting)
            },
            pollClosed: { [weak self] poll in
                guard poll.id == self?.poll?.id else { return }
                self?.poll = poll
            },
            pollDeleted: { [weak self] poll in
                guard poll.id == self?.poll?.id else { return }
                self?.poll = nil
            },
            pollUpdated: { [weak self] poll in
                guard poll.id == self?.poll?.id else { return }
                self?.poll = poll
            },
            pollVoteCasted: { [weak self] pollVote, poll in
                guard poll.id == self?.poll?.id else { return }
                self?.poll = poll
            },
            pollVoteChanged: { [weak self] pollVote, poll in
                guard poll.id == self?.poll?.id else { return }
                self?.poll = poll
            },
            pollVoteRemoved: { [weak self] pollVote, poll in
                guard poll.id == self?.poll?.id else { return }
                self?.poll = poll
            }
        )
    }
    
    private func updateComment(with id: String, changes: (inout CommentData) -> Void) {
        guard let index = comments.firstIndex(where: { $0.id == id }) else { return }
        var comment = comments[index]
        changes(&comment)
        self.comments[index] = comment
    }
    
    func updateActivity(_ activity: ActivityData) {
        self.activity = activity
        self.poll = activity.poll
    }
    
    func update(_ changes: @MainActor (ActivityState) -> Void) {
        changes(self)
    }
    
    func update(with data: CommentsRepository.QueryCommentsData) {
        comments = data.comments.sorted(by: CommentData.defaultSorting)
    }
}
