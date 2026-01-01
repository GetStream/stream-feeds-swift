//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// An event intended to be used for state-layer state mutations.
enum StateLayerEvent: Sendable {
    case activityAdded(ActivityData, FeedId)
    case activityDeleted(String, FeedId)
    case activityUpdated(ActivityData, FeedId)
    case activityBatchUpdate(ModelUpdates<ActivityData>)
    
    case activityReactionAdded(FeedsReactionData, ActivityData, FeedId)
    case activityReactionDeleted(FeedsReactionData, ActivityData, FeedId)
    case activityReactionUpdated(FeedsReactionData, ActivityData, FeedId)
    
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
    case commentsAddedBatch([CommentData], String, FeedId)
    
    case commentReactionAdded(FeedsReactionData, CommentData, FeedId)
    case commentReactionDeleted(FeedsReactionData, CommentData, FeedId)
    case commentReactionUpdated(FeedsReactionData, CommentData, FeedId)
        
    case pollDeleted(String, FeedId)
    case pollUpdated(PollData, FeedId)
    case pollVoteCasted(PollVoteData, PollData, FeedId)
    case pollVoteChanged(PollVoteData, PollData, FeedId)
    case pollVoteDeleted(PollVoteData, PollData, FeedId)
    
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
    
    case userUpdated(UserData)
    
    //
    // Local events not related to any particular web-socket event
    //
    
    /// Local capabilities tracking detected that capabilities changed for the feed.
    ///
    /// Web-socket events do not have `own_` fields set and therefore state layer uses
    /// related WS events to keep the data up to date (e.g. activity reactions
    /// are managed by WS events: added, updated, removed).
    /// Capabilities are special because every feed has capabilities for the current
    /// user. Therefore need to make sure (`ActivityData.currentFeed.ownCapabilities`) is set
    /// when activities are added. For this particular case we have bookkeeping and we make
    /// sure state-layer updates `ownCapabilities` for already fetched models as well.
    case feedOwnCapabilitiesUpdated([FeedId: Set<FeedOwnCapability>])
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
        // Activity reactions
        case let event as ActivityReactionAddedEvent:
            self = .activityReactionAdded(event.reaction.toModel(), event.activity.toModel(), FeedId(rawValue: event.fid))
        case let event as ActivityReactionDeletedEvent:
            self = .activityReactionDeleted(event.reaction.toModel(), event.activity.toModel(), FeedId(rawValue: event.fid))
        case let event as ActivityReactionUpdatedEvent:
            self = .activityReactionUpdated(event.reaction.toModel(), event.activity.toModel(), FeedId(rawValue: event.fid))
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
        // Comment added, deleted, updated
        case let event as CommentAddedEvent:
            self = .commentAdded(event.comment.toModel(), event.activity.toModel(), FeedId(rawValue: event.fid))
        case let event as CommentDeletedEvent:
            self = .commentDeleted(event.comment.toModel(), event.comment.objectId, FeedId(rawValue: event.fid))
        case let event as CommentUpdatedEvent:
            self = .commentUpdated(event.comment.toModel(), event.comment.objectId, FeedId(rawValue: event.fid))
        // Comment reaction added, deleted, updated
        case let event as CommentReactionAddedEvent:
            self = .commentReactionAdded(event.reaction.toModel(), event.comment.toModel(), FeedId(rawValue: event.fid))
        case let event as CommentReactionDeletedEvent:
            self = .commentReactionDeleted(event.reaction.toModel(), event.comment.toModel(), FeedId(rawValue: event.fid))
        case let event as CommentReactionUpdatedEvent:
            self = .commentReactionUpdated(event.reaction.toModel(), event.comment.toModel(), FeedId(rawValue: event.fid))
        // Poll deleted
        case let event as PollDeletedFeedEvent:
            self = .pollDeleted(event.poll.id, FeedId(rawValue: event.fid))
        // Poll updated
        case let event as PollUpdatedFeedEvent:
            self = .pollUpdated(event.poll.toModel(), FeedId(rawValue: event.fid))
        case let event as PollClosedFeedEvent:
            self = .pollUpdated(event.poll.toModel(), FeedId(rawValue: event.fid))
        // Poll votes
        case let event as PollVoteCastedFeedEvent:
            self = .pollVoteCasted(event.pollVote.toModel(), event.poll.toModel(), FeedId(rawValue: event.fid))
        case let event as PollVoteChangedFeedEvent:
            self = .pollVoteChanged(event.pollVote.toModel(), event.poll.toModel(), FeedId(rawValue: event.fid))
        case let event as PollVoteRemovedFeedEvent:
            self = .pollVoteDeleted(event.pollVote.toModel(), event.poll.toModel(), FeedId(rawValue: event.fid))
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
        case let event as UserUpdatedEvent:
            self = .userUpdated(event.user.toModel())
            
        //
        // Unhandled events:
        //
        // User events
        // case let event as UserBannedEvent:
        // case let event as UserDeactivatedEvent:
        // case let event as UserMutedEvent:
        // case let event as UserReactivatedEvent:
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
