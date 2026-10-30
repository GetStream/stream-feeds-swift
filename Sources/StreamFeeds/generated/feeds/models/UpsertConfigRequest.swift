//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpsertConfigRequest: Sendable, Encodable, JSONEncodable {
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
    public let googleVisionConfig: GoogleVisionConfig?
    /// Unique identifier for the moderation configuration
    public let key: String
    public let llmConfig: LLMConfig?
    public let ruleBuilderConfig: RuleBuilderConfig?
    /// Team associated with the configuration
    public let team: String?
    public let velocityFilterConfig: VelocityFilterConfig?

    public init(aiImageConfig: AIImageConfig? = nil, aiTextConfig: AITextConfig? = nil, aiVideoConfig: AIVideoConfigRequest? = nil, async: Bool? = nil, automodPlatformCircumventionConfig: AutomodPlatformCircumventionConfig? = nil, automodSemanticFiltersConfig: AutomodSemanticFiltersConfig? = nil, automodToxicityConfig: AutomodToxicityConfig? = nil, awsRekognitionConfig: AIImageConfig? = nil, blockListConfig: BlockListConfig? = nil, bodyguardConfig: AITextConfig? = nil, googleVisionConfig: GoogleVisionConfig? = nil, key: String, llmConfig: LLMConfig? = nil, ruleBuilderConfig: RuleBuilderConfig? = nil, team: String? = nil, velocityFilterConfig: VelocityFilterConfig? = nil) {
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

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
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
        try container.encodeIfPresent(googleVisionConfig, forKey: .googleVisionConfig)
        try container.encode(key, forKey: .key)
        try container.encodeIfPresent(llmConfig, forKey: .llmConfig)
        try container.encodeIfPresent(ruleBuilderConfig, forKey: .ruleBuilderConfig)
        try container.encodeIfPresent(team, forKey: .team)
        try container.encodeIfPresent(velocityFilterConfig, forKey: .velocityFilterConfig)
    }
}

extension UpsertConfigRequest: Hashable {
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
