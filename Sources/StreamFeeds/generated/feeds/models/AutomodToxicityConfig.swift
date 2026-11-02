//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AutomodToxicityConfig: Sendable, Codable, JSONEncodable {
    public let async: Bool?
    public let enabled: Bool
    public let rules: [AutomodRule]

    public init(async: Bool? = nil, enabled: Bool, rules: [AutomodRule]) {
        self.async = async
        self.enabled = enabled
        self.rules = rules
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.async = try container.decodeIfPresent(Bool.self, forKey: .async)
        self.enabled = try container.decode(Bool.self, forKey: .enabled)
        self.rules = try container.decode([AutomodRule].self, forKey: .rules)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(async, forKey: .async)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(rules, forKey: .rules)
    }
}

extension AutomodToxicityConfig: Hashable {
    public static func == (lhs: AutomodToxicityConfig, rhs: AutomodToxicityConfig) -> Bool {
        lhs.async == rhs.async &&
            lhs.enabled == rhs.enabled &&
            lhs.rules == rhs.rules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(async)
        hasher.combine(enabled)
        hasher.combine(rules)
    }
}
