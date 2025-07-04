//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore

/// An observable object representing the current state of an activity.
///
/// This class manages the state of a single activity including its comments, poll data, and real-time updates.
/// It automatically updates when WebSocket events are received and provides change handlers for state modifications.
@MainActor public class ActivityState: ObservableObject {
    private(set) lazy var changeHandlers = makeChangeHandlers()
    private var webSocketObserver: WebSocketObserver?
    
    /// Initializes a new ActivityState instance.
    ///
    /// - Parameters:
    ///   - activityId: The unique identifier of the activity
    ///   - fid: The identifier of the feed containing this activity
    ///   - events: The WebSocket events subscriber for real-time updates
    init(activityId: String, fid: FeedId, events: WSEventsSubscribing) {
        let webSocketObserver = WebSocketObserver(
            activityId: activityId,
            fid: fid,
            subscribing: events,
            handlers: changeHandlers
        )
        self.webSocketObserver = webSocketObserver
    }
    
    /// The current activity data.
    @Published public private(set) var activity: ActivityData?
    
    /// The list of comments for this activity, sorted by default sorting criteria.
    @Published public internal(set) var comments = [CommentData]()
    
    /// The poll data associated with this activity, if any.
    @Published public internal(set) var poll: PollData?
}

// MARK: - Updating the State

extension ActivityState {
    /// Handlers for various activity state change events.
    ///
    /// These handlers are called when WebSocket events are received and automatically update the state accordingly.
    struct ChangeHandlers: Sendable {
        let activityUpdated: @MainActor (ActivityData) -> Void
        let commentAdded: @MainActor (CommentData) -> Void
        let commentRemoved: @MainActor (CommentData) -> Void
        let commentUpdated: @MainActor (CommentData) -> Void
        let commentReactionAdded: @MainActor (FeedsReactionData, CommentData) -> Void
        let commentReactionRemoved: @MainActor (FeedsReactionData, CommentData) -> Void
        let pollClosed: @MainActor (PollData) -> Void
        let pollDeleted: @MainActor (String) -> Void
        let pollUpdated: @MainActor (PollData) -> Void
        let pollVoteCasted: @MainActor (PollVoteData, PollData) -> Void
        let pollVoteChanged: @MainActor (PollVoteData, PollData) -> Void
        let pollVoteRemoved: @MainActor (PollVoteData, PollData) -> Void
    }
    
    /// Creates the change handlers for activity state updates.
    ///
    /// - Returns: A ChangeHandlers instance with all the necessary update functions
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
                    self?.comments.sortedInsert(comment, by: CommentData.defaultSorting)
                }
            },
            commentRemoved: { [weak self] comment in
                if let parentId = comment.parentId {
                    // TODO: Deeper nesting
                    self?.updateComment(with: parentId) { parentComment in
                        parentComment.removeReply(comment)
                    }
                } else {
                    self?.comments.sortedRemove(comment, by: CommentData.defaultSorting)
                }
            },
            commentUpdated: { [weak self] comment in
                if let parentId = comment.parentId {
                    // TODO: Deeper nesting
                    self?.updateComment(with: parentId) { parentComment in
                        parentComment.replaceReply(comment)
                    }
                } else {
                    self?.comments.sortedInsert(comment, by: CommentData.defaultSorting)
                }
            },
            commentReactionAdded: { [weak self] reaction, comment in
                self?.updateComment(with: comment.id) { comment in
                    comment.addReaction(reaction)
                }
            },
            commentReactionRemoved: { [weak self] reaction, comment in
                self?.updateComment(with: comment.id) { comment in
                    comment.removeReaction(reaction)
                }
            },
            pollClosed: { [weak self] poll in
                guard poll.id == self?.poll?.id else { return }
                self?.poll = poll
            },
            pollDeleted: { [weak self] pollId in
                guard pollId == self?.poll?.id else { return }
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
    
    /// Updates a specific comment in the comments array.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the comment to update
    ///   - changes: A closure that receives the comment and can modify it
    private func updateComment(with id: String, changes: (inout CommentData) -> Void) {
        guard let index = comments.firstIndex(where: { $0.id == id }) else { return }
        var comment = comments[index]
        changes(&comment)
        self.comments[index] = comment
    }
    
    /// Updates the activity data and associated poll.
    ///
    /// - Parameter activity: The updated activity data
    func updateActivity(_ activity: ActivityData) {
        self.activity = activity
        self.poll = activity.poll
    }
    
    /// Provides thread-safe access to the state for modifications.
    ///
    /// - Parameter actions: A closure that receives the current state and can modify it
    /// - Returns: The result of the actions closure
    func access<T>(_ actions: @MainActor (ActivityState) -> T) -> T {
        actions(self)
    }
    
    /// Updates the state with comments query results.
    ///
    /// This method is called when comments are initially loaded or refreshed.
    ///
    /// - Parameter data: The response containing comments data
    func update(with data: PaginationResult<CommentData>) {
        comments = data.models.sorted(by: CommentData.defaultSorting)
    }
}
