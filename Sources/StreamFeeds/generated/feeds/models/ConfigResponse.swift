//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ConfigResponse: Sendable, Codable, JSONEncodable {
    public let aiAudioConfig: AIAudioConfigResponse?
    public let aiImageConfig: AIImageConfig?
    /// Configurable image moderation label definitions for dashboard rendering
    public let aiImageLabelDefinitions: [AIImageLabelDefinition]?
    /// Available L2 subclassifications per L1 image moderation label, based on the active provider
    public let aiImageSubclassifications: [String: [String]]?
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
    public let floodConfig: FloodConfig?
    public let intentConfig: IntentConfigResponse?
    /// Unique identifier for the moderation configuration
    public let key: String
    public let llmConfig: LLMConfig?
    /// Team associated with the configuration
    public let team: String
    /// When the configuration was last updated
    public let updatedAt: Date
    public let velocityFilterConfig: VelocityFilterConfig?

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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.aiAudioConfig = try container.decodeIfPresent(AIAudioConfigResponse.self, forKey: .aiAudioConfig)
        self.aiImageConfig = try container.decodeIfPresent(AIImageConfig.self, forKey: .aiImageConfig)
        self.aiImageLabelDefinitions = try container.decodeIfPresent([AIImageLabelDefinition].self, forKey: .aiImageLabelDefinitions)
        self.aiImageSubclassifications = try container.decodeIfPresent([String: [String]].self, forKey: .aiImageSubclassifications)
        self.aiTextConfig = try container.decodeIfPresent(AITextConfig.self, forKey: .aiTextConfig)
        self.aiVideoConfig = try container.decodeIfPresent(AIVideoConfigResponse.self, forKey: .aiVideoConfig)
        self.async = try container.decode(Bool.self, forKey: .async)
        self.automodPlatformCircumventionConfig = try container.decodeIfPresent(AutomodPlatformCircumventionConfig.self, forKey: .automodPlatformCircumventionConfig)
        self.automodSemanticFiltersConfig = try container.decodeIfPresent(AutomodSemanticFiltersConfig.self, forKey: .automodSemanticFiltersConfig)
        self.automodToxicityConfig = try container.decodeIfPresent(AutomodToxicityConfig.self, forKey: .automodToxicityConfig)
        self.blockListConfig = try container.decodeIfPresent(BlockListConfig.self, forKey: .blockListConfig)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.floodConfig = try container.decodeIfPresent(FloodConfig.self, forKey: .floodConfig)
        self.intentConfig = try container.decodeIfPresent(IntentConfigResponse.self, forKey: .intentConfig)
        self.key = try container.decode(String.self, forKey: .key)
        self.llmConfig = try container.decodeIfPresent(LLMConfig.self, forKey: .llmConfig)
        self.team = try container.decode(String.self, forKey: .team)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.velocityFilterConfig = try container.decodeIfPresent(VelocityFilterConfig.self, forKey: .velocityFilterConfig)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(aiAudioConfig, forKey: .aiAudioConfig)
        try container.encodeIfPresent(aiImageConfig, forKey: .aiImageConfig)
        try container.encodeIfPresent(aiImageLabelDefinitions, forKey: .aiImageLabelDefinitions)
        try container.encodeIfPresent(aiImageSubclassifications, forKey: .aiImageSubclassifications)
        try container.encodeIfPresent(aiTextConfig, forKey: .aiTextConfig)
        try container.encodeIfPresent(aiVideoConfig, forKey: .aiVideoConfig)
        try container.encode(async, forKey: .async)
        try container.encodeIfPresent(automodPlatformCircumventionConfig, forKey: .automodPlatformCircumventionConfig)
        try container.encodeIfPresent(automodSemanticFiltersConfig, forKey: .automodSemanticFiltersConfig)
        try container.encodeIfPresent(automodToxicityConfig, forKey: .automodToxicityConfig)
        try container.encodeIfPresent(blockListConfig, forKey: .blockListConfig)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(floodConfig, forKey: .floodConfig)
        try container.encodeIfPresent(intentConfig, forKey: .intentConfig)
        try container.encode(key, forKey: .key)
        try container.encodeIfPresent(llmConfig, forKey: .llmConfig)
        try container.encode(team, forKey: .team)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(velocityFilterConfig, forKey: .velocityFilterConfig)
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
