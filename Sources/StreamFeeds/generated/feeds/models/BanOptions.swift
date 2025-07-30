//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BanOptions: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: Int
    public var ipBan: Bool
    public var reason: String
    public var shadowBan: Bool

    public init(duration: Int, ipBan: Bool, reason: String, shadowBan: Bool) {
        self.duration = duration
        self.ipBan = ipBan
        self.reason = reason
        self.shadowBan = shadowBan
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        case ipBan = "ip_ban"
        case reason
        case shadowBan = "shadow_ban"
    }

    public static func == (lhs: BanOptions, rhs: BanOptions) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.ipBan == rhs.ipBan &&
            lhs.reason == rhs.reason &&
            lhs.shadowBan == rhs.shadowBan
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(ipBan)
        hasher.combine(reason)
        hasher.combine(shadowBan)
    }
}
