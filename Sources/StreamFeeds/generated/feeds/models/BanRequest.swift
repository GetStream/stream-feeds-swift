//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BanRequest: @unchecked Sendable, Codable, JSONEncodable {
    /// Whether to delete reactions by the banned user on other users' messages
    public var deleteReactions: Bool?
    /// Whether to ban the user's IP address
    public var ipBan: Bool?
    /// Optional explanation for the ban
    public var reason: String?
    /// Whether this is a shadow ban
    public var shadow: Bool?
    /// ID of the user to ban
    public var targetUserId: String
    /// Duration of the ban in minutes
    public var timeout: Int?

    public init(
        deleteReactions: Bool? = nil,
        ipBan: Bool? = nil,
        reason: String? = nil,
        shadow: Bool? = nil,
        targetUserId: String,
        timeout: Int? = nil
    ) {
        self.deleteReactions = deleteReactions
        self.ipBan = ipBan
        self.reason = reason
        self.shadow = shadow
        self.targetUserId = targetUserId
        self.timeout = timeout
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case deleteReactions = "delete_reactions"
        case ipBan = "ip_ban"
        case reason
        case shadow
        case targetUserId = "target_user_id"
        case timeout
    }
}

extension BanRequest: Hashable {
    public static func == (lhs: BanRequest, rhs: BanRequest) -> Bool {
        lhs.deleteReactions == rhs.deleteReactions &&
            lhs.ipBan == rhs.ipBan &&
            lhs.reason == rhs.reason &&
            lhs.shadow == rhs.shadow &&
            lhs.targetUserId == rhs.targetUserId &&
            lhs.timeout == rhs.timeout
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(deleteReactions)
        hasher.combine(ipBan)
        hasher.combine(reason)
        hasher.combine(shadow)
        hasher.combine(targetUserId)
        hasher.combine(timeout)
    }
}
