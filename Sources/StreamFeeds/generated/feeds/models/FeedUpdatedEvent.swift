//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a feed is updated.
public final class FeedUpdatedEvent: Sendable, Event, Decodable {
    public let createdAt: Date
    public let custom: [String: RawJSON]
    public let feed: FeedResponse
    /// Who can see and follow a feed.
    public let feedVisibility: FeedVisibility?
    public let fid: String
    public let receivedAt: Date?
    /// The type of event: "feeds.feed.updated" in this case
    public let type: String
    public let user: UserResponseCommonFields?

    public init(createdAt: Date, custom: [String: RawJSON], feed: FeedResponse, feedVisibility: FeedVisibility? = nil, fid: String, receivedAt: Date? = nil, type: String = "feeds.feed.updated", user: UserResponseCommonFields? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.feed = feed
        self.feedVisibility = feedVisibility
        self.fid = fid
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
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decodeIfPresent(UserResponseCommonFields.self, forKey: .user)
    }
}

extension FeedUpdatedEvent: Hashable {
    public static func == (lhs: FeedUpdatedEvent, rhs: FeedUpdatedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feed == rhs.feed &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
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
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
