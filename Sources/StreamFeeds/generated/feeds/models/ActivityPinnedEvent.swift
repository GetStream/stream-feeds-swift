//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when an activity is pinned.
public final class ActivityPinnedEvent: Sendable, Event, Decodable {
    /// Date/time of creation
    public let createdAt: Date
    public let custom: [String: RawJSON]
    /// Who can see and follow a feed.
    public let feedVisibility: FeedVisibility?
    /// The ID of the feed
    public let fid: String
    public let pinnedActivity: PinActivityResponse
    public let receivedAt: Date?
    /// The type of event: "feeds.activity.pinned" in this case
    public let type: String
    public let user: UserResponseCommonFields?

    public init(createdAt: Date, custom: [String: RawJSON], feedVisibility: FeedVisibility? = nil, fid: String, pinnedActivity: PinActivityResponse, receivedAt: Date? = nil, type: String = "feeds.activity.pinned", user: UserResponseCommonFields? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.pinnedActivity = pinnedActivity
        self.receivedAt = receivedAt
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.feedVisibility = try container.decodeIfPresent(FeedVisibility.self, forKey: .feedVisibility)
        self.fid = try container.decode(String.self, forKey: .fid)
        self.pinnedActivity = try container.decode(PinActivityResponse.self, forKey: .pinnedActivity)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decodeIfPresent(UserResponseCommonFields.self, forKey: .user)
    }
}

extension ActivityPinnedEvent: Hashable {
    public static func == (lhs: ActivityPinnedEvent, rhs: ActivityPinnedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.pinnedActivity == rhs.pinnedActivity &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(pinnedActivity)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
