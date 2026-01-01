//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension ConfigResponse {
    static func dummy(
        createdAt: Date = .fixed(),
        key: String = "config-123",
        team: String = "Test Config",
        updatedAt: Date = .fixed()
    ) -> ConfigResponse {
        ConfigResponse(
            aiImageConfig: nil,
            aiTextConfig: nil,
            aiVideoConfig: nil,
            async: false,
            automodPlatformCircumventionConfig: nil,
            automodSemanticFiltersConfig: nil,
            automodToxicityConfig: nil,
            blockListConfig: nil,
            createdAt: createdAt,
            key: key,
            llmConfig: nil,
            team: team,
            updatedAt: updatedAt,
            velocityFilterConfig: nil
        )
    }
}
