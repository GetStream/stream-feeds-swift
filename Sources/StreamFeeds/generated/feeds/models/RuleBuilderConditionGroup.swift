//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderConditionGroup: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var conditions: [RuleBuilderCondition]
    public var logic: String

    public init(conditions: [RuleBuilderCondition], logic: String) {
        self.conditions = conditions
        self.logic = logic
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case conditions
        case logic
    }

    public static func == (lhs: RuleBuilderConditionGroup, rhs: RuleBuilderConditionGroup) -> Bool {
        lhs.conditions == rhs.conditions &&
            lhs.logic == rhs.logic
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(conditions)
        hasher.combine(logic)
    }
}
