//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AITextConfig: Sendable, Codable, JSONEncodable {
    public let async: Bool?
    public let enabled: Bool
    public let rules: [BodyguardRule]
    public let severityRules: [BodyguardSeverityRule]

    public init(async: Bool? = nil, enabled: Bool, rules: [BodyguardRule], severityRules: [BodyguardSeverityRule]) {
        self.async = async
        self.enabled = enabled
        self.rules = rules
        self.severityRules = severityRules
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.async = try container.decodeIfPresent(Bool.self, forKey: .async)
        self.enabled = try container.decode(Bool.self, forKey: .enabled)
        self.rules = try container.decode([BodyguardRule].self, forKey: .rules)
        self.severityRules = try container.decode([BodyguardSeverityRule].self, forKey: .severityRules)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(async, forKey: .async)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(rules, forKey: .rules)
        try container.encode(severityRules, forKey: .severityRules)
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
