//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a user gets banned. The event contains information about the user that was banned.
public final class UserBannedEvent: Sendable, Event, Codable, JSONEncodable {
    /// Date/time of creation
    public let createdAt: Date
    public let createdBy: UserResponseCommonFields?
    public let custom: [String: RawJSON]
    /// The expiration date of the ban
    public let expiration: Date?
    /// The reason for the ban
    public let reason: String?
    public let receivedAt: Date?
    /// ID of the review queue item (flagged message) that triggered the ban, if the ban was applied from the moderation review queue
    public let reviewQueueItemId: String?
    /// Whether the user was shadow banned
    public let shadow: Bool?
    /// The team of the channel where the target user was banned
    public let team: String?
    /// The type of event: "user.banned" in this case
    public let type: String
    public let user: UserResponseCommonFields

    public init(createdAt: Date, createdBy: UserResponseCommonFields? = nil, custom: [String: RawJSON], expiration: Date? = nil, reason: String? = nil, receivedAt: Date? = nil, reviewQueueItemId: String? = nil, shadow: Bool? = nil, team: String? = nil, type: String = "user.banned", user: UserResponseCommonFields) {
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.custom = custom
        self.expiration = expiration
        self.reason = reason
        self.receivedAt = receivedAt
        self.reviewQueueItemId = reviewQueueItemId
        self.shadow = shadow
        self.team = team
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.createdBy = try container.decodeIfPresent(UserResponseCommonFields.self, forKey: .createdBy)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.expiration = try container.decodeIfPresent(Date.self, forKey: .expiration)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.reviewQueueItemId = try container.decodeIfPresent(String.self, forKey: .reviewQueueItemId)
        self.shadow = try container.decodeIfPresent(Bool.self, forKey: .shadow)
        self.team = try container.decodeIfPresent(String.self, forKey: .team)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decode(UserResponseCommonFields.self, forKey: .user)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encode(custom, forKey: .custom)
        try container.encodeIfPresent(expiration, forKey: .expiration)
        try container.encodeIfPresent(reason, forKey: .reason)
        try container.encodeIfPresent(receivedAt, forKey: .receivedAt)
        try container.encodeIfPresent(reviewQueueItemId, forKey: .reviewQueueItemId)
        try container.encodeIfPresent(shadow, forKey: .shadow)
        try container.encodeIfPresent(team, forKey: .team)
        try container.encode(type, forKey: .type)
        try container.encode(user, forKey: .user)
    }
}

extension UserBannedEvent: Hashable {
    public static func == (lhs: UserBannedEvent, rhs: UserBannedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.createdBy == rhs.createdBy &&
            lhs.custom == rhs.custom &&
            lhs.expiration == rhs.expiration &&
            lhs.reason == rhs.reason &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.reviewQueueItemId == rhs.reviewQueueItemId &&
            lhs.shadow == rhs.shadow &&
            lhs.team == rhs.team &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(createdBy)
        hasher.combine(custom)
        hasher.combine(expiration)
        hasher.combine(reason)
        hasher.combine(receivedAt)
        hasher.combine(reviewQueueItemId)
        hasher.combine(shadow)
        hasher.combine(team)
        hasher.combine(type)
        hasher.combine(user)
    }
}
