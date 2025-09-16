//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// An event intended to be used for state-layer state mutations.
///
/// - Note: Many of the WS events are merged into a single update event.
enum StateLayerEvent: Sendable {
    case activityUpdated(ActivityData, FeedId)
    case pollDeleted(String, FeedId)
    case pollUpdated(PollData, FeedId)
}

extension StateLayerEvent {
    init?(event: Event) {
        switch event {
        case let event as ActivityUpdatedEvent:
            self = .activityUpdated(event.activity.toModel(), FeedId(rawValue: event.fid))
        case let event as PollDeletedFeedEvent:
            self = .pollDeleted(event.poll.id, FeedId(rawValue: event.fid))
        case let event as PollUpdatedFeedEvent:
            self = .pollUpdated(event.poll.toModel(), FeedId(rawValue: event.fid))
        case let event as PollClosedFeedEvent:
            self = .pollUpdated(event.poll.toModel(), FeedId(rawValue: event.fid))
        case let event as PollVoteCastedFeedEvent:
            self = .pollUpdated(event.poll.toModel(), FeedId(rawValue: event.fid))
        case let event as PollVoteChangedFeedEvent:
            self = .pollUpdated(event.poll.toModel(), FeedId(rawValue: event.fid))
        case let event as PollVoteRemovedFeedEvent:
            self = .pollUpdated(event.poll.toModel(), FeedId(rawValue: event.fid))
        default:
            return nil
        }
    }
}
