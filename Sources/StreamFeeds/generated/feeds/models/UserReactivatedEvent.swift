//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a user gets reactivated. The event contains information about the user that was reactivated.
public final class UserReactivatedEvent: Sendable, Event, Codable, JSONEncodable {
    /// Date/time of creation
    public let createdAt: Date
    /// The type of event: "user.reactivated" in this case
    public let type: String
    public let user: UserResponseCommonFields

    public init(createdAt: Date, type: String = "user.reactivated", user: UserResponseCommonFields) {
        self.createdAt = createdAt
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decode(UserResponseCommonFields.self, forKey: .user)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(type, forKey: .type)
        try container.encode(user, forKey: .user)
    }
}

extension UserReactivatedEvent: Hashable {
    public static func == (lhs: UserReactivatedEvent, rhs: UserReactivatedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
