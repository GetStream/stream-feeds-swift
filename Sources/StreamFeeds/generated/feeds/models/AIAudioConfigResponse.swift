//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AIAudioConfigResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var aiTextConfig: AITextConfig?
    /// Whether the engine selected by the application's LLM configurability flag has a rule that does something. Derived, not stored
    public var enabled: Bool
    public var llmConfig: LLMConfig?
    /// The active engine's rules, flattened into the pre-split shape for clients that predate the per-engine configs. This is the whole config for a policy that has no per-engine config stored
    public var rules: [BodyguardRule]

    public init(aiTextConfig: AITextConfig? = nil, enabled: Bool, llmConfig: LLMConfig? = nil, rules: [BodyguardRule]) {
        self.aiTextConfig = aiTextConfig
        self.enabled = enabled
        self.llmConfig = llmConfig
        self.rules = rules
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case aiTextConfig = "ai_text_config"
        case enabled
        case llmConfig = "llm_config"
        case rules
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
