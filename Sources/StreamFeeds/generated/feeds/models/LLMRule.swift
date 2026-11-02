//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class LLMRuleAction: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let bounce = LLMRuleAction(rawValue: "bounce")
    public static let bounceFlag = LLMRuleAction(rawValue: "bounce_flag")
    public static let bounceRemove = LLMRuleAction(rawValue: "bounce_remove")
    public static let flag = LLMRuleAction(rawValue: "flag")
    public static let keep = LLMRuleAction(rawValue: "keep")
    public static let remove = LLMRuleAction(rawValue: "remove")
    public static let shadow = LLMRuleAction(rawValue: "shadow")
}

public final class LLMRule: Sendable, Codable, JSONEncodable {
    public let action: LLMRuleAction
    public let description: String
    public let label: String
    public let severityRules: [BodyguardSeverityRule]

    public init(action: LLMRuleAction, description: String, label: String, severityRules: [BodyguardSeverityRule]) {
        self.action = action
        self.description = description
        self.label = label
        self.severityRules = severityRules
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(LLMRuleAction.self, forKey: .action)
        self.description = try container.decode(String.self, forKey: .description)
        self.label = try container.decode(String.self, forKey: .label)
        self.severityRules = try container.decode([BodyguardSeverityRule].self, forKey: .severityRules)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encode(description, forKey: .description)
        try container.encode(label, forKey: .label)
        try container.encode(severityRules, forKey: .severityRules)
    }
}

extension LLMRule: Hashable {
    public static func == (lhs: LLMRule, rhs: LLMRule) -> Bool {
        lhs.action == rhs.action &&
            lhs.description == rhs.description &&
            lhs.label == rhs.label &&
            lhs.severityRules == rhs.severityRules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(description)
        hasher.combine(label)
        hasher.combine(severityRules)
    }
}
