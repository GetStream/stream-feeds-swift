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
    private let commentListState: ActivityCommentListState
    let currentUserId: String
    private let activityId: String
    private let feed: FeedId
    private var eventSubscription: StateLayerEventPublisher.Subscription?
    
    init(activityId: String, feed: FeedId, data: ActivityData?, currentUserId: String, eventPublisher: StateLayerEventPublisher, commentListState: ActivityCommentListState) {
        self.activityId = activityId
        self.commentListState = commentListState
        self.currentUserId = currentUserId
        self.feed = feed
        if let data, data.id == activityId {
            setActivity(data)
        }
        subscribe(to: eventPublisher)
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
    private func subscribe(to publisher: StateLayerEventPublisher) {
        eventSubscription = publisher.subscribe { [weak self, activityId, feed] event in
            switch event {
            case .activityUpdated(let activityData, let eventFeedId):
                guard activityData.id == activityId, eventFeedId == feed else { return }
                await self?.setActivity(activityData)
            case .pollDeleted(let pollId, let eventFeedId):
                guard eventFeedId == feed else { return }
                await self?.access { state in
                    guard state.poll?.id == pollId else { return }
                    state.poll = nil
                }
            case .pollUpdated(let pollData, let eventFeedId):
                guard eventFeedId == feed else { return }
                await self?.access { state in
                    guard state.poll?.id == pollData.id else { return }
                    state.poll = pollData
                }
            }
        }
    }
    
    func setActivity(_ activity: ActivityData) {
        self.activity = activity
        poll = activity.poll
    }
    
    private func access<T>(_ actions: @MainActor (ActivityState) -> T) -> T {
        actions(self)
    }
}
