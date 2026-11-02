//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BanRequest: Sendable, Encodable, JSONEncodable {
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

    public init(ipBan: Bool? = nil, reason: String? = nil, shadow: Bool? = nil, targetUserId: String, timeout: Int? = nil) {
        self.ipBan = ipBan
        self.reason = reason
        self.shadow = shadow
        self.targetUserId = targetUserId
        self.timeout = timeout
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(ipBan, forKey: .ipBan)
        try container.encodeIfPresent(reason, forKey: .reason)
        try container.encodeIfPresent(shadow, forKey: .shadow)
        try container.encode(targetUserId, forKey: .targetUserId)
        try container.encodeIfPresent(timeout, forKey: .timeout)
    }
}

extension BanRequest: Hashable {
    public static func == (lhs: BanRequest, rhs: BanRequest) -> Bool {
        lhs.ipBan == rhs.ipBan &&
            lhs.reason == rhs.reason &&
            lhs.shadow == rhs.shadow &&
            lhs.targetUserId == rhs.targetUserId &&
            lhs.timeout == rhs.timeout
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ipBan)
        hasher.combine(reason)
        hasher.combine(shadow)
        hasher.combine(targetUserId)
        hasher.combine(timeout)
    }
}
