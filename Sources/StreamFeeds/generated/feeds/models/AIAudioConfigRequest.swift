//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class AIAudioConfigRequest: Sendable, Codable, JSONEncodable {
    public let aiTextConfig: AITextConfig?
    public let llmConfig: LLMConfig?
    /// Deprecated pre-split rule list. Still the live config while no engine config exists; once one does it is kept as a fallback for whichever engine has none of its own
    public let rules: [BodyguardRule]?

    public init(aiTextConfig: AITextConfig? = nil, llmConfig: LLMConfig? = nil, rules: [BodyguardRule]? = nil) {
        self.aiTextConfig = aiTextConfig
        self.llmConfig = llmConfig
        self.rules = rules
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.aiTextConfig = try container.decodeIfPresent(AITextConfig.self, forKey: .aiTextConfig)
        self.llmConfig = try container.decodeIfPresent(LLMConfig.self, forKey: .llmConfig)
        self.rules = try container.decodeIfPresent([BodyguardRule].self, forKey: .rules)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(aiTextConfig, forKey: .aiTextConfig)
        try container.encodeIfPresent(llmConfig, forKey: .llmConfig)
        try container.encodeIfPresent(rules, forKey: .rules)
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
