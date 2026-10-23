//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UserMuteResponse: Sendable, Decodable {
    public let createdAt: Date
    public let expires: Date?
    /// User response object
    public let target: UserResponse?
    public let updatedAt: Date
    /// User response object
    public let user: UserResponse?

    public init(createdAt: Date, expires: Date? = nil, target: UserResponse? = nil, updatedAt: Date, user: UserResponse? = nil) {
        self.createdAt = createdAt
        self.expires = expires
        self.target = target
        self.updatedAt = updatedAt
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.expires = try container.decodeIfPresent(Date.self, forKey: .expires)
        self.target = try container.decodeIfPresent(UserResponse.self, forKey: .target)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decodeIfPresent(UserResponse.self, forKey: .user)
    }
}

extension UserMuteResponse: Hashable {
    public static func == (lhs: UserMuteResponse, rhs: UserMuteResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.expires == rhs.expires &&
            lhs.target == rhs.target &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(expires)
        hasher.combine(target)
        hasher.combine(updatedAt)
        hasher.combine(user)
    }
}
