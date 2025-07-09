//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderAction: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var duration: Int?
    public var ipBan: Bool?
    public var reason: String?
    public var shadowBan: Bool?
    public var type: String?

    public init(duration: Int? = nil, ipBan: Bool? = nil, reason: String? = nil, shadowBan: Bool? = nil) {
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
        case type
    }

    public static func == (lhs: RuleBuilderAction, rhs: RuleBuilderAction) -> Bool {
        lhs.duration == rhs.duration &&
            lhs.ipBan == rhs.ipBan &&
            lhs.reason == rhs.reason &&
            lhs.shadowBan == rhs.shadowBan &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
        hasher.combine(ipBan)
        hasher.combine(reason)
        hasher.combine(shadowBan)
        hasher.combine(type)
    }
}
