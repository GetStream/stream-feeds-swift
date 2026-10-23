//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderRule: Sendable, Codable, JSONEncodable {
    public let action: RuleBuilderAction?
    public let conditions: [RuleBuilderCondition]?
    public let cooldownPeriod: String?
    public let groups: [RuleBuilderConditionGroup]?
    public let id: String?
    public let logic: String?
    public let ruleType: String

    public init(action: RuleBuilderAction? = nil, conditions: [RuleBuilderCondition]? = nil, cooldownPeriod: String? = nil, groups: [RuleBuilderConditionGroup]? = nil, id: String? = nil, logic: String? = nil, ruleType: String) {
        self.action = action
        self.conditions = conditions
        self.cooldownPeriod = cooldownPeriod
        self.groups = groups
        self.id = id
        self.logic = logic
        self.ruleType = ruleType
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.action = try container.decodeIfPresent(RuleBuilderAction.self, forKey: .action)
        self.conditions = try container.decodeIfPresent([RuleBuilderCondition].self, forKey: .conditions)
        self.cooldownPeriod = try container.decodeIfPresent(String.self, forKey: .cooldownPeriod)
        self.groups = try container.decodeIfPresent([RuleBuilderConditionGroup].self, forKey: .groups)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.logic = try container.decodeIfPresent(String.self, forKey: .logic)
        self.ruleType = try container.decode(String.self, forKey: .ruleType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(action, forKey: .action)
        try container.encodeIfPresent(conditions, forKey: .conditions)
        try container.encodeIfPresent(cooldownPeriod, forKey: .cooldownPeriod)
        try container.encodeIfPresent(groups, forKey: .groups)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(logic, forKey: .logic)
        try container.encode(ruleType, forKey: .ruleType)
    }
}

extension RuleBuilderRule: Hashable {
    public static func == (lhs: RuleBuilderRule, rhs: RuleBuilderRule) -> Bool {
        lhs.action == rhs.action &&
            lhs.conditions == rhs.conditions &&
            lhs.cooldownPeriod == rhs.cooldownPeriod &&
            lhs.groups == rhs.groups &&
            lhs.id == rhs.id &&
            lhs.logic == rhs.logic &&
            lhs.ruleType == rhs.ruleType
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(conditions)
        hasher.combine(cooldownPeriod)
        hasher.combine(groups)
        hasher.combine(id)
        hasher.combine(logic)
        hasher.combine(ruleType)
    }
}
