//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class VelocityFilterConfig: Sendable, Codable, JSONEncodable {
    public let advancedFilters: Bool
    public let async: Bool?
    public let enabled: Bool
    public let rules: [VelocityFilterConfigRule]

    public init(advancedFilters: Bool, async: Bool? = nil, enabled: Bool, rules: [VelocityFilterConfigRule]) {
        self.advancedFilters = advancedFilters
        self.async = async
        self.enabled = enabled
        self.rules = rules
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.advancedFilters = try container.decode(Bool.self, forKey: .advancedFilters)
        self.async = try container.decodeIfPresent(Bool.self, forKey: .async)
        self.enabled = try container.decode(Bool.self, forKey: .enabled)
        self.rules = try container.decode([VelocityFilterConfigRule].self, forKey: .rules)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(advancedFilters, forKey: .advancedFilters)
        try container.encodeIfPresent(async, forKey: .async)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(rules, forKey: .rules)
    }
}

extension VelocityFilterConfig: Hashable {
    public static func == (lhs: VelocityFilterConfig, rhs: VelocityFilterConfig) -> Bool {
        lhs.advancedFilters == rhs.advancedFilters &&
            lhs.async == rhs.async &&
            lhs.enabled == rhs.enabled &&
            lhs.rules == rhs.rules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(advancedFilters)
        hasher.combine(async)
        hasher.combine(enabled)
        hasher.combine(rules)
    }
}
