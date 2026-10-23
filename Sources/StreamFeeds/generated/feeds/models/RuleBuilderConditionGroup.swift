//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderConditionGroup: Sendable, Codable, JSONEncodable {
    public let conditions: [RuleBuilderCondition]?
    public let logic: String?

    public init(conditions: [RuleBuilderCondition]? = nil, logic: String? = nil) {
        self.conditions = conditions
        self.logic = logic
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.conditions = try container.decodeIfPresent([RuleBuilderCondition].self, forKey: .conditions)
        self.logic = try container.decodeIfPresent(String.self, forKey: .logic)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(conditions, forKey: .conditions)
        try container.encodeIfPresent(logic, forKey: .logic)
    }
}

extension RuleBuilderConditionGroup: Hashable {
    public static func == (lhs: RuleBuilderConditionGroup, rhs: RuleBuilderConditionGroup) -> Bool {
        lhs.conditions == rhs.conditions &&
            lhs.logic == rhs.logic
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(conditions)
        hasher.combine(logic)
    }
}
