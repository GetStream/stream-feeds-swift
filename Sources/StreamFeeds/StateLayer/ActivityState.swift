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
    private var cancellables = Set<AnyCancellable>()
    private(set) lazy var changeHandlers = makeChangeHandlers()
    private let commentListState: ActivityCommentListState
    let currentUserId: String
    private var webSocketObserver: WebSocketObserver?
    
    init(activityId: String, fid: FeedId, data: ActivityData?, currentUserId: String, events: WSEventsSubscribing, commentListState: ActivityCommentListState) {
        self.commentListState = commentListState
        self.currentUserId = currentUserId
        let webSocketObserver = WebSocketObserver(
            activityId: activityId,
            fid: fid,
            subscribing: events,
            handlers: changeHandlers
        )
        self.webSocketObserver = webSocketObserver
        if let data, data.id == activityId {
            updateActivity(data)
        }
        
        commentListState.$comments
            .assign(to: \.comments, onWeak: self)
            .store(in: &cancellables)
    }
    
    /// The current activity data.
    @Published public private(set) var activity: ActivityData?
    
    /// The list of comments for this activity, sorted by default sorting criteria.
    @Published public internal(set) var comments = [ThreadedCommentData]()
    
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
            pollVoteCasted: { [weak self] _, poll in
                guard poll.id == self?.poll?.id else { return }
                self?.poll = poll
            },
            pollVoteChanged: { [weak self] _, poll in
                guard poll.id == self?.poll?.id else { return }
                self?.poll = poll
            },
            pollVoteRemoved: { [weak self] _, poll in
                guard poll.id == self?.poll?.id else { return }
                self?.poll = poll
            }
        )
    }
    
    func updateActivity(_ activity: ActivityData) {
        self.activity = activity
        poll = activity.poll
    }
    
    func access<T>(_ actions: @MainActor (ActivityState) -> T) -> T {
        actions(self)
    }
}
