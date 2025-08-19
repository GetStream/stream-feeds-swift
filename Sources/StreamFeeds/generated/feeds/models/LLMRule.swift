//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class LLMRule: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public enum LLMRuleAction: String, Sendable, Codable, CaseIterable {
        case bounce
        case bounceFlag = "bounce_flag"
        case bounceRemove = "bounce_remove"
        case flag
        case keep
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

    public var action: LLMRuleAction
    public var description: String
    public var label: String
    public var severityRules: [BodyguardSeverityRule]

    public init(action: LLMRuleAction, description: String, label: String, severityRules: [BodyguardSeverityRule]) {
        self.action = action
        self.description = description
        self.label = label
        self.severityRules = severityRules
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case description
        case label
        case severityRules = "severity_rules"
    }

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
