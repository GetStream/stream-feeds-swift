//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// This event is sent when a user gets banned. The event contains information about the user that was banned.
public final class UserBannedEvent: @unchecked Sendable, Event, Codable, JSONEncodable {
    /// Date/time of creation
    public var createdAt: Date
    public var createdBy: UserResponseCommonFields?
    /// The expiration date of the ban
    public var expiration: Date?
    /// The reason for the ban
    public var reason: String?
    /// Whether the user was shadow banned
    public var shadow: Bool?
    /// The team of the channel where the target user was banned
    public var team: String?
    /// The type of event: "user.banned" in this case
    public var type: String = "user.banned"
    public var user: UserResponseCommonFields

    public init(createdAt: Date, createdBy: UserResponseCommonFields? = nil, expiration: Date? = nil, reason: String? = nil, shadow: Bool? = nil, team: String? = nil, user: UserResponseCommonFields) {
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.expiration = expiration
        self.reason = reason
        self.shadow = shadow
        self.team = team
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case createdBy = "created_by"
        case expiration
        case reason
        case shadow
        case team
        case type
        case user
    }
}

extension UserBannedEvent: Hashable {
    public static func == (lhs: UserBannedEvent, rhs: UserBannedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.createdBy == rhs.createdBy &&
            lhs.expiration == rhs.expiration &&
            lhs.reason == rhs.reason &&
            lhs.shadow == rhs.shadow &&
            lhs.team == rhs.team &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(createdBy)
        hasher.combine(expiration)
        hasher.combine(reason)
        hasher.combine(shadow)
        hasher.combine(team)
        hasher.combine(type)
        hasher.combine(user)
    }
}
