//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

private class WSEventMapping: Decodable {
    let type: String
}

public enum FeedsEvent: Codable, Hashable {
    case typeAppUpdatedEvent(AppUpdatedEvent)
    case typeActivityAddedEvent(ActivityAddedEvent)
    case typeActivityDeletedEvent(ActivityDeletedEvent)
    case typeActivityFeedbackEvent(ActivityFeedbackEvent)
    case typeActivityMarkEvent(ActivityMarkEvent)
    case typeActivityPinnedEvent(ActivityPinnedEvent)
    case typeActivityReactionAddedEvent(ActivityReactionAddedEvent)
    case typeActivityReactionDeletedEvent(ActivityReactionDeletedEvent)
    case typeActivityReactionUpdatedEvent(ActivityReactionUpdatedEvent)
    case typeActivityRemovedFromFeedEvent(ActivityRemovedFromFeedEvent)
    case typeActivityUnpinnedEvent(ActivityUnpinnedEvent)
    case typeActivityUpdatedEvent(ActivityUpdatedEvent)
    case typeBookmarkAddedEvent(BookmarkAddedEvent)
    case typeBookmarkDeletedEvent(BookmarkDeletedEvent)
    case typeBookmarkUpdatedEvent(BookmarkUpdatedEvent)
    case typeBookmarkFolderDeletedEvent(BookmarkFolderDeletedEvent)
    case typeBookmarkFolderUpdatedEvent(BookmarkFolderUpdatedEvent)
    case typeCommentAddedEvent(CommentAddedEvent)
    case typeCommentDeletedEvent(CommentDeletedEvent)
    case typeCommentReactionAddedEvent(CommentReactionAddedEvent)
    case typeCommentReactionDeletedEvent(CommentReactionDeletedEvent)
    case typeCommentReactionUpdatedEvent(CommentReactionUpdatedEvent)
    case typeCommentUpdatedEvent(CommentUpdatedEvent)
    case typeFeedCreatedEvent(FeedCreatedEvent)
    case typeFeedDeletedEvent(FeedDeletedEvent)
    case typeFeedUpdatedEvent(FeedUpdatedEvent)
    case typeFeedGroupChangedEvent(FeedGroupChangedEvent)
    case typeFeedGroupDeletedEvent(FeedGroupDeletedEvent)
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
    case typeModerationMarkReviewedEvent(ModerationMarkReviewedEvent)
    case typeUserUpdatedEvent(UserUpdatedEvent)
    case typeUserBannedEvent(UserBannedEvent)
    case typeUserDeactivatedEvent(UserDeactivatedEvent)
    case typeUserMutedEvent(UserMutedEvent)
    case typeUserReactivatedEvent(UserReactivatedEvent)
    case typeConnectedEvent(ConnectedEvent)
    case typeConnectionErrorEvent(ConnectionErrorEvent)

    public var type: String {
        switch self {
        case .typeAppUpdatedEvent(let value):
            value.type
        case .typeActivityAddedEvent(let value):
            value.type
        case .typeActivityDeletedEvent(let value):
            value.type
        case .typeActivityMarkEvent(let value):
            value.type
        case .typeActivityPinnedEvent(let value):
            value.type
        case .typeActivityReactionAddedEvent(let value):
            value.type
        case .typeActivityReactionDeletedEvent(let value):
            value.type
        case .typeActivityReactionUpdatedEvent(let value):
            value.type
        case .typeActivityRemovedFromFeedEvent(let value):
            value.type
        case .typeActivityUnpinnedEvent(let value):
            value.type
        case .typeActivityUpdatedEvent(let value):
            value.type
        case .typeBookmarkAddedEvent(let value):
            value.type
        case .typeBookmarkDeletedEvent(let value):
            value.type
        case .typeBookmarkUpdatedEvent(let value):
            value.type
        case .typeBookmarkFolderDeletedEvent(let value):
            value.type
        case .typeBookmarkFolderUpdatedEvent(let value):
            value.type
        case .typeCommentAddedEvent(let value):
            value.type
        case .typeCommentDeletedEvent(let value):
            value.type
        case .typeCommentReactionAddedEvent(let value):
            value.type
        case .typeCommentReactionDeletedEvent(let value):
            value.type
        case .typeCommentReactionUpdatedEvent(let value):
            value.type
        case .typeCommentUpdatedEvent(let value):
            value.type
        case .typeFeedCreatedEvent(let value):
            value.type
        case .typeFeedDeletedEvent(let value):
            value.type
        case .typeFeedUpdatedEvent(let value):
            value.type
        case .typeFeedGroupChangedEvent(let value):
            value.type
        case .typeFeedGroupDeletedEvent(let value):
            value.type
        case .typeFeedMemberAddedEvent(let value):
            value.type
        case .typeFeedMemberRemovedEvent(let value):
            value.type
        case .typeFeedMemberUpdatedEvent(let value):
            value.type
        case .typeFollowCreatedEvent(let value):
            value.type
        case .typeFollowDeletedEvent(let value):
            value.type
        case .typeFollowUpdatedEvent(let value):
            value.type
        case .typeNotificationFeedUpdatedEvent(let value):
            value.type
        case .typePollClosedFeedEvent(let value):
            value.type
        case .typePollDeletedFeedEvent(let value):
            value.type
        case .typePollUpdatedFeedEvent(let value):
            value.type
        case .typePollVoteCastedFeedEvent(let value):
            value.type
        case .typePollVoteChangedFeedEvent(let value):
            value.type
        case .typePollVoteRemovedFeedEvent(let value):
            value.type
        case .typeHealthCheckEvent(let value):
            value.type
        case .typeModerationCustomActionEvent(let value):
            value.type
        case .typeModerationMarkReviewedEvent(let value):
            value.type
        case .typeUserBannedEvent(let value):
            value.type
        case .typeUserDeactivatedEvent(let value):
            value.type
        case .typeUserMutedEvent(let value):
            value.type
        case .typeUserReactivatedEvent(let value):
            value.type
        case .typeUserUpdatedEvent(let value):
            value.type
        case let .typeConnectedEvent(value):
            value.type
        case let .typeConnectionErrorEvent(value):
            value.type
        case let .typeActivityFeedbackEvent(value):
            value.type
        case let .typeStoriesFeedUpdatedEvent(value):
            value.type
        }
    }

    public var rawValue: Event {
        switch self {
        case .typeAppUpdatedEvent(let value):
            value
        case .typeActivityAddedEvent(let value):
            value
        case .typeActivityDeletedEvent(let value):
            value
        case .typeActivityMarkEvent(let value):
            value
        case .typeActivityPinnedEvent(let value):
            value
        case .typeActivityReactionAddedEvent(let value):
            value
        case .typeActivityReactionDeletedEvent(let value):
            value
        case .typeActivityReactionUpdatedEvent(let value):
            value
        case .typeActivityRemovedFromFeedEvent(let value):
            value
        case .typeActivityUnpinnedEvent(let value):
            value
        case .typeActivityUpdatedEvent(let value):
            value
        case .typeBookmarkAddedEvent(let value):
            value
        case .typeBookmarkDeletedEvent(let value):
            value
        case .typeBookmarkUpdatedEvent(let value):
            value
        case .typeBookmarkFolderDeletedEvent(let value):
            value
        case .typeBookmarkFolderUpdatedEvent(let value):
            value
        case .typeCommentAddedEvent(let value):
            value
        case .typeCommentDeletedEvent(let value):
            value
        case .typeCommentReactionAddedEvent(let value):
            value
        case .typeCommentReactionDeletedEvent(let value):
            value
        case .typeCommentReactionUpdatedEvent(let value):
            value
        case .typeCommentUpdatedEvent(let value):
            value
        case .typeFeedCreatedEvent(let value):
            value
        case .typeFeedDeletedEvent(let value):
            value
        case .typeFeedUpdatedEvent(let value):
            value
        case .typeFeedGroupChangedEvent(let value):
            value
        case .typeFeedGroupDeletedEvent(let value):
            value
        case .typeFeedMemberAddedEvent(let value):
            value
        case .typeFeedMemberRemovedEvent(let value):
            value
        case .typeFeedMemberUpdatedEvent(let value):
            value
        case .typeFollowCreatedEvent(let value):
            value
        case .typeFollowDeletedEvent(let value):
            value
        case .typeFollowUpdatedEvent(let value):
            value
        case .typeNotificationFeedUpdatedEvent(let value):
            value
        case .typePollClosedFeedEvent(let value):
            value
        case .typePollDeletedFeedEvent(let value):
            value
        case .typePollUpdatedFeedEvent(let value):
            value
        case .typePollVoteCastedFeedEvent(let value):
            value
        case .typePollVoteChangedFeedEvent(let value):
            value
        case .typePollVoteRemovedFeedEvent(let value):
            value
        case .typeHealthCheckEvent(let value):
            value
        case .typeModerationCustomActionEvent(let value):
            value
        case .typeModerationMarkReviewedEvent(let value):
            value
        case .typeUserBannedEvent(let value):
            value
        case .typeUserDeactivatedEvent(let value):
            value
        case .typeUserMutedEvent(let value):
            value
        case .typeUserReactivatedEvent(let value):
            value
        case .typeUserUpdatedEvent(let value):
            value
        case .typeConnectedEvent(let value):
            value
        case .typeConnectionErrorEvent(let value):
            value
        case .typeActivityFeedbackEvent(let value):
            value
        case .typeStoriesFeedUpdatedEvent(let value):
            value
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .typeAppUpdatedEvent(let value):
            try container.encode(value)
        case .typeActivityAddedEvent(let value):
            try container.encode(value)
        case .typeActivityDeletedEvent(let value):
            try container.encode(value)
        case .typeActivityMarkEvent(let value):
            try container.encode(value)
        case .typeActivityPinnedEvent(let value):
            try container.encode(value)
        case .typeActivityReactionAddedEvent(let value):
            try container.encode(value)
        case .typeActivityReactionDeletedEvent(let value):
            try container.encode(value)
        case .typeActivityReactionUpdatedEvent(let value):
            try container.encode(value)
        case .typeActivityRemovedFromFeedEvent(let value):
            try container.encode(value)
        case .typeActivityUnpinnedEvent(let value):
            try container.encode(value)
        case .typeActivityUpdatedEvent(let value):
            try container.encode(value)
        case .typeBookmarkAddedEvent(let value):
            try container.encode(value)
        case .typeBookmarkDeletedEvent(let value):
            try container.encode(value)
        case .typeBookmarkUpdatedEvent(let value):
            try container.encode(value)
        case .typeBookmarkFolderDeletedEvent(let value):
            try container.encode(value)
        case .typeBookmarkFolderUpdatedEvent(let value):
            try container.encode(value)
        case .typeCommentAddedEvent(let value):
            try container.encode(value)
        case .typeCommentDeletedEvent(let value):
            try container.encode(value)
        case .typeCommentReactionAddedEvent(let value):
            try container.encode(value)
        case .typeCommentReactionDeletedEvent(let value):
            try container.encode(value)
        case .typeCommentReactionUpdatedEvent(let value):
            try container.encode(value)
        case .typeCommentUpdatedEvent(let value):
            try container.encode(value)
        case .typeFeedCreatedEvent(let value):
            try container.encode(value)
        case .typeFeedDeletedEvent(let value):
            try container.encode(value)
        case .typeFeedUpdatedEvent(let value):
            try container.encode(value)
        case .typeFeedGroupChangedEvent(let value):
            try container.encode(value)
        case .typeFeedGroupDeletedEvent(let value):
            try container.encode(value)
        case .typeFeedMemberAddedEvent(let value):
            try container.encode(value)
        case .typeFeedMemberRemovedEvent(let value):
            try container.encode(value)
        case .typeFeedMemberUpdatedEvent(let value):
            try container.encode(value)
        case .typeFollowCreatedEvent(let value):
            try container.encode(value)
        case .typeFollowDeletedEvent(let value):
            try container.encode(value)
        case .typeFollowUpdatedEvent(let value):
            try container.encode(value)
        case .typeNotificationFeedUpdatedEvent(let value):
            try container.encode(value)
        case .typePollClosedFeedEvent(let value):
            try container.encode(value)
        case .typePollDeletedFeedEvent(let value):
            try container.encode(value)
        case .typePollUpdatedFeedEvent(let value):
            try container.encode(value)
        case .typePollVoteCastedFeedEvent(let value):
            try container.encode(value)
        case .typePollVoteChangedFeedEvent(let value):
            try container.encode(value)
        case .typePollVoteRemovedFeedEvent(let value):
            try container.encode(value)
        case .typeHealthCheckEvent(let value):
            try container.encode(value)
        case .typeModerationCustomActionEvent(let value):
            try container.encode(value)
        case .typeModerationMarkReviewedEvent(let value):
            try container.encode(value)
        case .typeUserBannedEvent(let value):
            try container.encode(value)
        case .typeUserDeactivatedEvent(let value):
            try container.encode(value)
        case .typeUserMutedEvent(let value):
            try container.encode(value)
        case .typeUserReactivatedEvent(let value):
            try container.encode(value)
        case .typeUserUpdatedEvent(let value):
            try container.encode(value)
        case .typeConnectedEvent(let value):
            try container.encode(value)
        case .typeConnectionErrorEvent(let value):
            try container.encode(value)
        case .typeActivityFeedbackEvent(let value):
            try container.encode(value)
        case .typeStoriesFeedUpdatedEvent(let value):
            try container.encode(value)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dto = try container.decode(WSEventMapping.self)
        if dto.type == "app.updated" {
            let value = try container.decode(AppUpdatedEvent.self)
            self = .typeAppUpdatedEvent(value)
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
        } else if dto.type == "feeds.comment.reaction.added" {
            let value = try container.decode(CommentReactionAddedEvent.self)
            self = .typeCommentReactionAddedEvent(value)
        } else if dto.type == "feeds.comment.reaction.deleted" {
            let value = try container.decode(CommentReactionDeletedEvent.self)
            self = .typeCommentReactionDeletedEvent(value)
        } else if dto.type == "feeds.comment.reaction.updated" {
            let value = try container.decode(CommentReactionUpdatedEvent.self)
            self = .typeCommentReactionUpdatedEvent(value)
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
        } else if dto.type == "moderation.mark_reviewed" {
            let value = try container.decode(ModerationMarkReviewedEvent.self)
            self = .typeModerationMarkReviewedEvent(value)
        } else if dto.type == "user.banned" {
            let value = try container.decode(UserBannedEvent.self)
            self = .typeUserBannedEvent(value)
        } else if dto.type == "user.deactivated" {
            let value = try container.decode(UserDeactivatedEvent.self)
            self = .typeUserDeactivatedEvent(value)
        } else if dto.type == "user.muted" {
            let value = try container.decode(UserMutedEvent.self)
            self = .typeUserMutedEvent(value)
        } else if dto.type == "user.reactivated" {
            let value = try container.decode(UserReactivatedEvent.self)
            self = .typeUserReactivatedEvent(value)
        } else if dto.type == "user.updated" {
            let value = try container.decode(UserUpdatedEvent.self)
            self = .typeUserUpdatedEvent(value)
        } else if dto.type == "connection.ok" {
            let value = try container.decode(ConnectedEvent.self)
            self = .typeConnectedEvent(value)
        } else if dto.type == "connection.error" {
            let value = try container.decode(ConnectionErrorEvent.self)
            self = .typeConnectionErrorEvent(value)
        } else {
            throw DecodingError.typeMismatch(Self.Type.self, .init(codingPath: decoder.codingPath, debugDescription: "Unable to decode instance of WSEvent"))
        }
    }
}
