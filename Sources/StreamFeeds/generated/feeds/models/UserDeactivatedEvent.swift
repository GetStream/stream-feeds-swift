//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a user gets deactivated. The event contains information about the user that was deactivated.
public final class UserDeactivatedEvent: Sendable, Event, Decodable {
    /// Date/time of creation
    public let createdAt: Date
    public let createdBy: UserResponseCommonFields?
    /// The type of event: "user.deactivated" in this case
    public let type: String
    public let user: UserResponseCommonFields

    public init(createdAt: Date, createdBy: UserResponseCommonFields? = nil, type: String = "user.deactivated", user: UserResponseCommonFields) {
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.createdBy = try container.decodeIfPresent(UserResponseCommonFields.self, forKey: .createdBy)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decode(UserResponseCommonFields.self, forKey: .user)
    }
}

extension UserDeactivatedEvent: Hashable {
    public static func == (lhs: UserDeactivatedEvent, rhs: UserDeactivatedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.createdBy == rhs.createdBy &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(createdBy)
        hasher.combine(type)
        hasher.combine(user)
    }
}
