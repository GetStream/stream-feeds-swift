//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderRule: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var action: RuleBuilderAction?
    public var conditions: [RuleBuilderCondition]?
    public var enabled: Bool?
    public var id: String?
    public var name: String?

    public init(action: RuleBuilderAction? = nil, conditions: [RuleBuilderCondition]? = nil, enabled: Bool? = nil, id: String? = nil, name: String? = nil) {
        self.action = action
        self.conditions = conditions
        self.enabled = enabled
        self.id = id
        self.name = name
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action
        case conditions
        case enabled
        case id
        case name
    }

    public static func == (lhs: RuleBuilderRule, rhs: RuleBuilderRule) -> Bool {
        lhs.action == rhs.action &&
            lhs.conditions == rhs.conditions &&
            lhs.enabled == rhs.enabled &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(action)
        hasher.combine(conditions)
        hasher.combine(enabled)
        hasher.combine(id)
        hasher.combine(name)
    }
}
