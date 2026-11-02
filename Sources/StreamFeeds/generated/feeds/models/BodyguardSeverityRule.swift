//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class BodyguardSeverityRuleAction: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let bounce = BodyguardSeverityRuleAction(rawValue: "bounce")
    public static let bounceFlag = BodyguardSeverityRuleAction(rawValue: "bounce_flag")
    public static let bounceRemove = BodyguardSeverityRuleAction(rawValue: "bounce_remove")
    public static let flag = BodyguardSeverityRuleAction(rawValue: "flag")
    public static let keep = BodyguardSeverityRuleAction(rawValue: "keep")
    public static let mask = BodyguardSeverityRuleAction(rawValue: "mask")
    public static let remove = BodyguardSeverityRuleAction(rawValue: "remove")
    public static let shadow = BodyguardSeverityRuleAction(rawValue: "shadow")
}

public final class BodyguardSeverityRuleSeverity: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let critical = BodyguardSeverityRuleSeverity(rawValue: "critical")
    public static let high = BodyguardSeverityRuleSeverity(rawValue: "high")
    public static let low = BodyguardSeverityRuleSeverity(rawValue: "low")
    public static let medium = BodyguardSeverityRuleSeverity(rawValue: "medium")
}

public final class BodyguardSeverityRule: Sendable, Codable, JSONEncodable {
    public let action: BodyguardSeverityRuleAction
    public let severity: BodyguardSeverityRuleSeverity

    public init(action: BodyguardSeverityRuleAction, severity: BodyguardSeverityRuleSeverity) {
        self.action = action
        self.severity = severity
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(BodyguardSeverityRuleAction.self, forKey: .action)
        self.severity = try container.decode(BodyguardSeverityRuleSeverity.self, forKey: .severity)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encode(severity, forKey: .severity)
    }
}

extension BodyguardSeverityRule: Hashable {
    public static func == (lhs: BodyguardSeverityRule, rhs: BodyguardSeverityRule) -> Bool {
        lhs.action == rhs.action &&
            lhs.severity == rhs.severity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(severity)
    }
}
