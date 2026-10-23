//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class RuleBuilderConfig: Sendable, Codable, JSONEncodable {
    public let async: Bool?
    public let rules: [RuleBuilderRule]?

    public init(async: Bool? = nil, rules: [RuleBuilderRule]? = nil) {
        self.async = async
        self.rules = rules
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.async = try container.decodeIfPresent(Bool.self, forKey: .async)
        self.rules = try container.decodeIfPresent([RuleBuilderRule].self, forKey: .rules)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(async, forKey: .async)
        try container.encodeIfPresent(rules, forKey: .rules)
    }
}

extension RuleBuilderConfig: Hashable {
    public static func == (lhs: RuleBuilderConfig, rhs: RuleBuilderConfig) -> Bool {
        lhs.async == rhs.async &&
            lhs.rules == rhs.rules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(async)
        hasher.combine(rules)
    }
}
