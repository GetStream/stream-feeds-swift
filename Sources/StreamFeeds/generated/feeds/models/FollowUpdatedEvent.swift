//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a follow relationship is updated.
public final class FollowUpdatedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    /// Date/time of creation
    public var createdAt: Date
    public var custom: [String: RawJSON]
    /// Who can see and follow a feed.
    public var feedVisibility: FeedVisibility?
    public var fid: String
    public var follow: FollowResponse
    public var receivedAt: Date?
    /// The type of event: "feeds.follow.updated" in this case
    public var type: String = "feeds.follow.updated"

    public init(createdAt: Date, custom: [String: RawJSON], feedVisibility: FeedVisibility? = nil, fid: String, follow: FollowResponse, receivedAt: Date? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.follow = follow
        self.receivedAt = receivedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case feedVisibility = "feed_visibility"
        case fid
        case follow
        case receivedAt = "received_at"
        case type
    }
}

extension FollowUpdatedEvent: Hashable {
    public static func == (lhs: FollowUpdatedEvent, rhs: FollowUpdatedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.follow == rhs.follow &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(follow)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
}
