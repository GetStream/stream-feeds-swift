//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ConfigResponse: Sendable, Decodable {
    public let aiImageConfig: AIImageConfig?
    public let aiTextConfig: AITextConfig?
    public let aiVideoConfig: AIVideoConfigResponse?
    /// Whether moderation should be performed asynchronously
    public let async: Bool
    public let automodPlatformCircumventionConfig: AutomodPlatformCircumventionConfig?
    public let automodSemanticFiltersConfig: AutomodSemanticFiltersConfig?
    public let automodToxicityConfig: AutomodToxicityConfig?
    public let blockListConfig: BlockListConfig?
    /// When the configuration was created
    public let createdAt: Date
    /// Unique identifier for the moderation configuration
    public let key: String
    public let llmConfig: LLMConfig?
    /// Team associated with the configuration
    public let team: String
    /// When the configuration was last updated
    public let updatedAt: Date
    public let velocityFilterConfig: VelocityFilterConfig?

    public init(aiImageConfig: AIImageConfig? = nil, aiTextConfig: AITextConfig? = nil, aiVideoConfig: AIVideoConfigResponse? = nil, async: Bool, automodPlatformCircumventionConfig: AutomodPlatformCircumventionConfig? = nil, automodSemanticFiltersConfig: AutomodSemanticFiltersConfig? = nil, automodToxicityConfig: AutomodToxicityConfig? = nil, blockListConfig: BlockListConfig? = nil, createdAt: Date, key: String, llmConfig: LLMConfig? = nil, team: String, updatedAt: Date, velocityFilterConfig: VelocityFilterConfig? = nil) {
        self.aiImageConfig = aiImageConfig
        self.aiTextConfig = aiTextConfig
        self.aiVideoConfig = aiVideoConfig
        self.async = async
        self.automodPlatformCircumventionConfig = automodPlatformCircumventionConfig
        self.automodSemanticFiltersConfig = automodSemanticFiltersConfig
        self.automodToxicityConfig = automodToxicityConfig
        self.blockListConfig = blockListConfig
        self.createdAt = createdAt
        self.key = key
        self.llmConfig = llmConfig
        self.team = team
        self.updatedAt = updatedAt
        self.velocityFilterConfig = velocityFilterConfig
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.aiImageConfig = try container.decodeIfPresent(AIImageConfig.self, forKey: .aiImageConfig)
        self.aiTextConfig = try container.decodeIfPresent(AITextConfig.self, forKey: .aiTextConfig)
        self.aiVideoConfig = try container.decodeIfPresent(AIVideoConfigResponse.self, forKey: .aiVideoConfig)
        self.async = try container.decode(Bool.self, forKey: .async)
        self.automodPlatformCircumventionConfig = try container.decodeIfPresent(AutomodPlatformCircumventionConfig.self, forKey: .automodPlatformCircumventionConfig)
        self.automodSemanticFiltersConfig = try container.decodeIfPresent(AutomodSemanticFiltersConfig.self, forKey: .automodSemanticFiltersConfig)
        self.automodToxicityConfig = try container.decodeIfPresent(AutomodToxicityConfig.self, forKey: .automodToxicityConfig)
        self.blockListConfig = try container.decodeIfPresent(BlockListConfig.self, forKey: .blockListConfig)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.key = try container.decode(String.self, forKey: .key)
        self.llmConfig = try container.decodeIfPresent(LLMConfig.self, forKey: .llmConfig)
        self.team = try container.decode(String.self, forKey: .team)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.velocityFilterConfig = try container.decodeIfPresent(VelocityFilterConfig.self, forKey: .velocityFilterConfig)
    }
}

extension ConfigResponse: Hashable {
    public static func == (lhs: ConfigResponse, rhs: ConfigResponse) -> Bool {
        lhs.aiImageConfig == rhs.aiImageConfig &&
            lhs.aiTextConfig == rhs.aiTextConfig &&
            lhs.aiVideoConfig == rhs.aiVideoConfig &&
            lhs.async == rhs.async &&
            lhs.automodPlatformCircumventionConfig == rhs.automodPlatformCircumventionConfig &&
            lhs.automodSemanticFiltersConfig == rhs.automodSemanticFiltersConfig &&
            lhs.automodToxicityConfig == rhs.automodToxicityConfig &&
            lhs.blockListConfig == rhs.blockListConfig &&
            lhs.createdAt == rhs.createdAt &&
            lhs.key == rhs.key &&
            lhs.llmConfig == rhs.llmConfig &&
            lhs.team == rhs.team &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.velocityFilterConfig == rhs.velocityFilterConfig
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(aiImageConfig)
        hasher.combine(aiTextConfig)
        hasher.combine(aiVideoConfig)
        hasher.combine(async)
        hasher.combine(automodPlatformCircumventionConfig)
        hasher.combine(automodSemanticFiltersConfig)
        hasher.combine(automodToxicityConfig)
        hasher.combine(blockListConfig)
        hasher.combine(createdAt)
        hasher.combine(key)
        hasher.combine(llmConfig)
        hasher.combine(team)
        hasher.combine(updatedAt)
        hasher.combine(velocityFilterConfig)
    }
}
