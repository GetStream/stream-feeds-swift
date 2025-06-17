import Foundation
import StreamCore

private class WSEventMapping: Decodable {
    let type: String
}

public enum FeedsEvent: Codable, Hashable {
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
    case typePollClosedFeedEvent(PollClosedFeedEvent)
    case typePollDeletedFeedEvent(PollDeletedFeedEvent)
    case typePollUpdatedFeedEvent(PollUpdatedFeedEvent)
    case typePollVoteCastedFeedEvent(PollVoteCastedFeedEvent)
    case typePollVoteChangedFeedEvent(PollVoteChangedFeedEvent)
    case typePollVoteRemovedFeedEvent(PollVoteRemovedFeedEvent)
    case typeFollowCreatedEvent(FollowCreatedEvent)
    case typeFollowDeletedEvent(FollowDeletedEvent)
    case typeFollowUpdatedEvent(FollowUpdatedEvent)
    case typePollClosedEvent(PollClosedFeedEvent)
    case typePollDeletedEvent(PollDeletedFeedEvent)
    case typePollUpdatedEvent(PollUpdatedFeedEvent)
    case typeConnectedEvent(ConnectedEvent)
    case typeHealthCheckEvent(HealthCheckEvent)
    case typeConnectionErrorEvent(ConnectionErrorEvent)

    public var type: String {
        switch self { 
        case .typeActivityAddedEvent(let value):
            return value.type
        case .typeActivityDeletedEvent(let value):
            return value.type
        case .typeActivityPinnedEvent(let value):
            return value.type
        case .typeActivityReactionAddedEvent(let value):
            return value.type
        case .typeActivityReactionDeletedEvent(let value):
            return value.type
        case .typeActivityRemovedFromFeedEvent(let value):
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
        case .typeCommentAddedEvent(let value):
            return value.type
        case .typeCommentDeletedEvent(let value):
            return value.type
        case .typeCommentReactionAddedEvent(let value):
            return value.type
        case .typeCommentReactionDeletedEvent(let value):
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
        case .typeFeedMemberAddedEvent(let value):
            return value.type
        case .typeFeedMemberRemovedEvent(let value):
            return value.type
        case .typeFeedMemberUpdatedEvent(let value):
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
        case .typeFollowCreatedEvent(let value):
            return value.type
        case .typeFollowDeletedEvent(let value):
            return value.type
        case .typeFollowUpdatedEvent(let value):
            return value.type
        case .typePollClosedEvent(let value):
            return value.type
        case .typePollDeletedEvent(let value):
            return value.type
        case .typePollUpdatedEvent(let value):
            return value.type
        case .typeConnectedEvent(let value):
            return value.type
        case .typeHealthCheckEvent(let value):
            return value.type
        case .typeConnectionErrorEvent(let value):
            return value.type
        case .typeActivityMarkEvent(let value):
            return value.type
        }
    }

    public var rawValue: Event {
        switch self {
        case .typeActivityAddedEvent(let value):
            return value
        case .typeActivityDeletedEvent(let value):
            return value
        case .typeActivityPinnedEvent(let value):
            return value
        case .typeActivityReactionAddedEvent(let value):
            return value
        case .typeActivityReactionDeletedEvent(let value):
            return value
        case .typeActivityRemovedFromFeedEvent(let value):
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
        case .typeCommentAddedEvent(let value):
            return value
        case .typeCommentDeletedEvent(let value):
            return value
        case .typeCommentReactionAddedEvent(let value):
            return value
        case .typeCommentReactionDeletedEvent(let value):
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
        case .typeFeedMemberAddedEvent(let value):
            return value
        case .typeFeedMemberRemovedEvent(let value):
            return value
        case .typeFeedMemberUpdatedEvent(let value):
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
        case .typeFollowCreatedEvent(let value):
            return value
        case .typeFollowDeletedEvent(let value):
            return value
        case .typeFollowUpdatedEvent(let value):
            return value
        case .typePollClosedEvent(let value):
            return value
        case .typePollDeletedEvent(let value):
            return value
        case .typePollUpdatedEvent(let value):
            return value
        case .typeConnectedEvent(let value):
            return value
        case .typeHealthCheckEvent(let value):
            return value
        case .typeConnectionErrorEvent(let value):
            return value
        case .typeActivityMarkEvent(let value):
            return value
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self { 
        case .typeActivityAddedEvent(let value):
            try container.encode(value)
        case .typeActivityDeletedEvent(let value):
            try container.encode(value)
        case .typeActivityPinnedEvent(let value):
            try container.encode(value)
        case .typeActivityReactionAddedEvent(let value):
            try container.encode(value)
        case .typeActivityReactionDeletedEvent(let value):
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
        case .typeCommentAddedEvent(let value):
            try container.encode(value)
        case .typeCommentDeletedEvent(let value):
            try container.encode(value)
        case .typeCommentReactionAddedEvent(let value):
            try container.encode(value)
        case .typeCommentReactionDeletedEvent(let value):
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
        case .typeFollowCreatedEvent(let value):
            try container.encode(value)
        case .typeFollowDeletedEvent(let value):
            try container.encode(value)
        case .typeFollowUpdatedEvent(let value):
            try container.encode(value)
        case .typePollClosedEvent(let value):
            try container.encode(value)
        case .typePollDeletedEvent(let value):
            try container.encode(value)
        case .typePollUpdatedEvent(let value):
            try container.encode(value)
        case .typeConnectedEvent(let value):
            try container.encode(value)
        case .typeHealthCheckEvent(let value):
            try container.encode(value)
        case .typeConnectionErrorEvent(let value):
            try container.encode(value)
        case .typeActivityMarkEvent(let value):
            try container.encode(value)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dto = try container.decode(WSEventMapping.self)
        if dto.type == "feeds.activity.added" {
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
            self = .typePollClosedEvent(value)
        } else if dto.type == "feeds.poll.deleted" {
            let value = try container.decode(PollDeletedFeedEvent.self)
            self = .typePollDeletedEvent(value)
        } else if dto.type == "feeds.poll.updated" {
            let value = try container.decode(PollUpdatedFeedEvent.self)
            self = .typePollUpdatedEvent(value)
        } else if dto.type == "connection.ok" {
            let value = try container.decode(ConnectedEvent.self)
            self = .typeConnectedEvent(value)
        } else if dto.type == "health.check" {
            let value = try container.decode(HealthCheckEvent.self)
            self = .typeHealthCheckEvent(value)
        } else if dto.type == "connection.error" {
            let value = try container.decode(ConnectionErrorEvent.self)
            self = .typeConnectionErrorEvent(value)
        } else {
            throw DecodingError.typeMismatch(Self.Type.self, .init(codingPath: decoder.codingPath, debugDescription: "Unable to decode instance of WSEvent"))
        }
    }
}
