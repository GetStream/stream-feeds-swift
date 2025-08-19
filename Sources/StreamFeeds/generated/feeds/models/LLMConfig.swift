//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class LLMConfig: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var async: Bool?
    public var enabled: Bool
    public var rules: [LLMRule]
    public var severityDescriptions: [String: String]?

    public init(async: Bool? = nil, enabled: Bool, rules: [LLMRule], severityDescriptions: [String: String]? = nil) {
        self.async = async
        self.enabled = enabled
        self.rules = rules
        self.severityDescriptions = severityDescriptions
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case async
        case enabled
        case rules
        case severityDescriptions = "severity_descriptions"
    }

    public static func == (lhs: LLMConfig, rhs: LLMConfig) -> Bool {
        lhs.async == rhs.async &&
            lhs.enabled == rhs.enabled &&
            lhs.rules == rhs.rules &&
            lhs.severityDescriptions == rhs.severityDescriptions
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(async)
        hasher.combine(enabled)
        hasher.combine(rules)
        hasher.combine(severityDescriptions)
    }
}
