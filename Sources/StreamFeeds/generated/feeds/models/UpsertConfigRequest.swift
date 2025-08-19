//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertConfigRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var aiImageConfig: AIImageConfig?
    public var aiTextConfig: AITextConfig?
    public var aiVideoConfig: AIVideoConfig?
    public var async: Bool?
    public var automodPlatformCircumventionConfig: AutomodPlatformCircumventionConfig?
    public var automodSemanticFiltersConfig: AutomodSemanticFiltersConfig?
    public var automodToxicityConfig: AutomodToxicityConfig?
    public var awsRekognitionConfig: AIImageConfig?
    public var blockListConfig: BlockListConfig?
    public var bodyguardConfig: AITextConfig?
    public var googleVisionConfig: GoogleVisionConfig?
    public var key: String
    public var llmConfig: LLMConfig?
    public var ruleBuilderConfig: RuleBuilderConfig?
    public var team: String?
    public var velocityFilterConfig: VelocityFilterConfig?

    public init(aiImageConfig: AIImageConfig? = nil, aiTextConfig: AITextConfig? = nil, aiVideoConfig: AIVideoConfig? = nil, async: Bool? = nil, automodPlatformCircumventionConfig: AutomodPlatformCircumventionConfig? = nil, automodSemanticFiltersConfig: AutomodSemanticFiltersConfig? = nil, automodToxicityConfig: AutomodToxicityConfig? = nil, awsRekognitionConfig: AIImageConfig? = nil, blockListConfig: BlockListConfig? = nil, bodyguardConfig: AITextConfig? = nil, googleVisionConfig: GoogleVisionConfig? = nil, key: String, llmConfig: LLMConfig? = nil, ruleBuilderConfig: RuleBuilderConfig? = nil, team: String? = nil, velocityFilterConfig: VelocityFilterConfig? = nil) {
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
        self.googleVisionConfig = googleVisionConfig
        self.key = key
        self.llmConfig = llmConfig
        self.ruleBuilderConfig = ruleBuilderConfig
        self.team = team
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
        case awsRekognitionConfig = "aws_rekognition_config"
        case blockListConfig = "block_list_config"
        case bodyguardConfig = "bodyguard_config"
        case googleVisionConfig = "google_vision_config"
        case key
        case llmConfig = "llm_config"
        case ruleBuilderConfig = "rule_builder_config"
        case team
        case velocityFilterConfig = "velocity_filter_config"
    }

    public static func == (lhs: UpsertConfigRequest, rhs: UpsertConfigRequest) -> Bool {
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
            lhs.googleVisionConfig == rhs.googleVisionConfig &&
            lhs.key == rhs.key &&
            lhs.llmConfig == rhs.llmConfig &&
            lhs.ruleBuilderConfig == rhs.ruleBuilderConfig &&
            lhs.team == rhs.team &&
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
        hasher.combine(awsRekognitionConfig)
        hasher.combine(blockListConfig)
        hasher.combine(bodyguardConfig)
        hasher.combine(googleVisionConfig)
        hasher.combine(key)
        hasher.combine(llmConfig)
        hasher.combine(ruleBuilderConfig)
        hasher.combine(team)
        hasher.combine(velocityFilterConfig)
    }
}
