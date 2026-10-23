//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AutomodRuleAction: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let bounce = AutomodRuleAction(rawValue: "bounce")
    public static let bounceFlag = AutomodRuleAction(rawValue: "bounce_flag")
    public static let bounceRemove = AutomodRuleAction(rawValue: "bounce_remove")
    public static let flag = AutomodRuleAction(rawValue: "flag")
    public static let remove = AutomodRuleAction(rawValue: "remove")
    public static let shadow = AutomodRuleAction(rawValue: "shadow")
}

public final class AutomodRule: Sendable, Codable, JSONEncodable {
    public let action: AutomodRuleAction
    public let label: String
    public let threshold: Double

    public init(action: AutomodRuleAction, label: String, threshold: Double) {
        self.action = action
        self.label = label
        self.threshold = threshold
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decode(AutomodRuleAction.self, forKey: .action)
        self.label = try container.decode(String.self, forKey: .label)
        self.threshold = try container.decode(Double.self, forKey: .threshold)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(action, forKey: .action)
        try container.encode(label, forKey: .label)
        try container.encode(threshold, forKey: .threshold)
    }
}

extension AutomodRule: Hashable {
    public static func == (lhs: AutomodRule, rhs: AutomodRule) -> Bool {
        lhs.action == rhs.action &&
            lhs.label == rhs.label &&
            lhs.threshold == rhs.threshold
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(label)
        hasher.combine(threshold)
    }
}
