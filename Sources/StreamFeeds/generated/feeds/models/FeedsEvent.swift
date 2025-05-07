import Foundation
import StreamCore

private class WSEventMapping: Decodable {
    let type: String
}

public enum FeedsEvent: Codable, Hashable {
    case typeActivityAddedEvent(ActivityAddedEvent)
    case typeReactionAddedEvent(ReactionAddedEvent)
    case typeReactionRemovedEvent(ReactionRemovedEvent)
    case typeActivityRemovedEvent(ActivityRemovedEvent)
    case typeActivityUpdatedEvent(ActivityUpdatedEvent)
    case typeBookmarkAddedEvent(BookmarkAddedEvent)
    case typeBookmarkRemovedEvent(BookmarkRemovedEvent)
    case typeBookmarkUpdatedEvent(BookmarkUpdatedEvent)
    case typeCommentAddedEvent(CommentAddedEvent)
    case typeCommentRemovedEvent(CommentRemovedEvent)
    case typeCommentUpdatedEvent(CommentUpdatedEvent)
    case typeFeedCreatedEvent(FeedCreatedEvent)
    case typeFeedRemovedEvent(FeedRemovedEvent)
    case typeFeedGroupChangedEvent(FeedGroupChangedEvent)
    case typeFeedGroupRemovedEvent(FeedGroupRemovedEvent)
    case typeFollowAddedEvent(FollowAddedEvent)
    case typeFollowRemovedEvent(FollowRemovedEvent)
    case typeFollowUpdatedEvent(FollowUpdatedEvent)
    case typeConnectedEvent(ConnectedEvent)
    case typeHealthCheckEvent(HealthCheckEvent)
    case typeConnectionErrorEvent(ConnectionErrorEvent)
    
    public var type: String {
        switch self {
        case let .typeActivityAddedEvent(value):
            return value.type
        case let .typeReactionAddedEvent(value):
            return value.type
        case let .typeReactionRemovedEvent(value):
            return value.type
        case let .typeActivityRemovedEvent(value):
            return value.type
        case let .typeActivityUpdatedEvent(value):
            return value.type
        case let .typeBookmarkAddedEvent(value):
            return value.type
        case let .typeBookmarkRemovedEvent(value):
            return value.type
        case let .typeBookmarkUpdatedEvent(value):
            return value.type
        case let .typeCommentAddedEvent(value):
            return value.type
        case let .typeCommentRemovedEvent(value):
            return value.type
        case let .typeCommentUpdatedEvent(value):
            return value.type
        case let .typeFeedCreatedEvent(value):
            return value.type
        case let .typeFeedRemovedEvent(value):
            return value.type
        case let .typeFeedGroupChangedEvent(value):
            return value.type
        case let .typeFeedGroupRemovedEvent(value):
            return value.type
        case let .typeFollowAddedEvent(value):
            return value.type
        case let .typeFollowRemovedEvent(value):
            return value.type
        case let .typeFollowUpdatedEvent(value):
            return value.type
        case let .typeConnectedEvent(value):
            return value.type
        case let .typeHealthCheckEvent(value):
            return value.type
        case let .typeConnectionErrorEvent(value):
            return value.type
        }
    }

    public var rawValue: Event {
        switch self {
        case let .typeActivityAddedEvent(value):
            return value
        case let .typeReactionAddedEvent(value):
            return value
        case let .typeReactionRemovedEvent(value):
            return value
        case let .typeActivityRemovedEvent(value):
            return value
        case let .typeActivityUpdatedEvent(value):
            return value
        case let .typeBookmarkAddedEvent(value):
            return value
        case let .typeBookmarkRemovedEvent(value):
            return value
        case let .typeBookmarkUpdatedEvent(value):
            return value
        case let .typeCommentAddedEvent(value):
            return value
        case let .typeCommentRemovedEvent(value):
            return value
        case let .typeCommentUpdatedEvent(value):
            return value
        case let .typeFeedCreatedEvent(value):
            return value
        case let .typeFeedRemovedEvent(value):
            return value
        case let .typeFeedGroupChangedEvent(value):
            return value
        case let .typeFeedGroupRemovedEvent(value):
            return value
        case let .typeFollowAddedEvent(value):
            return value
        case let .typeFollowRemovedEvent(value):
            return value
        case let .typeFollowUpdatedEvent(value):
            return value
        case let .typeConnectedEvent(value):
            return value
        case let .typeHealthCheckEvent(value):
            return value
        case let .typeConnectionErrorEvent(value):
            return value
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .typeActivityAddedEvent(value):
            try container.encode(value)
        case let .typeReactionAddedEvent(value):
            try container.encode(value)
        case let .typeReactionRemovedEvent(value):
            try container.encode(value)
        case let .typeActivityRemovedEvent(value):
            try container.encode(value)
        case let .typeActivityUpdatedEvent(value):
            try container.encode(value)
        case let .typeBookmarkAddedEvent(value):
            try container.encode(value)
        case let .typeBookmarkRemovedEvent(value):
            try container.encode(value)
        case let .typeBookmarkUpdatedEvent(value):
            try container.encode(value)
        case let .typeCommentAddedEvent(value):
            try container.encode(value)
        case let .typeCommentRemovedEvent(value):
            try container.encode(value)
        case let .typeCommentUpdatedEvent(value):
            try container.encode(value)
        case let .typeFeedCreatedEvent(value):
            try container.encode(value)
        case let .typeFeedRemovedEvent(value):
            try container.encode(value)
        case let .typeFeedGroupChangedEvent(value):
            try container.encode(value)
        case let .typeFeedGroupRemovedEvent(value):
            try container.encode(value)
        case let .typeFollowAddedEvent(value):
            try container.encode(value)
        case let .typeFollowRemovedEvent(value):
            try container.encode(value)
        case let .typeFollowUpdatedEvent(value):
            try container.encode(value)
        case let .typeConnectedEvent(value):
            try container.encode(value)
        case let .typeHealthCheckEvent(value):
            try container.encode(value)
        case let .typeConnectionErrorEvent(value):
            try container.encode(value)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dto = try container.decode(WSEventMapping.self)
        if dto.type == "activity.added" {
            let value = try container.decode(ActivityAddedEvent.self)
            self = .typeActivityAddedEvent(value)
        } else if dto.type == "activity.reaction.added" {
            let value = try container.decode(ReactionAddedEvent.self)
            self = .typeReactionAddedEvent(value)
        } else if dto.type == "activity.reaction.removed" {
            let value = try container.decode(ReactionRemovedEvent.self)
            self = .typeReactionRemovedEvent(value)
        } else if dto.type == "activity.removed" {
            let value = try container.decode(ActivityRemovedEvent.self)
            self = .typeActivityRemovedEvent(value)
        } else if dto.type == "activity.updated" {
            let value = try container.decode(ActivityUpdatedEvent.self)
            self = .typeActivityUpdatedEvent(value)
        } else if dto.type == "bookmark.added" {
            let value = try container.decode(BookmarkAddedEvent.self)
            self = .typeBookmarkAddedEvent(value)
        } else if dto.type == "bookmark.removed" {
            let value = try container.decode(BookmarkRemovedEvent.self)
            self = .typeBookmarkRemovedEvent(value)
        } else if dto.type == "bookmark.updated" {
            let value = try container.decode(BookmarkUpdatedEvent.self)
            self = .typeBookmarkUpdatedEvent(value)
        } else if dto.type == "comment.added" {
            let value = try container.decode(CommentAddedEvent.self)
            self = .typeCommentAddedEvent(value)
        } else if dto.type == "comment.removed" {
            let value = try container.decode(CommentRemovedEvent.self)
            self = .typeCommentRemovedEvent(value)
        } else if dto.type == "comment.updated" {
            let value = try container.decode(CommentUpdatedEvent.self)
            self = .typeCommentUpdatedEvent(value)
        } else if dto.type == "feed.created" {
            let value = try container.decode(FeedCreatedEvent.self)
            self = .typeFeedCreatedEvent(value)
        } else if dto.type == "feed.removed" {
            let value = try container.decode(FeedRemovedEvent.self)
            self = .typeFeedRemovedEvent(value)
        } else if dto.type == "feed_group.changed" {
            let value = try container.decode(FeedGroupChangedEvent.self)
            self = .typeFeedGroupChangedEvent(value)
        } else if dto.type == "feed_group.removed" {
            let value = try container.decode(FeedGroupRemovedEvent.self)
            self = .typeFeedGroupRemovedEvent(value)
        } else if dto.type == "follow.added" {
            let value = try container.decode(FollowAddedEvent.self)
            self = .typeFollowAddedEvent(value)
        } else if dto.type == "follow.removed" {
            let value = try container.decode(FollowRemovedEvent.self)
            self = .typeFollowRemovedEvent(value)
        } else if dto.type == "follow.updated" {
            let value = try container.decode(FollowUpdatedEvent.self)
            self = .typeFollowUpdatedEvent(value)
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
            throw DecodingError.typeMismatch(Self.Type.self, .init(codingPath: decoder.codingPath, debugDescription: "Unable to decode instance of WSClientEvent"))
        }
    }
}
