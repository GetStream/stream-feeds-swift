//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when an activity is unpinned.
public final class ActivityUnpinnedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    /// Date/time of creation
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var feedVisibility: String?
    /// The ID of the feed
    public var fid: String
    public var pinnedActivity: PinActivityResponse
    public var receivedAt: Date?
    /// The type of event: "feeds.activity.unpinned" in this case
    public var type: String = "feeds.activity.unpinned"
    public var user: UserResponseCommonFields?

    public init(createdAt: Date, custom: [String: RawJSON], feedVisibility: String? = nil, fid: String, pinnedActivity: PinActivityResponse, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.pinnedActivity = pinnedActivity
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case feedVisibility = "feed_visibility"
        case fid
        case pinnedActivity = "pinned_activity"
        case receivedAt = "received_at"
        case type
        case user
    }
}

extension ActivityUnpinnedEvent: Hashable {
    public static func == (lhs: ActivityUnpinnedEvent, rhs: ActivityUnpinnedEvent) -> Bool {
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
