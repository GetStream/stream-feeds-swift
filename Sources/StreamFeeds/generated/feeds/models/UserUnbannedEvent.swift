//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a user gets unbanned. The event contains information about the user that was unbanned.
public final class UserUnbannedEvent: Sendable, Event, Codable, JSONEncodable {
    /// Date/time of creation
    public let createdAt: Date
    public let createdBy: UserResponseCommonFields?
    public let custom: [String: RawJSON]
    public let receivedAt: Date?
    /// Whether the target user was shadow unbanned
    public let shadow: Bool?
    /// The team of the channel where the target user was unbanned
    public let team: String?
    /// The type of event: "user.unbanned" in this case
    public let type: String
    public let user: UserResponseCommonFields

    public init(createdAt: Date, createdBy: UserResponseCommonFields? = nil, custom: [String: RawJSON], receivedAt: Date? = nil, shadow: Bool? = nil, team: String? = nil, type: String = "user.unbanned", user: UserResponseCommonFields) {
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.custom = custom
        self.receivedAt = receivedAt
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
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
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
        try container.encodeIfPresent(receivedAt, forKey: .receivedAt)
        try container.encodeIfPresent(shadow, forKey: .shadow)
        try container.encodeIfPresent(team, forKey: .team)
        try container.encode(type, forKey: .type)
        try container.encode(user, forKey: .user)
    }
}

extension UserUnbannedEvent: Hashable {
    public static func == (lhs: UserUnbannedEvent, rhs: UserUnbannedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.createdBy == rhs.createdBy &&
            lhs.custom == rhs.custom &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.shadow == rhs.shadow &&
            lhs.team == rhs.team &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(createdBy)
        hasher.combine(custom)
        hasher.combine(receivedAt)
        hasher.combine(shadow)
        hasher.combine(team)
        hasher.combine(type)
        hasher.combine(user)
    }
}
