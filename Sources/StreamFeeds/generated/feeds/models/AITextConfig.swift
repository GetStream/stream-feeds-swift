//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AITextConfig: @unchecked Sendable, Codable, JSONEncodable {
    public var async: Bool?
    public var enabled: Bool
    public var rules: [BodyguardRule]
    public var severityRules: [BodyguardSeverityRule]

    public init(
        async: Bool? = nil,
        enabled: Bool,
        rules: [BodyguardRule],
        severityRules: [BodyguardSeverityRule]
    ) {
        self.async = async
        self.enabled = enabled
        self.rules = rules
        self.severityRules = severityRules
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case async
        case enabled
        case rules
        case severityRules = "severity_rules"
    }
}

extension AITextConfig: Hashable {
    public static func == (lhs: AITextConfig, rhs: AITextConfig) -> Bool {
        lhs.async == rhs.async &&
            lhs.enabled == rhs.enabled &&
            lhs.rules == rhs.rules &&
            lhs.severityRules == rhs.severityRules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(async)
        hasher.combine(enabled)
        hasher.combine(rules)
        hasher.combine(severityRules)
    }
}
