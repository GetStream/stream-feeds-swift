//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderRule: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var action: RuleBuilderAction
    public var conditions: [RuleBuilderCondition]?
    public var cooldownPeriod: String?
    public var groups: [RuleBuilderConditionGroup]?
    public var id: String?
    public var logic: String?
    public var ruleType: String

    public init(action: RuleBuilderAction, conditions: [RuleBuilderCondition]? = nil, cooldownPeriod: String? = nil, groups: [RuleBuilderConditionGroup]? = nil, id: String? = nil, logic: String? = nil, ruleType: String) {
        self.action = action
        self.conditions = conditions
        self.cooldownPeriod = cooldownPeriod
        self.groups = groups
        self.id = id
        self.logic = logic
        self.ruleType = ruleType
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case conditions
        case cooldownPeriod = "cooldown_period"
        case groups
        case id
        case logic
        case ruleType = "rule_type"
    }

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
