//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BlockedUserResponse: Sendable, Decodable {
    /// User response object
    public let blockedUser: UserResponse
    /// ID of the user who got blocked
    public let blockedUserId: String
    public let createdAt: Date
    /// User response object
    public let user: UserResponse
    /// ID of the user who blocked another user
    public let userId: String

    public init(blockedUser: UserResponse, blockedUserId: String, createdAt: Date, user: UserResponse, userId: String) {
        self.blockedUser = blockedUser
        self.blockedUserId = blockedUserId
        self.createdAt = createdAt
        self.user = user
        self.userId = userId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.blockedUser = try container.decode(UserResponse.self, forKey: .blockedUser)
        self.blockedUserId = try container.decode(String.self, forKey: .blockedUserId)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.user = try container.decode(UserResponse.self, forKey: .user)
        self.userId = try container.decode(String.self, forKey: .userId)
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
