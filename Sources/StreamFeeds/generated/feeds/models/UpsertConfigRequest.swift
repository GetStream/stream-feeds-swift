//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertConfigRequest: @unchecked Sendable, Codable, JSONEncodable {
    public var aiAudioConfig: AIAudioConfigRequest?
    public var aiImageConfig: AIImageConfig?
    public var aiTextConfig: AITextConfig?
    public var aiVideoConfig: AIVideoConfigRequest?
    /// Whether moderation should be performed asynchronously
    public var async: Bool?
    public var automodPlatformCircumventionConfig: AutomodPlatformCircumventionConfig?
    public var automodSemanticFiltersConfig: AutomodSemanticFiltersConfig?
    public var automodToxicityConfig: AutomodToxicityConfig?
    public var awsRekognitionConfig: AIImageConfig?
    public var blockListConfig: BlockListConfig?
    public var bodyguardConfig: AITextConfig?
    public var floodConfig: FloodConfig?
    public var googleVisionConfig: GoogleVisionConfig?
    public var intentConfig: IntentConfigRequest?
    /// Unique identifier for the moderation configuration
    public var key: String
    public var llmConfig: LLMConfig?
    public var ruleBuilderConfig: RuleBuilderConfig?
    /// Team associated with the configuration
    public var team: String?
    public var velocityFilterConfig: VelocityFilterConfig?

    public init(aiAudioConfig: AIAudioConfigRequest? = nil, aiImageConfig: AIImageConfig? = nil, aiTextConfig: AITextConfig? = nil, aiVideoConfig: AIVideoConfigRequest? = nil, async: Bool? = nil, automodPlatformCircumventionConfig: AutomodPlatformCircumventionConfig? = nil, automodSemanticFiltersConfig: AutomodSemanticFiltersConfig? = nil, automodToxicityConfig: AutomodToxicityConfig? = nil, awsRekognitionConfig: AIImageConfig? = nil, blockListConfig: BlockListConfig? = nil, bodyguardConfig: AITextConfig? = nil, floodConfig: FloodConfig? = nil, googleVisionConfig: GoogleVisionConfig? = nil, intentConfig: IntentConfigRequest? = nil, key: String, llmConfig: LLMConfig? = nil, ruleBuilderConfig: RuleBuilderConfig? = nil, team: String? = nil, velocityFilterConfig: VelocityFilterConfig? = nil) {
        self.aiAudioConfig = aiAudioConfig
        self.aiImageConfig = aiImageConfig
        self.aiTextConfig = aiTextConfig
        self.aiVideoConfig = aiVideoConfig
        self.async = async
        self.automodPlatformCircumventionConfig = automodPlatformCircumventionConfig
        self.automodSemanticFiltersConfig = automodSemanticFiltersConfig
        self.automodToxicityConfig = automodToxicityConfig
        self.awsRekognitionConfig = awsRekognitionConfig
        self.blockListConfig = blockListConfig
        self.bodyguardConfig = bodyguardConfig
        self.floodConfig = floodConfig
        self.googleVisionConfig = googleVisionConfig
        self.intentConfig = intentConfig
        self.key = key
        self.llmConfig = llmConfig
        self.ruleBuilderConfig = ruleBuilderConfig
        self.team = team
        self.velocityFilterConfig = velocityFilterConfig
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case aiAudioConfig = "ai_audio_config"
        case aiImageConfig = "ai_image_config"
        case aiTextConfig = "ai_text_config"
        case aiVideoConfig = "ai_video_config"
        case async
        case automodPlatformCircumventionConfig = "automod_platform_circumvention_config"
        case automodSemanticFiltersConfig = "automod_semantic_filters_config"
        case automodToxicityConfig = "automod_toxicity_config"
        case awsRekognitionConfig = "aws_rekognition_config"
        case blockListConfig = "block_list_config"
        case bodyguardConfig = "bodyguard_config"
        case floodConfig = "flood_config"
        case googleVisionConfig = "google_vision_config"
        case intentConfig = "intent_config"
        case key
        case llmConfig = "llm_config"
        case ruleBuilderConfig = "rule_builder_config"
        case team
        case velocityFilterConfig = "velocity_filter_config"
    }
}

extension UpsertConfigRequest: Hashable {
    public static func == (lhs: UpsertConfigRequest, rhs: UpsertConfigRequest) -> Bool {
        lhs.aiAudioConfig == rhs.aiAudioConfig &&
            lhs.aiImageConfig == rhs.aiImageConfig &&
            lhs.aiTextConfig == rhs.aiTextConfig &&
            lhs.aiVideoConfig == rhs.aiVideoConfig &&
            lhs.async == rhs.async &&
            lhs.automodPlatformCircumventionConfig == rhs.automodPlatformCircumventionConfig &&
            lhs.automodSemanticFiltersConfig == rhs.automodSemanticFiltersConfig &&
            lhs.automodToxicityConfig == rhs.automodToxicityConfig &&
            lhs.awsRekognitionConfig == rhs.awsRekognitionConfig &&
            lhs.blockListConfig == rhs.blockListConfig &&
            lhs.bodyguardConfig == rhs.bodyguardConfig &&
            lhs.floodConfig == rhs.floodConfig &&
            lhs.googleVisionConfig == rhs.googleVisionConfig &&
            lhs.intentConfig == rhs.intentConfig &&
            lhs.key == rhs.key &&
            lhs.llmConfig == rhs.llmConfig &&
            lhs.ruleBuilderConfig == rhs.ruleBuilderConfig &&
            lhs.team == rhs.team &&
            lhs.velocityFilterConfig == rhs.velocityFilterConfig
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(aiAudioConfig)
        hasher.combine(aiImageConfig)
        hasher.combine(aiTextConfig)
        hasher.combine(aiVideoConfig)
        hasher.combine(async)
        hasher.combine(automodPlatformCircumventionConfig)
        hasher.combine(automodSemanticFiltersConfig)
        hasher.combine(automodToxicityConfig)
        hasher.combine(awsRekognitionConfig)
        hasher.combine(blockListConfig)
        hasher.combine(bodyguardConfig)
        hasher.combine(floodConfig)
        hasher.combine(googleVisionConfig)
        hasher.combine(intentConfig)
        hasher.combine(key)
        hasher.combine(llmConfig)
        hasher.combine(ruleBuilderConfig)
        hasher.combine(team)
        hasher.combine(velocityFilterConfig)
    }
}
