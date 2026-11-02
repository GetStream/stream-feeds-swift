//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when an activity is removed from a feed.
public final class ActivityRemovedFromFeedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    public var activity: ActivityResponse
    /// Date/time of creation
    public var createdAt: Date
    public var custom: [String: RawJSON]
    /// Who can see and follow a feed.
    public var feedVisibility: FeedVisibility?
    public var fid: String
    public var receivedAt: Date?
    /// The type of event: "feeds.activity.removed_from_feed" in this case
    public var type: String = "feeds.activity.removed_from_feed"
    public var user: UserResponseCommonFields?

    public init(activity: ActivityResponse, createdAt: Date, custom: [String: RawJSON], feedVisibility: FeedVisibility? = nil, fid: String, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.activity = activity
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case createdAt = "created_at"
        case custom
        case feedVisibility = "feed_visibility"
        case fid
        case receivedAt = "received_at"
        case type
        case user
    }
}

extension ActivityRemovedFromFeedEvent: Hashable {
    public static func == (lhs: ActivityRemovedFromFeedEvent, rhs: ActivityRemovedFromFeedEvent) -> Bool {
        lhs.activity == rhs.activity &&
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
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
