//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var async: Bool?
    public var rules: [RuleBuilderRule]?

    public init(async: Bool? = nil, rules: [RuleBuilderRule]? = nil) {
        self.async = async
        self.rules = rules
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case async
        case rules
    }

    public static func == (lhs: RuleBuilderConfig, rhs: RuleBuilderConfig) -> Bool {
        lhs.async == rhs.async &&
            lhs.rules == rhs.rules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(async)
        hasher.combine(rules)
    }
}
