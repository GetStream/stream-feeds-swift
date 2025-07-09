import Foundation
import StreamCore

public final class BodyguardRule: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum BodyguardRuleAction: String, Sendable, Codable, CaseIterable {
        case bounce
        case bounceFlag = "bounce_flag"
        case bounceRemove = "bounce_remove"
        case flag
        case remove
        case shadow
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var action: BodyguardRuleAction
    public var label: String
    public var severityRules: [BodyguardSeverityRule]

    public init(action: BodyguardRuleAction, label: String, severityRules: [BodyguardSeverityRule]) {
        self.action = action
        self.label = label
        self.severityRules = severityRules
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case label
        case severityRules = "severity_rules"
    }

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
