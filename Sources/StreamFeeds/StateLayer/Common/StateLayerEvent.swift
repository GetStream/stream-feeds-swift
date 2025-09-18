//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// An event intended to be used for state-layer state mutations.
///
/// - Note: Many of the WS events are merged into a single update event.
enum StateLayerEvent: Sendable {
    case activityAdded(ActivityData, FeedId)
    case activityDeleted(String, FeedId)
    case activityUpdated(ActivityData, FeedId)
    
    case activityMarked(ActivityMarkData, FeedId)
    case activityPinned(ActivityPinData, FeedId)
    case activityUnpinned(ActivityPinData, FeedId)
    
    case bookmarkAdded(BookmarkData)
    case bookmarkDeleted(BookmarkData)
    case bookmarkUpdated(BookmarkData)
    
    case bookmarkFolderDeleted(BookmarkFolderData)
    case bookmarkFolderUpdated(BookmarkFolderData)

    case commentAdded(CommentData, ActivityData, FeedId)
    case commentDeleted(CommentData, String, FeedId)
    case commentUpdated(CommentData, String, FeedId)
        
    case pollDeleted(String, FeedId)
    case pollUpdated(PollData, FeedId)
    
    case feedAdded(FeedData, FeedId)
    case feedDeleted(FeedId)
    case feedUpdated(FeedData, FeedId)

    case feedFollowAdded(FollowData, FeedId)
    case feedFollowDeleted(FollowData, FeedId)
    case feedFollowUpdated(FollowData, FeedId)
    
    case feedGroupDeleted(FeedId)
    case feedGroupUpdated(FeedId)
    
    case feedMemberAdded(FeedMemberData, FeedId)
    case feedMemberDeleted(String, FeedId)
    case feedMemberUpdated(FeedMemberData, FeedId)
    case feedMemberBatchUpdate(ModelUpdates<FeedMemberData>, FeedId)
    
    case notificationFeedUpdated(FeedId)
}

extension StateLayerEvent {
    init?(event: Event) {
        switch event {
        // Activity added
        case let event as ActivityAddedEvent:
            self = .activityAdded(event.activity.toModel(), FeedId(rawValue: event.fid))
        // Activity deleted
        case let event as ActivityDeletedEvent:
            self = .activityDeleted(event.activity.id, FeedId(rawValue: event.fid))
        // Activity updated
        case let event as ActivityUpdatedEvent:
            self = .activityUpdated(event.activity.toModel(), FeedId(rawValue: event.fid))
        case let event as ActivityReactionAddedEvent:
            self = .activityUpdated(event.activity.toModel(), FeedId(rawValue: event.fid))
        case let event as ActivityReactionDeletedEvent:
            self = .activityUpdated(event.activity.toModel(), FeedId(rawValue: event.fid))
        case let event as ActivityReactionUpdatedEvent:
            self = .activityUpdated(event.activity.toModel(), FeedId(rawValue: event.fid))
        // Activity pinned
        case let event as ActivityPinnedEvent:
            self = .activityPinned(event.pinnedActivity.toModel(), FeedId(rawValue: event.fid))
        case let event as ActivityUnpinnedEvent:
            self = .activityUnpinned(event.pinnedActivity.toModel(), FeedId(rawValue: event.fid))
        // Activity other
        case let event as ActivityMarkEvent:
            self = .activityMarked(event.toModel(), FeedId(rawValue: event.fid))
        case let event as ActivityRemovedFromFeedEvent:
            self = .activityDeleted(event.activity.id, FeedId(rawValue: event.fid))
        // Bookmark added, deleted, updated
        case let event as BookmarkAddedEvent:
            self = .bookmarkAdded(event.bookmark.toModel())
        case let event as BookmarkDeletedEvent:
            self = .bookmarkDeleted(event.bookmark.toModel())
        case let event as BookmarkUpdatedEvent:
            self = .bookmarkUpdated(event.bookmark.toModel())
        // Bookmark folder deleted, updated
        case let event as BookmarkFolderDeletedEvent:
            self = .bookmarkFolderDeleted(event.bookmarkFolder.toModel())
        case let event as BookmarkFolderUpdatedEvent:
            self = .bookmarkFolderUpdated(event.bookmarkFolder.toModel())
        // Comment added
        case let event as CommentAddedEvent:
            self = .commentAdded(event.comment.toModel(), event.activity.toModel(), FeedId(rawValue: event.fid))
        // Comment deleted
        case let event as CommentDeletedEvent:
            self = .commentDeleted(event.comment.toModel(), event.comment.objectId, FeedId(rawValue: event.fid))
        // Comment updated
        case let event as CommentUpdatedEvent:
            self = .commentUpdated(event.comment.toModel(), event.comment.objectId, FeedId(rawValue: event.fid))
        case let event as CommentReactionAddedEvent:
            self = .commentUpdated(event.comment.toModel(), event.comment.objectId, FeedId(rawValue: event.fid))
        case let event as CommentReactionDeletedEvent:
            self = .commentUpdated(event.comment.toModel(), event.comment.objectId, FeedId(rawValue: event.fid))
        case let event as CommentReactionUpdatedEvent:
            self = .commentUpdated(event.comment.toModel(), event.comment.objectId, FeedId(rawValue: event.fid))
        // Poll deleted
        case let event as PollDeletedFeedEvent:
            self = .pollDeleted(event.poll.id, FeedId(rawValue: event.fid))
        // Poll updated
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
        // Feed created, deleted, updated
        case let event as FeedCreatedEvent:
            self = .feedAdded(event.feed.toModel(), FeedId(rawValue: event.fid))
        case let event as FeedDeletedEvent:
            self = .feedDeleted(FeedId(rawValue: event.fid))
        case let event as FeedUpdatedEvent:
            self = .feedUpdated(event.feed.toModel(), FeedId(rawValue: event.fid))
        // Feed group deleted, updated
        case let event as FeedGroupDeletedEvent:
            self = .feedGroupDeleted(FeedId(rawValue: event.fid))
        case let event as FeedGroupChangedEvent:
            self = .feedGroupUpdated(FeedId(rawValue: event.fid))
        // Feed member added, deleted, updated
        case let event as FeedMemberAddedEvent:
            self = .feedMemberAdded(event.member.toModel(), FeedId(rawValue: event.fid))
        case let event as FeedMemberRemovedEvent:
            self = .feedMemberDeleted(event.memberId, FeedId(rawValue: event.fid))
        case let event as FeedMemberUpdatedEvent:
            self = .feedMemberUpdated(event.member.toModel(), FeedId(rawValue: event.fid))
        // Notification feed updated
        case let event as NotificationFeedUpdatedEvent:
            self = .notificationFeedUpdated(FeedId(rawValue: event.fid))
        // Follow events
        case let event as FollowCreatedEvent:
            self = .feedFollowAdded(event.follow.toModel(), FeedId(rawValue: event.fid))
        case let event as FollowDeletedEvent:
            self = .feedFollowDeleted(event.follow.toModel(), FeedId(rawValue: event.fid))
        case let event as FollowUpdatedEvent:
            self = .feedFollowUpdated(event.follow.toModel(), FeedId(rawValue: event.fid))
            
        //
        // Unhandled events:
        //
        // User events
        // case let event as UserBannedEvent:
        // case let event as UserDeactivatedEvent:
        // case let event as UserMutedEvent:
        // case let event as UserReactivatedEvent:
        // case let event as UserUpdatedEvent:
        // App events
        // case let event as AppUpdatedEvent:
        // Moderation events
        // case let event as ModerationCustomActionEvent:
        // case let event as ModerationFlaggedEvent:
        // case let event as ModerationMarkReviewedEvent:
        // Connection events
        // case let event as ConnectedEvent:
        // case let event as ConnectionErrorEvent:
        default:
            return nil
        }
    }
}
