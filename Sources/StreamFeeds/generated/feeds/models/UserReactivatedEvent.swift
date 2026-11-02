//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a user gets reactivated. The event contains information about the user that was reactivated.
public final class UserReactivatedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    /// Date/time of creation
    public var createdAt: Date
    /// The type of event: "user.reactivated" in this case
    public var type: String = "user.reactivated"
    public var user: UserResponseCommonFields

    public init(createdAt: Date, user: UserResponseCommonFields) {
        self.createdAt = createdAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case type
        case user
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
