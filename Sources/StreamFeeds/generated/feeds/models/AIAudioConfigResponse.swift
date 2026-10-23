//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AIAudioConfigResponse: Sendable, Codable, JSONEncodable {
    public let aiTextConfig: AITextConfig?
    /// Whether the engine selected by the application's LLM configurability flag has a rule that does something. Derived, not stored
    public let enabled: Bool
    public let llmConfig: LLMConfig?
    /// The active engine's rules, flattened into the pre-split shape for clients that predate the per-engine configs. This is the whole config for a policy that has no per-engine config stored
    public let rules: [BodyguardRule]

    public init(aiTextConfig: AITextConfig? = nil, enabled: Bool, llmConfig: LLMConfig? = nil, rules: [BodyguardRule]) {
        self.aiTextConfig = aiTextConfig
        self.enabled = enabled
        self.llmConfig = llmConfig
        self.rules = rules
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.aiTextConfig = try container.decodeIfPresent(AITextConfig.self, forKey: .aiTextConfig)
        self.enabled = try container.decode(Bool.self, forKey: .enabled)
        self.llmConfig = try container.decodeIfPresent(LLMConfig.self, forKey: .llmConfig)
        self.rules = try container.decode([BodyguardRule].self, forKey: .rules)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(aiTextConfig, forKey: .aiTextConfig)
        try container.encode(enabled, forKey: .enabled)
        try container.encodeIfPresent(llmConfig, forKey: .llmConfig)
        try container.encode(rules, forKey: .rules)
    }
}

extension AIAudioConfigResponse: Hashable {
    public static func == (lhs: AIAudioConfigResponse, rhs: AIAudioConfigResponse) -> Bool {
        lhs.aiTextConfig == rhs.aiTextConfig &&
            lhs.enabled == rhs.enabled &&
            lhs.llmConfig == rhs.llmConfig &&
            lhs.rules == rhs.rules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(aiTextConfig)
        hasher.combine(enabled)
        hasher.combine(llmConfig)
        hasher.combine(rules)
    }
}
