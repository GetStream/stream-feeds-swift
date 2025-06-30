import Foundation
import StreamCore

private class WSEventMapping: Decodable {
    let type: String
}

public enum FeedsEvent: Codable, Hashable {
    case typeAppUpdatedEvent(AppUpdatedEvent)
    case typeActivityAddedEvent(ActivityAddedEvent)
    case typeActivityDeletedEvent(ActivityDeletedEvent)
    case typeActivityMarkEvent(ActivityMarkEvent)
    case typeActivityPinnedEvent(ActivityPinnedEvent)
    case typeActivityReactionAddedEvent(ActivityReactionAddedEvent)
    case typeActivityReactionDeletedEvent(ActivityReactionDeletedEvent)
    case typeActivityRemovedFromFeedEvent(ActivityRemovedFromFeedEvent)
    case typeActivityUnpinnedEvent(ActivityUnpinnedEvent)
    case typeActivityUpdatedEvent(ActivityUpdatedEvent)
    case typeBookmarkAddedEvent(BookmarkAddedEvent)
    case typeBookmarkDeletedEvent(BookmarkDeletedEvent)
    case typeBookmarkUpdatedEvent(BookmarkUpdatedEvent)
    case typeCommentAddedEvent(CommentAddedEvent)
    case typeCommentDeletedEvent(CommentDeletedEvent)
    case typeCommentReactionAddedEvent(CommentReactionAddedEvent)
    case typeCommentReactionDeletedEvent(CommentReactionDeletedEvent)
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
    case typePollClosedFeedEvent(PollClosedFeedEvent)
    case typePollDeletedFeedEvent(PollDeletedFeedEvent)
    case typePollUpdatedFeedEvent(PollUpdatedFeedEvent)
    case typePollVoteCastedFeedEvent(PollVoteCastedFeedEvent)
    case typePollVoteChangedFeedEvent(PollVoteChangedFeedEvent)
    case typePollVoteRemovedFeedEvent(PollVoteRemovedFeedEvent)
    case typeHealthCheckEvent(HealthCheckEvent)
    case typeModerationCustomActionEvent(ModerationCustomActionEvent)
    case typeModerationFlaggedEvent(ModerationFlaggedEvent)
    case typeModerationMarkReviewedEvent(ModerationMarkReviewedEvent)
    case typeUserBannedEvent(UserBannedEvent)
    case typeUserDeactivatedEvent(UserDeactivatedEvent)
    case typeUserMutedEvent(UserMutedEvent)
    case typeUserReactivatedEvent(UserReactivatedEvent)
    case typeUserUpdatedEvent(UserUpdatedEvent)
    case typeConnectedEvent(ConnectedEvent)
    case typeConnectionErrorEvent(ConnectionErrorEvent)

    public var type: String {
        switch self {
        case let .typeAppUpdatedEvent(value):
            return value.type
        case let .typeActivityAddedEvent(value):
            return value.type
        case let .typeActivityDeletedEvent(value):
            return value.type
        case let .typeActivityMarkEvent(value):
            return value.type
        case let .typeActivityPinnedEvent(value):
            return value.type
        case let .typeActivityReactionAddedEvent(value):
            return value.type
        case let .typeActivityReactionDeletedEvent(value):
            return value.type
        case let .typeActivityRemovedFromFeedEvent(value):
            return value.type
        case let .typeActivityUnpinnedEvent(value):
            return value.type
        case let .typeActivityUpdatedEvent(value):
            return value.type
        case let .typeBookmarkAddedEvent(value):
            return value.type
        case let .typeBookmarkDeletedEvent(value):
            return value.type
        case let .typeBookmarkUpdatedEvent(value):
            return value.type
        case let .typeCommentAddedEvent(value):
            return value.type
        case let .typeCommentDeletedEvent(value):
            return value.type
        case let .typeCommentReactionAddedEvent(value):
            return value.type
        case let .typeCommentReactionDeletedEvent(value):
            return value.type
        case let .typeCommentUpdatedEvent(value):
            return value.type
        case let .typeFeedCreatedEvent(value):
            return value.type
        case let .typeFeedDeletedEvent(value):
            return value.type
        case let .typeFeedUpdatedEvent(value):
            return value.type
        case let .typeFeedGroupChangedEvent(value):
            return value.type
        case let .typeFeedGroupDeletedEvent(value):
            return value.type
        case let .typeFeedMemberAddedEvent(value):
            return value.type
        case let .typeFeedMemberRemovedEvent(value):
            return value.type
        case let .typeFeedMemberUpdatedEvent(value):
            return value.type
        case let .typeFollowCreatedEvent(value):
            return value.type
        case let .typeFollowDeletedEvent(value):
            return value.type
        case let .typeFollowUpdatedEvent(value):
            return value.type
        case let .typePollClosedFeedEvent(value):
            return value.type
        case let .typePollDeletedFeedEvent(value):
            return value.type
        case let .typePollUpdatedFeedEvent(value):
            return value.type
        case let .typePollVoteCastedFeedEvent(value):
            return value.type
        case let .typePollVoteChangedFeedEvent(value):
            return value.type
        case let .typePollVoteRemovedFeedEvent(value):
            return value.type
        case let .typeHealthCheckEvent(value):
            return value.type
        case let .typeModerationCustomActionEvent(value):
            return value.type
        case let .typeModerationFlaggedEvent(value):
            return value.type
        case let .typeModerationMarkReviewedEvent(value):
            return value.type
        case let .typeUserBannedEvent(value):
            return value.type
        case let .typeUserDeactivatedEvent(value):
            return value.type
        case let .typeUserMutedEvent(value):
            return value.type
        case let .typeUserReactivatedEvent(value):
            return value.type
        case let .typeUserUpdatedEvent(value):
            return value.type
        case let .typeConnectedEvent(value):
            return value.type
        case let .typeConnectionErrorEvent(value):
            return value.type
        }
    }

    public var rawValue: Event {
        switch self {
        case let .typeAppUpdatedEvent(value):
            return value
        case let .typeActivityAddedEvent(value):
            return value
        case let .typeActivityDeletedEvent(value):
            return value
        case let .typeActivityMarkEvent(value):
            return value
        case let .typeActivityPinnedEvent(value):
            return value
        case let .typeActivityReactionAddedEvent(value):
            return value
        case let .typeActivityReactionDeletedEvent(value):
            return value
        case let .typeActivityRemovedFromFeedEvent(value):
            return value
        case let .typeActivityUnpinnedEvent(value):
            return value
        case let .typeActivityUpdatedEvent(value):
            return value
        case let .typeBookmarkAddedEvent(value):
            return value
        case let .typeBookmarkDeletedEvent(value):
            return value
        case let .typeBookmarkUpdatedEvent(value):
            return value
        case let .typeCommentAddedEvent(value):
            return value
        case let .typeCommentDeletedEvent(value):
            return value
        case let .typeCommentReactionAddedEvent(value):
            return value
        case let .typeCommentReactionDeletedEvent(value):
            return value
        case let .typeCommentUpdatedEvent(value):
            return value
        case let .typeFeedCreatedEvent(value):
            return value
        case let .typeFeedDeletedEvent(value):
            return value
        case let .typeFeedUpdatedEvent(value):
            return value
        case let .typeFeedGroupChangedEvent(value):
            return value
        case let .typeFeedGroupDeletedEvent(value):
            return value
        case let .typeFeedMemberAddedEvent(value):
            return value
        case let .typeFeedMemberRemovedEvent(value):
            return value
        case let .typeFeedMemberUpdatedEvent(value):
            return value
        case let .typeFollowCreatedEvent(value):
            return value
        case let .typeFollowDeletedEvent(value):
            return value
        case let .typeFollowUpdatedEvent(value):
            return value
        case let .typePollClosedFeedEvent(value):
            return value
        case let .typePollDeletedFeedEvent(value):
            return value
        case let .typePollUpdatedFeedEvent(value):
            return value
        case let .typePollVoteCastedFeedEvent(value):
            return value
        case let .typePollVoteChangedFeedEvent(value):
            return value
        case let .typePollVoteRemovedFeedEvent(value):
            return value
        case let .typeHealthCheckEvent(value):
            return value
        case let .typeModerationCustomActionEvent(value):
            return value
        case let .typeModerationFlaggedEvent(value):
            return value
        case let .typeModerationMarkReviewedEvent(value):
            return value
        case let .typeUserBannedEvent(value):
            return value
        case let .typeUserDeactivatedEvent(value):
            return value
        case let .typeUserMutedEvent(value):
            return value
        case let .typeUserReactivatedEvent(value):
            return value
        case let .typeUserUpdatedEvent(value):
            return value
        case let .typeConnectedEvent(value):
            return value
        case let .typeConnectionErrorEvent(value):
            return value
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .typeAppUpdatedEvent(value):
            try container.encode(value)
        case let .typeActivityAddedEvent(value):
            try container.encode(value)
        case let .typeActivityDeletedEvent(value):
            try container.encode(value)
        case let .typeActivityMarkEvent(value):
            try container.encode(value)
        case let .typeActivityPinnedEvent(value):
            try container.encode(value)
        case let .typeActivityReactionAddedEvent(value):
            try container.encode(value)
        case let .typeActivityReactionDeletedEvent(value):
            try container.encode(value)
        case let .typeActivityRemovedFromFeedEvent(value):
            try container.encode(value)
        case let .typeActivityUnpinnedEvent(value):
            try container.encode(value)
        case let .typeActivityUpdatedEvent(value):
            try container.encode(value)
        case let .typeBookmarkAddedEvent(value):
            try container.encode(value)
        case let .typeBookmarkDeletedEvent(value):
            try container.encode(value)
        case let .typeBookmarkUpdatedEvent(value):
            try container.encode(value)
        case let .typeCommentAddedEvent(value):
            try container.encode(value)
        case let .typeCommentDeletedEvent(value):
            try container.encode(value)
        case let .typeCommentReactionAddedEvent(value):
            try container.encode(value)
        case let .typeCommentReactionDeletedEvent(value):
            try container.encode(value)
        case let .typeCommentUpdatedEvent(value):
            try container.encode(value)
        case let .typeFeedCreatedEvent(value):
            try container.encode(value)
        case let .typeFeedDeletedEvent(value):
            try container.encode(value)
        case let .typeFeedUpdatedEvent(value):
            try container.encode(value)
        case let .typeFeedGroupChangedEvent(value):
            try container.encode(value)
        case let .typeFeedGroupDeletedEvent(value):
            try container.encode(value)
        case let .typeFeedMemberAddedEvent(value):
            try container.encode(value)
        case let .typeFeedMemberRemovedEvent(value):
            try container.encode(value)
        case let .typeFeedMemberUpdatedEvent(value):
            try container.encode(value)
        case let .typeFollowCreatedEvent(value):
            try container.encode(value)
        case let .typeFollowDeletedEvent(value):
            try container.encode(value)
        case let .typeFollowUpdatedEvent(value):
            try container.encode(value)
        case let .typePollClosedFeedEvent(value):
            try container.encode(value)
        case let .typePollDeletedFeedEvent(value):
            try container.encode(value)
        case let .typePollUpdatedFeedEvent(value):
            try container.encode(value)
        case let .typePollVoteCastedFeedEvent(value):
            try container.encode(value)
        case let .typePollVoteChangedFeedEvent(value):
            try container.encode(value)
        case let .typePollVoteRemovedFeedEvent(value):
            try container.encode(value)
        case let .typeHealthCheckEvent(value):
            try container.encode(value)
        case let .typeModerationCustomActionEvent(value):
            try container.encode(value)
        case let .typeModerationFlaggedEvent(value):
            try container.encode(value)
        case let .typeModerationMarkReviewedEvent(value):
            try container.encode(value)
        case let .typeUserBannedEvent(value):
            try container.encode(value)
        case let .typeUserDeactivatedEvent(value):
            try container.encode(value)
        case let .typeUserMutedEvent(value):
            try container.encode(value)
        case let .typeUserReactivatedEvent(value):
            try container.encode(value)
        case let .typeUserUpdatedEvent(value):
            try container.encode(value)
        case let .typeConnectedEvent(value):
            try container.encode(value)
        case let .typeConnectionErrorEvent(value):
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
