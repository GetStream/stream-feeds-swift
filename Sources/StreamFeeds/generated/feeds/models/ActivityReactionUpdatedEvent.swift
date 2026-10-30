//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a reaction is updated on an activity.
public final class ActivityReactionUpdatedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    public var activity: ActivityResponse
    /// Date/time of creation
    public var createdAt: Date
    public var custom: [String: RawJSON]
    /// Who can see and follow a feed.
    public var feedVisibility: FeedVisibility?
    public var fid: String
    public var reaction: FeedsReactionResponse
    public var receivedAt: Date?
    /// The type of event: "feeds.activity.reaction.updated" in this case
    public var type: String = "feeds.activity.reaction.updated"
    public var user: UserResponseCommonFields?

    public init(activity: ActivityResponse, createdAt: Date, custom: [String: RawJSON], feedVisibility: FeedVisibility? = nil, fid: String, reaction: FeedsReactionResponse, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.activity = activity
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.reaction = reaction
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case createdAt = "created_at"
        case custom
        case feedVisibility = "feed_visibility"
        case fid
        case reaction
        case receivedAt = "received_at"
        case type
        case user
    }
}

extension ActivityReactionUpdatedEvent: Hashable {
    public static func == (lhs: ActivityReactionUpdatedEvent, rhs: ActivityReactionUpdatedEvent) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.reaction == rhs.reaction &&
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
        hasher.combine(reaction)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
