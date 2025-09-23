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
        eventSubscription = publisher.subscribe { [weak self, activityId, currentUserId, feed] event in
            switch event {
            case .activityDeleted(let eventActivityId, let eventFeedId):
                guard eventActivityId == activityId, eventFeedId == feed else { return }
                await self?.setActivity(nil)
            case .activityUpdated(let activityData, let eventFeedId):
                guard activityData.id == activityId, eventFeedId == feed else { return }
                await self?.setActivity(activityData)
            case .activityReactionAdded(let reactionData, let activityData, let eventFeedId):
                guard activityData.id == activityId, eventFeedId == feed else { return }
                await self?.access { state in
                    state.activity?.merge(with: activityData, add: reactionData, currentUserId: currentUserId)
                }
            case .activityReactionDeleted(let reactionData, let activityData, let eventFeedId):
                guard activityData.id == activityId, eventFeedId == feed else { return }
                await self?.access { state in
                    state.activity?.merge(with: activityData, remove: reactionData, currentUserId: currentUserId)
                }
            case .activityReactionUpdated(let reactionData, let activityData, let eventFeedId):
                guard activityData.id == activityId, eventFeedId == feed else { return }
                await self?.access { state in
                    state.activity?.merge(with: activityData, update: reactionData, currentUserId: currentUserId)
                }
            case .bookmarkAdded(let bookmarkData):
                guard bookmarkData.activity.id == activityId else { return }
                await self?.access { state in
                    state.activity?.merge(with: bookmarkData.activity, add: bookmarkData, currentUserId: currentUserId)
                }
            case .bookmarkDeleted(let bookmarkData):
                guard bookmarkData.activity.id == activityId else { return }
                await self?.access { state in
                    state.activity?.merge(with: bookmarkData.activity, remove: bookmarkData, currentUserId: currentUserId)
                }
            case .bookmarkUpdated(let bookmarkData):
                guard bookmarkData.activity.id == activityId else { return }
                await self?.access { state in
                    state.activity?.merge(with: bookmarkData.activity, update: bookmarkData, currentUserId: currentUserId)
                }
            case .commentAdded(let commentData, let activityData, let eventFeedId):
                guard activityData.id == activityId, eventFeedId == feed else { return }
                await self?.access { state in
                    state.activity?.merge(with: activityData)
                    state.activity?.addComment(commentData)
                }
            case .commentDeleted(let commentData, let eventActivityId, let eventFeedId):
                guard eventActivityId == activityId, eventFeedId == feed else { return }
                await self?.access { state in
                    state.activity?.deleteComment(commentData)
                }
            case .commentUpdated(let commentData, let eventActivityId, let eventFeedId):
                guard eventActivityId == activityId, eventFeedId == feed else { return }
                await self?.access { state in
                    state.activity?.updateComment(commentData)
                }
            case .commentsAddedBatch(let commentDatas, let eventActivityId, let eventFeedId):
                guard eventActivityId == activityId, eventFeedId == feed else { return }
                await self?.access { state in
                    guard state.activity != nil else { return }
                    for commentData in commentDatas {
                        state.activity?.addComment(commentData)
                    }
                }
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
                    state.poll?.merge(with: pollData)
                }
            case .pollVoteCasted(let vote, let pollData, let eventFeedId):
                guard eventFeedId == feed else { return }
                await self?.access { state in
                    guard state.poll?.id == pollData.id else { return }
                    state.poll?.merge(with: pollData, add: vote, currentUserId: currentUserId)
                }
            case .pollVoteDeleted(let vote, let pollData, let eventFeedId):
                guard eventFeedId == feed else { return }
                await self?.access { state in
                    guard state.poll?.id == pollData.id else { return }
                    state.poll?.merge(with: pollData, remove: vote, currentUserId: currentUserId)
                }
            case .pollVoteChanged(let vote, let pollData, let eventFeedId):
                guard eventFeedId == feed else { return }
                await self?.access { state in
                    guard state.poll?.id == pollData.id else { return }
                    state.poll?.merge(with: pollData, change: vote, currentUserId: currentUserId)
                }
            default:
                break
            }
        }
    }
    
    func setActivity(_ activity: ActivityData?) {
        self.activity = activity
        poll = activity?.poll
    }
    
    private func access<T>(_ actions: @MainActor (ActivityState) -> T) -> T {
        actions(self)
    }
}
