//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AIAudioConfigRequest: @unchecked Sendable, Codable, JSONEncodable {
    public var aiTextConfig: AITextConfig?
    public var llmConfig: LLMConfig?
    /// Deprecated pre-split rule list. Still the live config while no engine config exists; once one does it is kept as a fallback for whichever engine has none of its own
    public var rules: [BodyguardRule]?

    public init(
        aiTextConfig: AITextConfig? = nil,
        llmConfig: LLMConfig? = nil,
        rules: [BodyguardRule]? = nil
    ) {
        self.aiTextConfig = aiTextConfig
        self.llmConfig = llmConfig
        self.rules = rules
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case aiTextConfig = "ai_text_config"
        case llmConfig = "llm_config"
        case rules
    }
}

extension AIAudioConfigRequest: Hashable {
    public static func == (lhs: AIAudioConfigRequest, rhs: AIAudioConfigRequest) -> Bool {
        lhs.aiTextConfig == rhs.aiTextConfig &&
            lhs.llmConfig == rhs.llmConfig &&
            lhs.rules == rhs.rules
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(aiTextConfig)
        hasher.combine(llmConfig)
        hasher.combine(rules)
    }
}
