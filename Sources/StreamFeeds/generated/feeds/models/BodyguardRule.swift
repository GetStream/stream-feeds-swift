//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BodyguardRuleAction: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let bounce = BodyguardRuleAction(rawValue: "bounce")
    public static let bounceFlag = BodyguardRuleAction(rawValue: "bounce_flag")
    public static let bounceRemove = BodyguardRuleAction(rawValue: "bounce_remove")
    public static let flag = BodyguardRuleAction(rawValue: "flag")
    public static let keep = BodyguardRuleAction(rawValue: "keep")
    public static let mask = BodyguardRuleAction(rawValue: "mask")
    public static let maskFlag = BodyguardRuleAction(rawValue: "mask_flag")
    public static let remove = BodyguardRuleAction(rawValue: "remove")
    public static let shadow = BodyguardRuleAction(rawValue: "shadow")
}

public final class BodyguardRule: Sendable, Codable, JSONEncodable {
    public let action: BodyguardRuleAction
    public let label: String
    public let severityRules: [BodyguardSeverityRule]

    public init(action: BodyguardRuleAction, label: String, severityRules: [BodyguardSeverityRule]) {
        self.action = action
        self.label = label
        self.severityRules = severityRules
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(BodyguardRuleAction.self, forKey: .action)
        self.label = try container.decode(String.self, forKey: .label)
        self.severityRules = try container.decode([BodyguardSeverityRule].self, forKey: .severityRules)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encode(label, forKey: .label)
        try container.encode(severityRules, forKey: .severityRules)
    }
}

extension BodyguardRule: Hashable {
    public static func == (lhs: BodyguardRule, rhs: BodyguardRule) -> Bool {
        lhs.action == rhs.action &&
            lhs.label == rhs.label &&
            lhs.severityRules == rhs.severityRules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(label)
        hasher.combine(severityRules)
    }
}
