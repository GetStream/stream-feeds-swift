//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BanOptions: Sendable, Codable, JSONEncodable {
    public let duration: Int?
    public let ipBan: Bool?
    public let reason: String?
    public let shadowBan: Bool?

    public init(duration: Int? = nil, ipBan: Bool? = nil, reason: String? = nil, shadowBan: Bool? = nil) {
        self.duration = duration
        self.ipBan = ipBan
        self.reason = reason
        self.shadowBan = shadowBan
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.duration = try container.decodeIfPresent(Int.self, forKey: .duration)
        self.ipBan = try container.decodeIfPresent(Bool.self, forKey: .ipBan)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.shadowBan = try container.decodeIfPresent(Bool.self, forKey: .shadowBan)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(duration, forKey: .duration)
        try container.encodeIfPresent(ipBan, forKey: .ipBan)
        try container.encodeIfPresent(reason, forKey: .reason)
        try container.encodeIfPresent(shadowBan, forKey: .shadowBan)
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
