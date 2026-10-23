//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class VelocityFilterConfig: @unchecked Sendable, Codable, JSONEncodable {
    public var advancedFilters: Bool
    public var async: Bool?
    public var enabled: Bool
    public var rules: [VelocityFilterConfigRule]

    public init(
        advancedFilters: Bool,
        async: Bool? = nil,
        enabled: Bool,
        rules: [VelocityFilterConfigRule]
    ) {
        self.advancedFilters = advancedFilters
        self.async = async
        self.enabled = enabled
        self.rules = rules
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case advancedFilters = "advanced_filters"
        case async
        case enabled
        case rules
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
