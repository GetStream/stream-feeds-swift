//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a feed is created.
public final class FeedCreatedEvent: Sendable, Event, Decodable {
    /// Date/time of creation
    public let createdAt: Date
    public let custom: [String: RawJSON]
    public let feed: FeedResponse
    /// Who can see and follow a feed.
    public let feedVisibility: FeedVisibility?
    public let fid: String
    public let members: [FeedMemberResponse]
    public let receivedAt: Date?
    /// The type of event: "feeds.feed.created" in this case
    public let type: String
    public let user: UserResponseCommonFields

    public init(createdAt: Date, custom: [String: RawJSON], feed: FeedResponse, feedVisibility: FeedVisibility? = nil, fid: String, members: [FeedMemberResponse], receivedAt: Date? = nil, type: String = "feeds.feed.created", user: UserResponseCommonFields) {
        self.createdAt = createdAt
        self.custom = custom
        self.feed = feed
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.members = members
        self.receivedAt = receivedAt
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.feed = try container.decode(FeedResponse.self, forKey: .feed)
        self.feedVisibility = try container.decodeIfPresent(FeedVisibility.self, forKey: .feedVisibility)
        self.fid = try container.decode(String.self, forKey: .fid)
        self.members = try container.decode([FeedMemberResponse].self, forKey: .members)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decode(UserResponseCommonFields.self, forKey: .user)
    }
}

extension FeedCreatedEvent: Hashable {
    public static func == (lhs: FeedCreatedEvent, rhs: FeedCreatedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feed == rhs.feed &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.members == rhs.members &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feed)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(members)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
