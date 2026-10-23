//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BanRequest: Sendable, Codable, JSONEncodable {
    /// Whether to delete reactions by the banned user on other users' messages
    public let deleteReactions: Bool?
    /// Whether to ban the user's IP address
    public let ipBan: Bool?
    /// Optional explanation for the ban
    public let reason: String?
    /// Whether this is a shadow ban
    public let shadow: Bool?
    /// ID of the user to ban
    public let targetUserId: String
    /// Duration of the ban in minutes
    public let timeout: Int?

    public init(deleteReactions: Bool? = nil, ipBan: Bool? = nil, reason: String? = nil, shadow: Bool? = nil, targetUserId: String, timeout: Int? = nil) {
        self.deleteReactions = deleteReactions
        self.ipBan = ipBan
        self.reason = reason
        self.shadow = shadow
        self.targetUserId = targetUserId
        self.timeout = timeout
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.deleteReactions = try container.decodeIfPresent(Bool.self, forKey: .deleteReactions)
        self.ipBan = try container.decodeIfPresent(Bool.self, forKey: .ipBan)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.shadow = try container.decodeIfPresent(Bool.self, forKey: .shadow)
        self.targetUserId = try container.decode(String.self, forKey: .targetUserId)
        self.timeout = try container.decodeIfPresent(Int.self, forKey: .timeout)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(deleteReactions, forKey: .deleteReactions)
        try container.encodeIfPresent(ipBan, forKey: .ipBan)
        try container.encodeIfPresent(reason, forKey: .reason)
        try container.encodeIfPresent(shadow, forKey: .shadow)
        try container.encode(targetUserId, forKey: .targetUserId)
        try container.encodeIfPresent(timeout, forKey: .timeout)
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
