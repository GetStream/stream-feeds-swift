//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedGroupChangedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var feedGroup: FeedGroup?
    public var feedVisibility: String?
    public var fid: String
    public var receivedAt: Date?
    public var type: String = "feeds.feed_group.changed"
    public var user: UserResponseCommonFields?

    public init(createdAt: Date, custom: [String: RawJSON], feedGroup: FeedGroup? = nil, feedVisibility: String? = nil, fid: String, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.feedGroup = feedGroup
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case feedGroup = "feed_group"
        case feedVisibility = "feed_visibility"
        case fid
        case receivedAt = "received_at"
        case type
        case user
    }

    public static func == (lhs: FeedGroupChangedEvent, rhs: FeedGroupChangedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedGroup == rhs.feedGroup &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedGroup)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
