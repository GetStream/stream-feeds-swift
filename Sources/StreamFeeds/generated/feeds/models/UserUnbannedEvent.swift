//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a user gets unbanned. The event contains information about the user that was unbanned.
public final class UserUnbannedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    /// Date/time of creation
    public var createdAt: Date
    public var createdBy: UserResponseCommonFields?
    public var custom: [String: RawJSON]
    public var receivedAt: Date?
    /// Whether the target user was shadow unbanned
    public var shadow: Bool?
    /// The team of the channel where the target user was unbanned
    public var team: String?
    /// The type of event: "user.unbanned" in this case
    public var type: String = "user.unbanned"
    public var user: UserResponseCommonFields

    public init(
        createdAt: Date,
        createdBy: UserResponseCommonFields? = nil,
        custom: [String: RawJSON],
        receivedAt: Date? = nil,
        shadow: Bool? = nil,
        team: String? = nil,
        user: UserResponseCommonFields
    ) {
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.custom = custom
        self.receivedAt = receivedAt
        self.shadow = shadow
        self.team = team
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case createdBy = "created_by"
        case custom
        case receivedAt = "received_at"
        case shadow
        case team
        case type
        case user
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
