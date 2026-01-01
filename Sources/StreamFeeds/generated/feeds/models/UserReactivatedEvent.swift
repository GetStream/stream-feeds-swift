//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserReactivatedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var type: String = "user.reactivated"
    public var user: User?

    public init(createdAt: Date, user: User? = nil) {
        self.createdAt = createdAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case type
        case user
    }

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
