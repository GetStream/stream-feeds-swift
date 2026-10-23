//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class LLMConfig: @unchecked Sendable, Codable, JSONEncodable {
    public var appContext: String?
    public var async: Bool?
    public var contextCustomKeys: [String]?
    public var customKeysContextDescription: String?
    public var enabled: Bool
    public var rules: [LLMRule]
    public var severityDescriptions: [String: String]?

    public init(appContext: String? = nil, async: Bool? = nil, contextCustomKeys: [String]? = nil, customKeysContextDescription: String? = nil, enabled: Bool, rules: [LLMRule], severityDescriptions: [String: String]? = nil) {
        self.appContext = appContext
        self.async = async
        self.contextCustomKeys = contextCustomKeys
        self.customKeysContextDescription = customKeysContextDescription
        self.enabled = enabled
        self.rules = rules
        self.severityDescriptions = severityDescriptions
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case appContext = "app_context"
        case async
        case contextCustomKeys = "context_custom_keys"
        case customKeysContextDescription = "custom_keys_context_description"
        case enabled
        case rules
        case severityDescriptions = "severity_descriptions"
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
