//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a reaction is updated on an activity.
public final class ActivityReactionUpdatedEvent: Sendable, Event, Codable, JSONEncodable {
    public let activity: ActivityResponse
    /// Date/time of creation
    public let createdAt: Date
    public let custom: [String: RawJSON]
    public let feedVisibility: String?
    public let fid: String
    public let reaction: FeedsReactionResponse
    public let receivedAt: Date?
    /// The type of event: "feeds.activity.reaction.updated" in this case
    public let type: String
    public let user: UserResponseCommonFields?

    public init(activity: ActivityResponse, createdAt: Date, custom: [String: RawJSON], feedVisibility: String? = nil, fid: String, reaction: FeedsReactionResponse, receivedAt: Date? = nil, type: String = "feeds.activity.reaction.updated", user: UserResponseCommonFields? = nil) {
        self.activity = activity
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.reaction = reaction
        self.receivedAt = receivedAt
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activity = try container.decode(ActivityResponse.self, forKey: .activity)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.feedVisibility = try container.decodeIfPresent(String.self, forKey: .feedVisibility)
        self.fid = try container.decode(String.self, forKey: .fid)
        self.reaction = try container.decode(FeedsReactionResponse.self, forKey: .reaction)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decodeIfPresent(UserResponseCommonFields.self, forKey: .user)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(activity, forKey: .activity)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(custom, forKey: .custom)
        try container.encodeIfPresent(feedVisibility, forKey: .feedVisibility)
        try container.encode(fid, forKey: .fid)
        try container.encode(reaction, forKey: .reaction)
        try container.encodeIfPresent(receivedAt, forKey: .receivedAt)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(user, forKey: .user)
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
