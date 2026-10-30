//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BlockedUserResponse: @unchecked Sendable, Codable, JSONEncodable {
    /// User response object
    public var blockedUser: UserResponse
    /// ID of the user who got blocked
    public var blockedUserId: String
    public var createdAt: Date
    /// User response object
    public var user: UserResponse
    /// ID of the user who blocked another user
    public var userId: String

    public init(blockedUser: UserResponse, blockedUserId: String, createdAt: Date, user: UserResponse, userId: String) {
        self.blockedUser = blockedUser
        self.blockedUserId = blockedUserId
        self.createdAt = createdAt
        self.user = user
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blockedUser = "blocked_user"
        case blockedUserId = "blocked_user_id"
        case createdAt = "created_at"
        case user
        case userId = "user_id"
    }
}

extension BlockedUserResponse: Hashable {
    public static func == (lhs: BlockedUserResponse, rhs: BlockedUserResponse) -> Bool {
        lhs.blockedUser == rhs.blockedUser &&
            lhs.blockedUserId == rhs.blockedUserId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.user == rhs.user &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blockedUser)
        hasher.combine(blockedUserId)
        hasher.combine(createdAt)
        hasher.combine(user)
        hasher.combine(userId)
    }
}
