//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ConfigResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var aiImageConfig: AIImageConfig?
    public var aiTextConfig: AITextConfig?
    public var aiVideoConfig: AIVideoConfig?
    public var async: Bool
    public var automodPlatformCircumventionConfig: AutomodPlatformCircumventionConfig?
    public var automodSemanticFiltersConfig: AutomodSemanticFiltersConfig?
    public var automodToxicityConfig: AutomodToxicityConfig?
    public var blockListConfig: BlockListConfig?
    public var createdAt: Date
    public var key: String
    public var llmConfig: LLMConfig?
    public var ruleBuilderConfig: RuleBuilderConfig?
    public var team: String
    public var updatedAt: Date
    public var velocityFilterConfig: VelocityFilterConfig?

    public init(aiImageConfig: AIImageConfig? = nil, aiTextConfig: AITextConfig? = nil, aiVideoConfig: AIVideoConfig? = nil, async: Bool, automodPlatformCircumventionConfig: AutomodPlatformCircumventionConfig? = nil, automodSemanticFiltersConfig: AutomodSemanticFiltersConfig? = nil, automodToxicityConfig: AutomodToxicityConfig? = nil, blockListConfig: BlockListConfig? = nil, createdAt: Date, key: String, llmConfig: LLMConfig? = nil, ruleBuilderConfig: RuleBuilderConfig? = nil, team: String, updatedAt: Date, velocityFilterConfig: VelocityFilterConfig? = nil) {
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
        self.ruleBuilderConfig = ruleBuilderConfig
        self.team = team
        self.updatedAt = updatedAt
        self.velocityFilterConfig = velocityFilterConfig
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case aiImageConfig = "ai_image_config"
        case aiTextConfig = "ai_text_config"
        case aiVideoConfig = "ai_video_config"
        case async
        case automodPlatformCircumventionConfig = "automod_platform_circumvention_config"
        case automodSemanticFiltersConfig = "automod_semantic_filters_config"
        case automodToxicityConfig = "automod_toxicity_config"
        case blockListConfig = "block_list_config"
        case createdAt = "created_at"
        case key
        case llmConfig = "llm_config"
        case ruleBuilderConfig = "rule_builder_config"
        case team
        case updatedAt = "updated_at"
        case velocityFilterConfig = "velocity_filter_config"
    }

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
            lhs.ruleBuilderConfig == rhs.ruleBuilderConfig &&
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
        hasher.combine(ruleBuilderConfig)
        hasher.combine(team)
        hasher.combine(updatedAt)
        hasher.combine(velocityFilterConfig)
    }
}
