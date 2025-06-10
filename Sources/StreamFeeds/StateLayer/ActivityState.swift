//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

@MainActor public class ActivityState: ObservableObject {
    private(set) lazy var changeHandlers = makeChangeHandlers()
    private let webSocketObserver: WebSocketObserver
    
    init(activityId: String, feedsId: String, events: WSEventsSubscribing) {
        webSocketObserver = WebSocketObserver(activityId: activityId, feedsId: feedsId)
        webSocketObserver.startObserving(events, handlers: changeHandlers)
    }
    
    @Published public private(set) var activity: ActivityInfo?
    
    @Published public internal(set) var comments = [CommentInfo]()
    
    @Published public internal(set) var poll: PollInfo?
}

// MARK: - Updating the State

extension ActivityState {
    struct ChangeHandlers {
        let activityUpdated: @MainActor (ActivityInfo) -> Void
        let commentAdded: @MainActor (CommentInfo) -> Void
        let commentDeleted: @MainActor (CommentInfo) -> Void
        let commentUpdated: @MainActor (CommentInfo) -> Void
        let commentReactionAdded: @MainActor (FeedsReactionInfo, CommentInfo) -> Void
        let commentReactionDeleted: @MainActor (FeedsReactionInfo, CommentInfo) -> Void
        let pollClosed: @MainActor (PollInfo) -> Void
        let pollDeleted: @MainActor (PollInfo) -> Void
        let pollUpdated: @MainActor (PollInfo) -> Void
        let pollVoteCasted: @MainActor (PollVoteInfo, PollInfo) -> Void
        let pollVoteChanged: @MainActor (PollVoteInfo, PollInfo) -> Void
        let pollVoteRemoved: @MainActor (PollVoteInfo, PollInfo) -> Void
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
                    self?.comments.sortedInsert(comment, using: CommentInfo.defaultSorting)
                }
            },
            commentDeleted: { [weak self] comment in
                if let parentId = comment.parentId {
                    // TODO: Deeper nesting
                    self?.updateComment(with: parentId) { parentComment in
                        parentComment.removeReply(comment)
                    }
                } else {
                    self?.comments.sortedRemove(comment, using: CommentInfo.defaultSorting)
                }
            },
            commentUpdated: { [weak self] comment in
                if let parentId = comment.parentId {
                    // TODO: Deeper nesting
                    self?.updateComment(with: parentId) { parentComment in
                        parentComment.replaceReply(comment)
                    }
                } else {
                    self?.comments.sortedReplace(comment, using: CommentInfo.defaultSorting)
                }
            },
            commentReactionAdded: { [weak self] reaction, comment in
                self?.comments.sortedReplace(comment, using: CommentInfo.defaultSorting)
            },
            commentReactionDeleted: { [weak self] reaction, comment in
                self?.comments.sortedReplace(comment, using: CommentInfo.defaultSorting)
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
    
    private func updateComment(with id: String, changes: (inout CommentInfo) -> Void) {
        guard let index = comments.firstIndex(where: { $0.id == id }) else { return }
        var comment = comments[index]
        changes(&comment)
        self.comments[index] = comment
    }
    
    func updateActivity(_ activity: ActivityInfo) {
        self.activity = activity
        self.poll = activity.poll
    }
    
    func update(_ changes: @MainActor (ActivityState) -> Void) {
        changes(self)
    }
    
    func update(with data: CommentsRepository.QueryCommentsData) {
        comments = data.comments.sorted(by: CommentInfo.defaultSorting)
    }
}
