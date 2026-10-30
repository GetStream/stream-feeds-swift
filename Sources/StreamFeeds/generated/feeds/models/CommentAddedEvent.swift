//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a comment is added to an activity.
public final class CommentAddedEvent: Sendable, Event, Decodable {
    public let activity: ActivityResponse
    public let comment: CommentResponse
    /// Date/time of creation
    public let createdAt: Date
    public let custom: [String: RawJSON]
    /// Who can see and follow a feed.
    public let feedVisibility: FeedVisibility?
    public let fid: String
    public let receivedAt: Date?
    /// The type of event: "feeds.comment.added" in this case
    public let type: String
    public let user: UserResponseCommonFields?

    public init(activity: ActivityResponse, comment: CommentResponse, createdAt: Date, custom: [String: RawJSON], feedVisibility: FeedVisibility? = nil, fid: String, receivedAt: Date? = nil, type: String = "feeds.comment.added", user: UserResponseCommonFields? = nil) {
        self.activity = activity
        self.comment = comment
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.receivedAt = receivedAt
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.comment = try container.decode(CommentResponse.self, forKey: .comment)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.feedVisibility = try container.decodeIfPresent(FeedVisibility.self, forKey: .feedVisibility)
        self.fid = try container.decode(String.self, forKey: .fid)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decodeIfPresent(UserResponseCommonFields.self, forKey: .user)
    }
}

extension CommentAddedEvent: Hashable {
    public static func == (lhs: CommentAddedEvent, rhs: CommentAddedEvent) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.comment == rhs.comment &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(comment)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
