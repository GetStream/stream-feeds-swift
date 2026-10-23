//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a user gets reactivated. The event contains information about the user that was reactivated.
public final class UserReactivatedEvent: Sendable, Event, Codable, JSONEncodable {
    /// Date/time of creation
    public let createdAt: Date
    public let createdBy: UserResponseCommonFields?
    public let custom: [String: RawJSON]
    public let receivedAt: Date?
    /// The type of event: "user.reactivated" in this case
    public let type: String
    public let user: UserResponseCommonFields

    public init(createdAt: Date, createdBy: UserResponseCommonFields? = nil, custom: [String: RawJSON], receivedAt: Date? = nil, type: String = "user.reactivated", user: UserResponseCommonFields) {
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.custom = custom
        self.receivedAt = receivedAt
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.createdBy = try container.decodeIfPresent(UserResponseCommonFields.self, forKey: .createdBy)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decode(UserResponseCommonFields.self, forKey: .user)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encode(custom, forKey: .custom)
        try container.encodeIfPresent(receivedAt, forKey: .receivedAt)
        try container.encode(type, forKey: .type)
        try container.encode(user, forKey: .user)
    }
}

extension UserReactivatedEvent: Hashable {
    public static func == (lhs: UserReactivatedEvent, rhs: UserReactivatedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.createdBy == rhs.createdBy &&
            lhs.custom == rhs.custom &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(createdBy)
        hasher.combine(custom)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
