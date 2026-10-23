//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a user gets deactivated. The event contains information about the user that was deactivated.
public final class UserDeactivatedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    /// Date/time of creation
    public var createdAt: Date
    public var createdBy: UserResponseCommonFields?
    public var custom: [String: RawJSON]
    public var receivedAt: Date?
    /// The type of event: "user.deactivated" in this case
    public var type: String = "user.deactivated"
    public var user: UserResponseCommonFields

    public init(
        createdAt: Date,
        createdBy: UserResponseCommonFields? = nil,
        custom: [String: RawJSON],
        receivedAt: Date? = nil,
        user: UserResponseCommonFields
    ) {
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.custom = custom
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case createdBy = "created_by"
        case custom
        case receivedAt = "received_at"
        case type
        case user
    }
}

extension UserDeactivatedEvent: Hashable {
    public static func == (lhs: UserDeactivatedEvent, rhs: UserDeactivatedEvent) -> Bool {
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
