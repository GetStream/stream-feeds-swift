//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BanOptions: @unchecked Sendable, Codable, JSONEncodable {
    public var duration: Int?
    public var ipBan: Bool?
    public var reason: String?
    public var shadowBan: Bool?

    public init(
        duration: Int? = nil,
        ipBan: Bool? = nil,
        reason: String? = nil,
        shadowBan: Bool? = nil
    ) {
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
}

extension BanOptions: Hashable {
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
