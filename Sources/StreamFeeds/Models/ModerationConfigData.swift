//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct ModerationConfigData: Identifiable, Equatable, Sendable {
    public let aiImageConfig: AIImageConfig?
    public let aiTextConfig: AITextConfig?
    public let aiVideoConfig: AIVideoConfig?
    public let async: Bool
    public let automodPlatformCircumventionConfig: AutomodPlatformCircumventionConfig?
    public let automodSemanticFiltersConfig: AutomodSemanticFiltersConfig?
    public let automodToxicityConfig: AutomodToxicityConfig?
    public let blockListConfig: BlockListConfig?
    public let createdAt: Date
    public let key: String
    public let team: String
    public let updatedAt: Date
    public let velocityFilterConfig: VelocityFilterConfig?
    
    public var id: String { key }
}

// MARK: - Model Conversions

extension ConfigResponse {
    func toModel() -> ModerationConfigData {
        ModerationConfigData(
            aiImageConfig: aiImageConfig,
            aiTextConfig: aiTextConfig,
            aiVideoConfig: aiVideoConfig,
            async: async,
            automodPlatformCircumventionConfig: automodPlatformCircumventionConfig,
            automodSemanticFiltersConfig: automodSemanticFiltersConfig,
            automodToxicityConfig: automodToxicityConfig,
            blockListConfig: blockListConfig,
            createdAt: createdAt,
            key: key,
            team: team,
            updatedAt: updatedAt,
            velocityFilterConfig: velocityFilterConfig
        )
    }
}
