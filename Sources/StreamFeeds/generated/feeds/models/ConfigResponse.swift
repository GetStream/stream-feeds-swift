//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ConfigResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var aiAudioConfig: AIAudioConfigResponse?
    public var aiImageConfig: AIImageConfig?
    /// Configurable image moderation label definitions for dashboard rendering
    public var aiImageLabelDefinitions: [AIImageLabelDefinition]?
    /// Available L2 subclassifications per L1 image moderation label, based on the active provider
    public var aiImageSubclassifications: [String: [String]]?
    public var aiTextConfig: AITextConfig?
    public var aiVideoConfig: AIVideoConfigResponse?
    /// Whether moderation should be performed asynchronously
    public var async: Bool
    public var automodPlatformCircumventionConfig: AutomodPlatformCircumventionConfig?
    public var automodSemanticFiltersConfig: AutomodSemanticFiltersConfig?
    public var automodToxicityConfig: AutomodToxicityConfig?
    public var blockListConfig: BlockListConfig?
    /// When the configuration was created
    public var createdAt: Date
    public var floodConfig: FloodConfig?
    public var intentConfig: IntentConfigResponse?
    /// Unique identifier for the moderation configuration
    public var key: String
    public var llmConfig: LLMConfig?
    /// Team associated with the configuration
    public var team: String
    /// When the configuration was last updated
    public var updatedAt: Date
    public var velocityFilterConfig: VelocityFilterConfig?

    public init(aiAudioConfig: AIAudioConfigResponse? = nil, aiImageConfig: AIImageConfig? = nil, aiImageLabelDefinitions: [AIImageLabelDefinition]? = nil, aiImageSubclassifications: [String: [String]]? = nil, aiTextConfig: AITextConfig? = nil, aiVideoConfig: AIVideoConfigResponse? = nil, async: Bool, automodPlatformCircumventionConfig: AutomodPlatformCircumventionConfig? = nil, automodSemanticFiltersConfig: AutomodSemanticFiltersConfig? = nil, automodToxicityConfig: AutomodToxicityConfig? = nil, blockListConfig: BlockListConfig? = nil, createdAt: Date, floodConfig: FloodConfig? = nil, intentConfig: IntentConfigResponse? = nil, key: String, llmConfig: LLMConfig? = nil, team: String, updatedAt: Date, velocityFilterConfig: VelocityFilterConfig? = nil) {
        self.aiAudioConfig = aiAudioConfig
        self.aiImageConfig = aiImageConfig
        self.aiImageLabelDefinitions = aiImageLabelDefinitions
        self.aiImageSubclassifications = aiImageSubclassifications
        self.aiTextConfig = aiTextConfig
        self.aiVideoConfig = aiVideoConfig
        self.async = async
        self.automodPlatformCircumventionConfig = automodPlatformCircumventionConfig
        self.automodSemanticFiltersConfig = automodSemanticFiltersConfig
        self.automodToxicityConfig = automodToxicityConfig
        self.blockListConfig = blockListConfig
        self.createdAt = createdAt
        self.floodConfig = floodConfig
        self.intentConfig = intentConfig
        self.key = key
        self.llmConfig = llmConfig
        self.team = team
        self.updatedAt = updatedAt
        self.velocityFilterConfig = velocityFilterConfig
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case aiAudioConfig = "ai_audio_config"
        case aiImageConfig = "ai_image_config"
        case aiImageLabelDefinitions = "ai_image_label_definitions"
        case aiImageSubclassifications = "ai_image_subclassifications"
        case aiTextConfig = "ai_text_config"
        case aiVideoConfig = "ai_video_config"
        case async
        case automodPlatformCircumventionConfig = "automod_platform_circumvention_config"
        case automodSemanticFiltersConfig = "automod_semantic_filters_config"
        case automodToxicityConfig = "automod_toxicity_config"
        case blockListConfig = "block_list_config"
        case createdAt = "created_at"
        case floodConfig = "flood_config"
        case intentConfig = "intent_config"
        case key
        case llmConfig = "llm_config"
        case team
        case updatedAt = "updated_at"
        case velocityFilterConfig = "velocity_filter_config"
    }
}

extension ConfigResponse: Hashable {
    public static func == (lhs: ConfigResponse, rhs: ConfigResponse) -> Bool {
        lhs.aiAudioConfig == rhs.aiAudioConfig &&
            lhs.aiImageConfig == rhs.aiImageConfig &&
            lhs.aiImageLabelDefinitions == rhs.aiImageLabelDefinitions &&
            lhs.aiImageSubclassifications == rhs.aiImageSubclassifications &&
            lhs.aiTextConfig == rhs.aiTextConfig &&
            lhs.aiVideoConfig == rhs.aiVideoConfig &&
            lhs.async == rhs.async &&
            lhs.automodPlatformCircumventionConfig == rhs.automodPlatformCircumventionConfig &&
            lhs.automodSemanticFiltersConfig == rhs.automodSemanticFiltersConfig &&
            lhs.automodToxicityConfig == rhs.automodToxicityConfig &&
            lhs.blockListConfig == rhs.blockListConfig &&
            lhs.createdAt == rhs.createdAt &&
            lhs.floodConfig == rhs.floodConfig &&
            lhs.intentConfig == rhs.intentConfig &&
            lhs.key == rhs.key &&
            lhs.llmConfig == rhs.llmConfig &&
            lhs.team == rhs.team &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.velocityFilterConfig == rhs.velocityFilterConfig
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(aiAudioConfig)
        hasher.combine(aiImageConfig)
        hasher.combine(aiImageLabelDefinitions)
        hasher.combine(aiImageSubclassifications)
        hasher.combine(aiTextConfig)
        hasher.combine(aiVideoConfig)
        hasher.combine(async)
        hasher.combine(automodPlatformCircumventionConfig)
        hasher.combine(automodSemanticFiltersConfig)
        hasher.combine(automodToxicityConfig)
        hasher.combine(blockListConfig)
        hasher.combine(createdAt)
        hasher.combine(floodConfig)
        hasher.combine(intentConfig)
        hasher.combine(key)
        hasher.combine(llmConfig)
        hasher.combine(team)
        hasher.combine(updatedAt)
        hasher.combine(velocityFilterConfig)
    }
}
