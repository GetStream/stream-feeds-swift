//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedUpdatedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var feed: FeedResponse
    public var feedVisibility: String?
    public var fid: String
    public var receivedAt: Date?
    public var type: String = "feeds.feed.updated"
    public var user: UserResponseCommonFields?

    public init(createdAt: Date, custom: [String: RawJSON], feed: FeedResponse, feedVisibility: String? = nil, fid: String, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.feed = feed
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case feed
        case feedVisibility = "feed_visibility"
        case fid
        case receivedAt = "received_at"
        case type
        case user
    }

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
