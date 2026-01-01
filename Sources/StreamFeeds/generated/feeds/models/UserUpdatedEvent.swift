//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserUpdatedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var receivedAt: Date?
    public var type: String = "user.updated"
    public var user: UserResponsePrivacyFields

    public init(createdAt: Date, custom: [String: RawJSON], receivedAt: Date? = nil, user: UserResponsePrivacyFields) {
        self.createdAt = createdAt
        self.custom = custom
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case receivedAt = "received_at"
        case type
        case user
    }

    public static func == (lhs: UserUpdatedEvent, rhs: UserUpdatedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
