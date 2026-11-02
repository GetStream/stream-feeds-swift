//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

private class WSEventMapping: Decodable {
    let type: String
}

public enum FeedsEvent: Decodable, Hashable {
    case typeAppUpdatedEvent(AppUpdatedEvent)
    case typeConnectionErrorEvent(ConnectionErrorEvent)
    case typeConnectedEvent(ConnectedEvent)
    case typeActivityAddedEvent(ActivityAddedEvent)
    case typeActivityDeletedEvent(ActivityDeletedEvent)
    case typeActivityFeedbackEvent(ActivityFeedbackEvent)
    case typeActivityMarkEvent(ActivityMarkEvent)
    case typeActivityPinnedEvent(ActivityPinnedEvent)
    case typeActivityReactionAddedEvent(ActivityReactionAddedEvent)
    case typeActivityReactionDeletedEvent(ActivityReactionDeletedEvent)
    case typeActivityReactionUpdatedEvent(ActivityReactionUpdatedEvent)
    case typeActivityRemovedFromFeedEvent(ActivityRemovedFromFeedEvent)
    case typeActivityRestoredEvent(ActivityRestoredEvent)
    case typeActivityUnpinnedEvent(ActivityUnpinnedEvent)
    case typeActivityUpdatedEvent(ActivityUpdatedEvent)
    case typeBookmarkAddedEvent(BookmarkAddedEvent)
    case typeBookmarkDeletedEvent(BookmarkDeletedEvent)
    case typeBookmarkUpdatedEvent(BookmarkUpdatedEvent)
    case typeBookmarkFolderDeletedEvent(BookmarkFolderDeletedEvent)
    case typeBookmarkFolderUpdatedEvent(BookmarkFolderUpdatedEvent)
    case typeCommentAddedEvent(CommentAddedEvent)
    case typeCommentDeletedEvent(CommentDeletedEvent)
    case typeCommentFeedbackEvent(CommentFeedbackEvent)
    case typeCommentReactionAddedEvent(CommentReactionAddedEvent)
    case typeCommentReactionDeletedEvent(CommentReactionDeletedEvent)
    case typeCommentReactionUpdatedEvent(CommentReactionUpdatedEvent)
    case typeCommentRestoredEvent(CommentRestoredEvent)
    case typeCommentUpdatedEvent(CommentUpdatedEvent)
    case typeFeedCreatedEvent(FeedCreatedEvent)
    case typeFeedDeletedEvent(FeedDeletedEvent)
    case typeFeedUpdatedEvent(FeedUpdatedEvent)
    case typeFeedGroupChangedEvent(FeedGroupChangedEvent)
    case typeFeedGroupDeletedEvent(FeedGroupDeletedEvent)
    case typeFeedGroupRestoredEvent(FeedGroupRestoredEvent)
    case typeFeedMemberAddedEvent(FeedMemberAddedEvent)
    case typeFeedMemberRemovedEvent(FeedMemberRemovedEvent)
    case typeFeedMemberUpdatedEvent(FeedMemberUpdatedEvent)
    case typeFollowCreatedEvent(FollowCreatedEvent)
    case typeFollowDeletedEvent(FollowDeletedEvent)
    case typeFollowUpdatedEvent(FollowUpdatedEvent)
    case typeNotificationFeedUpdatedEvent(NotificationFeedUpdatedEvent)
    case typePollClosedFeedEvent(PollClosedFeedEvent)
    case typePollDeletedFeedEvent(PollDeletedFeedEvent)
    case typePollUpdatedFeedEvent(PollUpdatedFeedEvent)
    case typePollVoteCastedFeedEvent(PollVoteCastedFeedEvent)
    case typePollVoteChangedFeedEvent(PollVoteChangedFeedEvent)
    case typePollVoteRemovedFeedEvent(PollVoteRemovedFeedEvent)
    case typeStoriesFeedUpdatedEvent(StoriesFeedUpdatedEvent)
    case typeHealthCheckEvent(HealthCheckEvent)
    case typeModerationCustomActionEvent(ModerationCustomActionEvent)
    case typeModerationFlaggedEvent(ModerationFlaggedEvent)
    case typeModerationMarkReviewedEvent(ModerationMarkReviewedEvent)
    case typeUserBannedEvent(UserBannedEvent)
    case typeUserDeactivatedEvent(UserDeactivatedEvent)
    case typeUserDeletedEvent(UserDeletedEvent)
    case typeUserReactivatedEvent(UserReactivatedEvent)
    case typeUserUnbannedEvent(UserUnbannedEvent)
    case typeUserUpdatedEvent(UserUpdatedEvent)

    public var type: String {
        switch self {
        case .typeAppUpdatedEvent(let value):
            return value.type
        case .typeConnectionErrorEvent(let value):
            return value.type
        case .typeConnectedEvent(let value):
            return value.type
        case .typeActivityAddedEvent(let value):
            return value.type
        case .typeActivityDeletedEvent(let value):
            return value.type
        case .typeActivityFeedbackEvent(let value):
            return value.type
        case .typeActivityMarkEvent(let value):
            return value.type
        case .typeActivityPinnedEvent(let value):
            return value.type
        case .typeActivityReactionAddedEvent(let value):
            return value.type
        case .typeActivityReactionDeletedEvent(let value):
            return value.type
        case .typeActivityReactionUpdatedEvent(let value):
            return value.type
        case .typeActivityRemovedFromFeedEvent(let value):
            return value.type
        case .typeActivityRestoredEvent(let value):
            return value.type
        case .typeActivityUnpinnedEvent(let value):
            return value.type
        case .typeActivityUpdatedEvent(let value):
            return value.type
        case .typeBookmarkAddedEvent(let value):
            return value.type
        case .typeBookmarkDeletedEvent(let value):
            return value.type
        case .typeBookmarkUpdatedEvent(let value):
            return value.type
        case .typeBookmarkFolderDeletedEvent(let value):
            return value.type
        case .typeBookmarkFolderUpdatedEvent(let value):
            return value.type
        case .typeCommentAddedEvent(let value):
            return value.type
        case .typeCommentDeletedEvent(let value):
            return value.type
        case .typeCommentFeedbackEvent(let value):
            return value.type
        case .typeCommentReactionAddedEvent(let value):
            return value.type
        case .typeCommentReactionDeletedEvent(let value):
            return value.type
        case .typeCommentReactionUpdatedEvent(let value):
            return value.type
        case .typeCommentRestoredEvent(let value):
            return value.type
        case .typeCommentUpdatedEvent(let value):
            return value.type
        case .typeFeedCreatedEvent(let value):
            return value.type
        case .typeFeedDeletedEvent(let value):
            return value.type
        case .typeFeedUpdatedEvent(let value):
            return value.type
        case .typeFeedGroupChangedEvent(let value):
            return value.type
        case .typeFeedGroupDeletedEvent(let value):
            return value.type
        case .typeFeedGroupRestoredEvent(let value):
            return value.type
        case .typeFeedMemberAddedEvent(let value):
            return value.type
        case .typeFeedMemberRemovedEvent(let value):
            return value.type
        case .typeFeedMemberUpdatedEvent(let value):
            return value.type
        case .typeFollowCreatedEvent(let value):
            return value.type
        case .typeFollowDeletedEvent(let value):
            return value.type
        case .typeFollowUpdatedEvent(let value):
            return value.type
        case .typeNotificationFeedUpdatedEvent(let value):
            return value.type
        case .typePollClosedFeedEvent(let value):
            return value.type
        case .typePollDeletedFeedEvent(let value):
            return value.type
        case .typePollUpdatedFeedEvent(let value):
            return value.type
        case .typePollVoteCastedFeedEvent(let value):
            return value.type
        case .typePollVoteChangedFeedEvent(let value):
            return value.type
        case .typePollVoteRemovedFeedEvent(let value):
            return value.type
        case .typeStoriesFeedUpdatedEvent(let value):
            return value.type
        case .typeHealthCheckEvent(let value):
            return value.type
        case .typeModerationCustomActionEvent(let value):
            return value.type
        case .typeModerationFlaggedEvent(let value):
            return value.type
        case .typeModerationMarkReviewedEvent(let value):
            return value.type
        case .typeUserBannedEvent(let value):
            return value.type
        case .typeUserDeactivatedEvent(let value):
            return value.type
        case .typeUserDeletedEvent(let value):
            return value.type
        case .typeUserReactivatedEvent(let value):
            return value.type
        case .typeUserUnbannedEvent(let value):
            return value.type
        case .typeUserUpdatedEvent(let value):
            return value.type
        }
    }

    public var rawValue: Event {
        switch self {
        case .typeAppUpdatedEvent(let value):
            return value
        case .typeConnectionErrorEvent(let value):
            return value
        case .typeConnectedEvent(let value):
            return value
        case .typeActivityAddedEvent(let value):
            return value
        case .typeActivityDeletedEvent(let value):
            return value
        case .typeActivityFeedbackEvent(let value):
            return value
        case .typeActivityMarkEvent(let value):
            return value
        case .typeActivityPinnedEvent(let value):
            return value
        case .typeActivityReactionAddedEvent(let value):
            return value
        case .typeActivityReactionDeletedEvent(let value):
            return value
        case .typeActivityReactionUpdatedEvent(let value):
            return value
        case .typeActivityRemovedFromFeedEvent(let value):
            return value
        case .typeActivityRestoredEvent(let value):
            return value
        case .typeActivityUnpinnedEvent(let value):
            return value
        case .typeActivityUpdatedEvent(let value):
            return value
        case .typeBookmarkAddedEvent(let value):
            return value
        case .typeBookmarkDeletedEvent(let value):
            return value
        case .typeBookmarkUpdatedEvent(let value):
            return value
        case .typeBookmarkFolderDeletedEvent(let value):
            return value
        case .typeBookmarkFolderUpdatedEvent(let value):
            return value
        case .typeCommentAddedEvent(let value):
            return value
        case .typeCommentDeletedEvent(let value):
            return value
        case .typeCommentFeedbackEvent(let value):
            return value
        case .typeCommentReactionAddedEvent(let value):
            return value
        case .typeCommentReactionDeletedEvent(let value):
            return value
        case .typeCommentReactionUpdatedEvent(let value):
            return value
        case .typeCommentRestoredEvent(let value):
            return value
        case .typeCommentUpdatedEvent(let value):
            return value
        case .typeFeedCreatedEvent(let value):
            return value
        case .typeFeedDeletedEvent(let value):
            return value
        case .typeFeedUpdatedEvent(let value):
            return value
        case .typeFeedGroupChangedEvent(let value):
            return value
        case .typeFeedGroupDeletedEvent(let value):
            return value
        case .typeFeedGroupRestoredEvent(let value):
            return value
        case .typeFeedMemberAddedEvent(let value):
            return value
        case .typeFeedMemberRemovedEvent(let value):
            return value
        case .typeFeedMemberUpdatedEvent(let value):
            return value
        case .typeFollowCreatedEvent(let value):
            return value
        case .typeFollowDeletedEvent(let value):
            return value
        case .typeFollowUpdatedEvent(let value):
            return value
        case .typeNotificationFeedUpdatedEvent(let value):
            return value
        case .typePollClosedFeedEvent(let value):
            return value
        case .typePollDeletedFeedEvent(let value):
            return value
        case .typePollUpdatedFeedEvent(let value):
            return value
        case .typePollVoteCastedFeedEvent(let value):
            return value
        case .typePollVoteChangedFeedEvent(let value):
            return value
        case .typePollVoteRemovedFeedEvent(let value):
            return value
        case .typeStoriesFeedUpdatedEvent(let value):
            return value
        case .typeHealthCheckEvent(let value):
            return value
        case .typeModerationCustomActionEvent(let value):
            return value
        case .typeModerationFlaggedEvent(let value):
            return value
        case .typeModerationMarkReviewedEvent(let value):
            return value
        case .typeUserBannedEvent(let value):
            return value
        case .typeUserDeactivatedEvent(let value):
            return value
        case .typeUserDeletedEvent(let value):
            return value
        case .typeUserReactivatedEvent(let value):
            return value
        case .typeUserUnbannedEvent(let value):
            return value
        case .typeUserUpdatedEvent(let value):
            return value
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dto = try container.decode(WSEventMapping.self)
        if dto.type == "app.updated" {
            let value = try container.decode(AppUpdatedEvent.self)
            self = .typeAppUpdatedEvent(value)
        } else if dto.type == "connection.error" {
            let value = try container.decode(ConnectionErrorEvent.self)
            self = .typeConnectionErrorEvent(value)
        } else if dto.type == "connection.ok" {
            let value = try container.decode(ConnectedEvent.self)
            self = .typeConnectedEvent(value)
        } else if dto.type == "feeds.activity.added" {
            let value = try container.decode(ActivityAddedEvent.self)
            self = .typeActivityAddedEvent(value)
        } else if dto.type == "feeds.activity.deleted" {
            let value = try container.decode(ActivityDeletedEvent.self)
            self = .typeActivityDeletedEvent(value)
        } else if dto.type == "feeds.activity.feedback" {
            let value = try container.decode(ActivityFeedbackEvent.self)
            self = .typeActivityFeedbackEvent(value)
        } else if dto.type == "feeds.activity.marked" {
            let value = try container.decode(ActivityMarkEvent.self)
            self = .typeActivityMarkEvent(value)
        } else if dto.type == "feeds.activity.pinned" {
            let value = try container.decode(ActivityPinnedEvent.self)
            self = .typeActivityPinnedEvent(value)
        } else if dto.type == "feeds.activity.reaction.added" {
            let value = try container.decode(ActivityReactionAddedEvent.self)
            self = .typeActivityReactionAddedEvent(value)
        } else if dto.type == "feeds.activity.reaction.deleted" {
            let value = try container.decode(ActivityReactionDeletedEvent.self)
            self = .typeActivityReactionDeletedEvent(value)
        } else if dto.type == "feeds.activity.reaction.updated" {
            let value = try container.decode(ActivityReactionUpdatedEvent.self)
            self = .typeActivityReactionUpdatedEvent(value)
        } else if dto.type == "feeds.activity.removed_from_feed" {
            let value = try container.decode(ActivityRemovedFromFeedEvent.self)
            self = .typeActivityRemovedFromFeedEvent(value)
        } else if dto.type == "feeds.activity.restored" {
            let value = try container.decode(ActivityRestoredEvent.self)
            self = .typeActivityRestoredEvent(value)
        } else if dto.type == "feeds.activity.unpinned" {
            let value = try container.decode(ActivityUnpinnedEvent.self)
            self = .typeActivityUnpinnedEvent(value)
        } else if dto.type == "feeds.activity.updated" {
            let value = try container.decode(ActivityUpdatedEvent.self)
            self = .typeActivityUpdatedEvent(value)
        } else if dto.type == "feeds.bookmark.added" {
            let value = try container.decode(BookmarkAddedEvent.self)
            self = .typeBookmarkAddedEvent(value)
        } else if dto.type == "feeds.bookmark.deleted" {
            let value = try container.decode(BookmarkDeletedEvent.self)
            self = .typeBookmarkDeletedEvent(value)
        } else if dto.type == "feeds.bookmark.updated" {
            let value = try container.decode(BookmarkUpdatedEvent.self)
            self = .typeBookmarkUpdatedEvent(value)
        } else if dto.type == "feeds.bookmark_folder.deleted" {
            let value = try container.decode(BookmarkFolderDeletedEvent.self)
            self = .typeBookmarkFolderDeletedEvent(value)
        } else if dto.type == "feeds.bookmark_folder.updated" {
            let value = try container.decode(BookmarkFolderUpdatedEvent.self)
            self = .typeBookmarkFolderUpdatedEvent(value)
        } else if dto.type == "feeds.comment.added" {
            let value = try container.decode(CommentAddedEvent.self)
            self = .typeCommentAddedEvent(value)
        } else if dto.type == "feeds.comment.deleted" {
            let value = try container.decode(CommentDeletedEvent.self)
            self = .typeCommentDeletedEvent(value)
        } else if dto.type == "feeds.comment.feedback" {
            let value = try container.decode(CommentFeedbackEvent.self)
            self = .typeCommentFeedbackEvent(value)
        } else if dto.type == "feeds.comment.reaction.added" {
            let value = try container.decode(CommentReactionAddedEvent.self)
            self = .typeCommentReactionAddedEvent(value)
        } else if dto.type == "feeds.comment.reaction.deleted" {
            let value = try container.decode(CommentReactionDeletedEvent.self)
            self = .typeCommentReactionDeletedEvent(value)
        } else if dto.type == "feeds.comment.reaction.updated" {
            let value = try container.decode(CommentReactionUpdatedEvent.self)
            self = .typeCommentReactionUpdatedEvent(value)
        } else if dto.type == "feeds.comment.restored" {
            let value = try container.decode(CommentRestoredEvent.self)
            self = .typeCommentRestoredEvent(value)
        } else if dto.type == "feeds.comment.updated" {
            let value = try container.decode(CommentUpdatedEvent.self)
            self = .typeCommentUpdatedEvent(value)
        } else if dto.type == "feeds.feed.created" {
            let value = try container.decode(FeedCreatedEvent.self)
            self = .typeFeedCreatedEvent(value)
        } else if dto.type == "feeds.feed.deleted" {
            let value = try container.decode(FeedDeletedEvent.self)
            self = .typeFeedDeletedEvent(value)
        } else if dto.type == "feeds.feed.updated" {
            let value = try container.decode(FeedUpdatedEvent.self)
            self = .typeFeedUpdatedEvent(value)
        } else if dto.type == "feeds.feed_group.changed" {
            let value = try container.decode(FeedGroupChangedEvent.self)
            self = .typeFeedGroupChangedEvent(value)
        } else if dto.type == "feeds.feed_group.deleted" {
            let value = try container.decode(FeedGroupDeletedEvent.self)
            self = .typeFeedGroupDeletedEvent(value)
        } else if dto.type == "feeds.feed_group.restored" {
            let value = try container.decode(FeedGroupRestoredEvent.self)
            self = .typeFeedGroupRestoredEvent(value)
        } else if dto.type == "feeds.feed_member.added" {
            let value = try container.decode(FeedMemberAddedEvent.self)
            self = .typeFeedMemberAddedEvent(value)
        } else if dto.type == "feeds.feed_member.removed" {
            let value = try container.decode(FeedMemberRemovedEvent.self)
            self = .typeFeedMemberRemovedEvent(value)
        } else if dto.type == "feeds.feed_member.updated" {
            let value = try container.decode(FeedMemberUpdatedEvent.self)
            self = .typeFeedMemberUpdatedEvent(value)
        } else if dto.type == "feeds.follow.created" {
            let value = try container.decode(FollowCreatedEvent.self)
            self = .typeFollowCreatedEvent(value)
        } else if dto.type == "feeds.follow.deleted" {
            let value = try container.decode(FollowDeletedEvent.self)
            self = .typeFollowDeletedEvent(value)
        } else if dto.type == "feeds.follow.updated" {
            let value = try container.decode(FollowUpdatedEvent.self)
            self = .typeFollowUpdatedEvent(value)
        } else if dto.type == "feeds.notification_feed.updated" {
            let value = try container.decode(NotificationFeedUpdatedEvent.self)
            self = .typeNotificationFeedUpdatedEvent(value)
        } else if dto.type == "feeds.poll.closed" {
            let value = try container.decode(PollClosedFeedEvent.self)
            self = .typePollClosedFeedEvent(value)
        } else if dto.type == "feeds.poll.deleted" {
            let value = try container.decode(PollDeletedFeedEvent.self)
            self = .typePollDeletedFeedEvent(value)
        } else if dto.type == "feeds.poll.updated" {
            let value = try container.decode(PollUpdatedFeedEvent.self)
            self = .typePollUpdatedFeedEvent(value)
        } else if dto.type == "feeds.poll.vote_casted" {
            let value = try container.decode(PollVoteCastedFeedEvent.self)
            self = .typePollVoteCastedFeedEvent(value)
        } else if dto.type == "feeds.poll.vote_changed" {
            let value = try container.decode(PollVoteChangedFeedEvent.self)
            self = .typePollVoteChangedFeedEvent(value)
        } else if dto.type == "feeds.poll.vote_removed" {
            let value = try container.decode(PollVoteRemovedFeedEvent.self)
            self = .typePollVoteRemovedFeedEvent(value)
        } else if dto.type == "feeds.stories_feed.updated" {
            let value = try container.decode(StoriesFeedUpdatedEvent.self)
            self = .typeStoriesFeedUpdatedEvent(value)
        } else if dto.type == "health.check" {
            let value = try container.decode(HealthCheckEvent.self)
            self = .typeHealthCheckEvent(value)
        } else if dto.type == "moderation.custom_action" {
            let value = try container.decode(ModerationCustomActionEvent.self)
            self = .typeModerationCustomActionEvent(value)
        } else if dto.type == "moderation.flagged" {
            let value = try container.decode(ModerationFlaggedEvent.self)
            self = .typeModerationFlaggedEvent(value)
        } else if dto.type == "moderation.mark_reviewed" {
            let value = try container.decode(ModerationMarkReviewedEvent.self)
            self = .typeModerationMarkReviewedEvent(value)
        } else if dto.type == "user.banned" {
            let value = try container.decode(UserBannedEvent.self)
            self = .typeUserBannedEvent(value)
        } else if dto.type == "user.deactivated" {
            let value = try container.decode(UserDeactivatedEvent.self)
            self = .typeUserDeactivatedEvent(value)
        } else if dto.type == "user.deleted" {
            let value = try container.decode(UserDeletedEvent.self)
            self = .typeUserDeletedEvent(value)
        } else if dto.type == "user.reactivated" {
            let value = try container.decode(UserReactivatedEvent.self)
            self = .typeUserReactivatedEvent(value)
        } else if dto.type == "user.unbanned" {
            let value = try container.decode(UserUnbannedEvent.self)
            self = .typeUserUnbannedEvent(value)
        } else if dto.type == "user.updated" {
            let value = try container.decode(UserUpdatedEvent.self)
            self = .typeUserUpdatedEvent(value)
        } else {
            throw DecodingError.typeMismatch(Self.Type.self, .init(codingPath: decoder.codingPath, debugDescription: "Unable to decode instance of FeedsEvent"))
        }
    }
}
