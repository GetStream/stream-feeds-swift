import Foundation
import StreamCore

private class WSEventMapping: Decodable {
    let type: String
}

public enum WSClientEvent: Codable, Hashable {
    case typeActivityAddedEvent(ActivityAddedEvent)
    case typeActivityDeletedEvent(ActivityDeletedEvent)
    case typeActivityReactionAddedEvent(ActivityReactionAddedEvent)
    case typeActivityReactionDeletedEvent(ActivityReactionDeletedEvent)
    case typeActivityRemovedFromFeedEvent(ActivityRemovedFromFeedEvent)
    case typeActivityUpdatedEvent(ActivityUpdatedEvent)
    case typeBookmarkAddedEvent(BookmarkAddedEvent)
    case typeBookmarkDeletedEvent(BookmarkDeletedEvent)
    case typeBookmarkUpdatedEvent(BookmarkUpdatedEvent)
    case typeCommentAddedEvent(CommentAddedEvent)
    case typeCommentDeletedEvent(CommentDeletedEvent)
    case typeCommentReactionAddedEvent(CommentReactionAddedEvent)
    case typeCommentReactionRemovedEvent(CommentReactionRemovedEvent)
    case typeCommentUpdatedEvent(CommentUpdatedEvent)
    case typeFeedCreatedEvent(FeedCreatedEvent)
    case typeFeedDeletedEvent(FeedDeletedEvent)
    case typeFeedUpdatedEvent(FeedUpdatedEvent)
    case typeFeedGroupChangedEvent(FeedGroupChangedEvent)
    case typeFeedGroupDeletedEvent(FeedGroupDeletedEvent)
    case typeFollowAddedEvent(FollowAddedEvent)
    case typeFollowRemovedEvent(FollowRemovedEvent)
    case typeFollowUpdatedEvent(FollowUpdatedEvent)

    public var type: String {
        switch self {
        case let .typeActivityAddedEvent(value):
            return value.type
        case let .typeActivityDeletedEvent(value):
            return value.type
        case let .typeActivityReactionAddedEvent(value):
            return value.type
        case let .typeActivityReactionDeletedEvent(value):
            return value.type
        case let .typeActivityRemovedFromFeedEvent(value):
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
        case let .typeCommentReactionRemovedEvent(value):
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
        case let .typeFollowAddedEvent(value):
            return value.type
        case let .typeFollowRemovedEvent(value):
            return value.type
        case let .typeFollowUpdatedEvent(value):
            return value.type
        }
    }

    public var rawValue: Event {
        switch self {
        case let .typeActivityAddedEvent(value):
            return value
        case let .typeActivityDeletedEvent(value):
            return value
        case let .typeActivityReactionAddedEvent(value):
            return value
        case let .typeActivityReactionDeletedEvent(value):
            return value
        case let .typeActivityRemovedFromFeedEvent(value):
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
        case let .typeCommentReactionRemovedEvent(value):
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
        case let .typeFollowAddedEvent(value):
            return value
        case let .typeFollowRemovedEvent(value):
            return value
        case let .typeFollowUpdatedEvent(value):
            return value
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .typeActivityAddedEvent(value):
            try container.encode(value)
        case let .typeActivityDeletedEvent(value):
            try container.encode(value)
        case let .typeActivityReactionAddedEvent(value):
            try container.encode(value)
        case let .typeActivityReactionDeletedEvent(value):
            try container.encode(value)
        case let .typeActivityRemovedFromFeedEvent(value):
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
        case let .typeCommentReactionRemovedEvent(value):
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
        case let .typeFollowAddedEvent(value):
            try container.encode(value)
        case let .typeFollowRemovedEvent(value):
            try container.encode(value)
        case let .typeFollowUpdatedEvent(value):
            try container.encode(value)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dto = try container.decode(WSEventMapping.self)
        if dto.type == "activity.added" {
            let value = try container.decode(ActivityAddedEvent.self)
            self = .typeActivityAddedEvent(value)
        } else if dto.type == "activity.deleted" {
            let value = try container.decode(ActivityDeletedEvent.self)
            self = .typeActivityDeletedEvent(value)
        } else if dto.type == "activity.reaction.added" {
            let value = try container.decode(ActivityReactionAddedEvent.self)
            self = .typeActivityReactionAddedEvent(value)
        } else if dto.type == "activity.reaction.deleted" {
            let value = try container.decode(ActivityReactionDeletedEvent.self)
            self = .typeActivityReactionDeletedEvent(value)
        } else if dto.type == "activity.removed_from_feed" {
            let value = try container.decode(ActivityRemovedFromFeedEvent.self)
            self = .typeActivityRemovedFromFeedEvent(value)
        } else if dto.type == "activity.updated" {
            let value = try container.decode(ActivityUpdatedEvent.self)
            self = .typeActivityUpdatedEvent(value)
        } else if dto.type == "bookmark.added" {
            let value = try container.decode(BookmarkAddedEvent.self)
            self = .typeBookmarkAddedEvent(value)
        } else if dto.type == "bookmark.deleted" {
            let value = try container.decode(BookmarkDeletedEvent.self)
            self = .typeBookmarkDeletedEvent(value)
        } else if dto.type == "bookmark.updated" {
            let value = try container.decode(BookmarkUpdatedEvent.self)
            self = .typeBookmarkUpdatedEvent(value)
        } else if dto.type == "comment.added" {
            let value = try container.decode(CommentAddedEvent.self)
            self = .typeCommentAddedEvent(value)
        } else if dto.type == "comment.deleted" {
            let value = try container.decode(CommentDeletedEvent.self)
            self = .typeCommentDeletedEvent(value)
        } else if dto.type == "comment.reaction.added" {
            let value = try container.decode(CommentReactionAddedEvent.self)
            self = .typeCommentReactionAddedEvent(value)
        } else if dto.type == "comment.reaction.removed" {
            let value = try container.decode(CommentReactionRemovedEvent.self)
            self = .typeCommentReactionRemovedEvent(value)
        } else if dto.type == "comment.updated" {
            let value = try container.decode(CommentUpdatedEvent.self)
            self = .typeCommentUpdatedEvent(value)
        } else if dto.type == "feed.created" {
            let value = try container.decode(FeedCreatedEvent.self)
            self = .typeFeedCreatedEvent(value)
        } else if dto.type == "feed.deleted" {
            let value = try container.decode(FeedDeletedEvent.self)
            self = .typeFeedDeletedEvent(value)
        } else if dto.type == "feed.updated" {
            let value = try container.decode(FeedUpdatedEvent.self)
            self = .typeFeedUpdatedEvent(value)
        } else if dto.type == "feed_group.changed" {
            let value = try container.decode(FeedGroupChangedEvent.self)
            self = .typeFeedGroupChangedEvent(value)
        } else if dto.type == "feed_group.deleted" {
            let value = try container.decode(FeedGroupDeletedEvent.self)
            self = .typeFeedGroupDeletedEvent(value)
        } else if dto.type == "follow.added" {
            let value = try container.decode(FollowAddedEvent.self)
            self = .typeFollowAddedEvent(value)
        } else if dto.type == "follow.removed" {
            let value = try container.decode(FollowRemovedEvent.self)
            self = .typeFollowRemovedEvent(value)
        } else if dto.type == "follow.updated" {
            let value = try container.decode(FollowUpdatedEvent.self)
            self = .typeFollowUpdatedEvent(value)
        } else {
            throw DecodingError.typeMismatch(Self.Type.self, .init(codingPath: decoder.codingPath, debugDescription: "Unable to decode instance of WSClientEvent"))
        }
    }
}
