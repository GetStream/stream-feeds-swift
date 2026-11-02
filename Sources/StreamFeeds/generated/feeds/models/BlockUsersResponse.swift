//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BlockUsersResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// User id who blocked another user
    public var blockedByUserId: String
    /// User id who got blocked
    public var blockedUserId: String
    /// Timestamp when the user was blocked
    public var createdAt: Date
    /// Duration of the request in milliseconds
    public var duration: String

    public init(blockedByUserId: String, blockedUserId: String, createdAt: Date, duration: String) {
        self.blockedByUserId = blockedByUserId
        self.blockedUserId = blockedUserId
        self.createdAt = createdAt
        self.duration = duration
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blockedByUserId = "blocked_by_user_id"
        case blockedUserId = "blocked_user_id"
        case createdAt = "created_at"
        case duration
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
