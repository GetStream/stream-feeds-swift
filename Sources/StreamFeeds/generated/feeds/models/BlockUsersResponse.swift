//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BlockUsersResponse: Sendable, Codable, JSONEncodable {
    /// User id who blocked another user
    public let blockedByUserId: String
    /// User id who got blocked
    public let blockedUserId: String
    /// Timestamp when the user was blocked
    public let createdAt: Date
    /// Duration of the request in milliseconds
    public let duration: String

    public init(blockedByUserId: String, blockedUserId: String, createdAt: Date, duration: String) {
        self.blockedByUserId = blockedByUserId
        self.blockedUserId = blockedUserId
        self.createdAt = createdAt
        self.duration = duration
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.blockedByUserId = try container.decode(String.self, forKey: .blockedByUserId)
        self.blockedUserId = try container.decode(String.self, forKey: .blockedUserId)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.duration = try container.decode(String.self, forKey: .duration)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(blockedByUserId, forKey: .blockedByUserId)
        try container.encode(blockedUserId, forKey: .blockedUserId)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(duration, forKey: .duration)
    }
}

extension BlockUsersResponse: Hashable {
    public static func == (lhs: BlockUsersResponse, rhs: BlockUsersResponse) -> Bool {
        lhs.blockedByUserId == rhs.blockedByUserId &&
            lhs.blockedUserId == rhs.blockedUserId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blockedByUserId)
        hasher.combine(blockedUserId)
        hasher.combine(createdAt)
        hasher.combine(duration)
    }
}
