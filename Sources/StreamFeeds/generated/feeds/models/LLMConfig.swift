//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class LLMConfig: Sendable, Codable, JSONEncodable {
    public let appContext: String?
    public let async: Bool?
    public let contextCustomKeys: [String]?
    public let customKeysContextDescription: String?
    public let enabled: Bool
    public let rules: [LLMRule]
    public let severityDescriptions: [String: String]?

    public init(appContext: String? = nil, async: Bool? = nil, contextCustomKeys: [String]? = nil, customKeysContextDescription: String? = nil, enabled: Bool, rules: [LLMRule], severityDescriptions: [String: String]? = nil) {
        self.appContext = appContext
        self.async = async
        self.contextCustomKeys = contextCustomKeys
        self.customKeysContextDescription = customKeysContextDescription
        self.enabled = enabled
        self.rules = rules
        self.severityDescriptions = severityDescriptions
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.appContext = try container.decodeIfPresent(String.self, forKey: .appContext)
        self.async = try container.decodeIfPresent(Bool.self, forKey: .async)
        self.contextCustomKeys = try container.decodeIfPresent([String].self, forKey: .contextCustomKeys)
        self.customKeysContextDescription = try container.decodeIfPresent(String.self, forKey: .customKeysContextDescription)
        self.enabled = try container.decode(Bool.self, forKey: .enabled)
        self.rules = try container.decode([LLMRule].self, forKey: .rules)
        self.severityDescriptions = try container.decodeIfPresent([String: String].self, forKey: .severityDescriptions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(appContext, forKey: .appContext)
        try container.encodeIfPresent(async, forKey: .async)
        try container.encodeIfPresent(contextCustomKeys, forKey: .contextCustomKeys)
        try container.encodeIfPresent(customKeysContextDescription, forKey: .customKeysContextDescription)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(rules, forKey: .rules)
        try container.encodeIfPresent(severityDescriptions, forKey: .severityDescriptions)
    }
}

extension LLMConfig: Hashable {
    public static func == (lhs: LLMConfig, rhs: LLMConfig) -> Bool {
        lhs.appContext == rhs.appContext &&
            lhs.async == rhs.async &&
            lhs.contextCustomKeys == rhs.contextCustomKeys &&
            lhs.customKeysContextDescription == rhs.customKeysContextDescription &&
            lhs.enabled == rhs.enabled &&
            lhs.rules == rhs.rules &&
            lhs.severityDescriptions == rhs.severityDescriptions
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(appContext)
        hasher.combine(async)
        hasher.combine(contextCustomKeys)
        hasher.combine(customKeysContextDescription)
        hasher.combine(enabled)
        hasher.combine(rules)
        hasher.combine(severityDescriptions)
    }
}
