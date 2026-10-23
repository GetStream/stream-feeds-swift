//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertConfigRequest: Sendable, Codable, JSONEncodable {
    public let aiAudioConfig: AIAudioConfigRequest?
    public let aiImageConfig: AIImageConfig?
    public let aiTextConfig: AITextConfig?
    public let aiVideoConfig: AIVideoConfigRequest?
    /// Whether moderation should be performed asynchronously
    public let async: Bool?
    public let automodPlatformCircumventionConfig: AutomodPlatformCircumventionConfig?
    public let automodSemanticFiltersConfig: AutomodSemanticFiltersConfig?
    public let automodToxicityConfig: AutomodToxicityConfig?
    public let awsRekognitionConfig: AIImageConfig?
    public let blockListConfig: BlockListConfig?
    public let bodyguardConfig: AITextConfig?
    public let floodConfig: FloodConfig?
    public let googleVisionConfig: GoogleVisionConfig?
    public let intentConfig: IntentConfigRequest?
    /// Unique identifier for the moderation configuration
    public let key: String
    public let llmConfig: LLMConfig?
    public let ruleBuilderConfig: RuleBuilderConfig?
    /// Team associated with the configuration
    public let team: String?
    public let velocityFilterConfig: VelocityFilterConfig?

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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.aiAudioConfig = try container.decodeIfPresent(AIAudioConfigRequest.self, forKey: .aiAudioConfig)
        self.aiImageConfig = try container.decodeIfPresent(AIImageConfig.self, forKey: .aiImageConfig)
        self.aiTextConfig = try container.decodeIfPresent(AITextConfig.self, forKey: .aiTextConfig)
        self.aiVideoConfig = try container.decodeIfPresent(AIVideoConfigRequest.self, forKey: .aiVideoConfig)
        self.async = try container.decodeIfPresent(Bool.self, forKey: .async)
        self.automodPlatformCircumventionConfig = try container.decodeIfPresent(AutomodPlatformCircumventionConfig.self, forKey: .automodPlatformCircumventionConfig)
        self.automodSemanticFiltersConfig = try container.decodeIfPresent(AutomodSemanticFiltersConfig.self, forKey: .automodSemanticFiltersConfig)
        self.automodToxicityConfig = try container.decodeIfPresent(AutomodToxicityConfig.self, forKey: .automodToxicityConfig)
        self.awsRekognitionConfig = try container.decodeIfPresent(AIImageConfig.self, forKey: .awsRekognitionConfig)
        self.blockListConfig = try container.decodeIfPresent(BlockListConfig.self, forKey: .blockListConfig)
        self.bodyguardConfig = try container.decodeIfPresent(AITextConfig.self, forKey: .bodyguardConfig)
        self.floodConfig = try container.decodeIfPresent(FloodConfig.self, forKey: .floodConfig)
        self.googleVisionConfig = try container.decodeIfPresent(GoogleVisionConfig.self, forKey: .googleVisionConfig)
        self.intentConfig = try container.decodeIfPresent(IntentConfigRequest.self, forKey: .intentConfig)
        self.key = try container.decode(String.self, forKey: .key)
        self.llmConfig = try container.decodeIfPresent(LLMConfig.self, forKey: .llmConfig)
        self.ruleBuilderConfig = try container.decodeIfPresent(RuleBuilderConfig.self, forKey: .ruleBuilderConfig)
        self.team = try container.decodeIfPresent(String.self, forKey: .team)
        self.velocityFilterConfig = try container.decodeIfPresent(VelocityFilterConfig.self, forKey: .velocityFilterConfig)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(aiAudioConfig, forKey: .aiAudioConfig)
        try container.encodeIfPresent(aiImageConfig, forKey: .aiImageConfig)
        try container.encodeIfPresent(aiTextConfig, forKey: .aiTextConfig)
        try container.encodeIfPresent(aiVideoConfig, forKey: .aiVideoConfig)
        try container.encodeIfPresent(async, forKey: .async)
        try container.encodeIfPresent(automodPlatformCircumventionConfig, forKey: .automodPlatformCircumventionConfig)
        try container.encodeIfPresent(automodSemanticFiltersConfig, forKey: .automodSemanticFiltersConfig)
        try container.encodeIfPresent(automodToxicityConfig, forKey: .automodToxicityConfig)
        try container.encodeIfPresent(awsRekognitionConfig, forKey: .awsRekognitionConfig)
        try container.encodeIfPresent(blockListConfig, forKey: .blockListConfig)
        try container.encodeIfPresent(bodyguardConfig, forKey: .bodyguardConfig)
        try container.encodeIfPresent(floodConfig, forKey: .floodConfig)
        try container.encodeIfPresent(googleVisionConfig, forKey: .googleVisionConfig)
        try container.encodeIfPresent(intentConfig, forKey: .intentConfig)
        try container.encode(key, forKey: .key)
        try container.encodeIfPresent(llmConfig, forKey: .llmConfig)
        try container.encodeIfPresent(ruleBuilderConfig, forKey: .ruleBuilderConfig)
        try container.encodeIfPresent(team, forKey: .team)
        try container.encodeIfPresent(velocityFilterConfig, forKey: .velocityFilterConfig)
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
