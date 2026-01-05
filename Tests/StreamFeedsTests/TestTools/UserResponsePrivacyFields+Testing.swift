//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UserResponsePrivacyFields {
    static func dummy(
        id: String = "test-user-id",
        name: String? = "Test User"
    ) -> UserResponsePrivacyFields {
        UserResponsePrivacyFields(
            avgResponseTime: 100,
            banned: false,
            blockedUserIds: [],
            createdAt: Date(),
            custom: [:],
            deactivatedAt: nil,
            deletedAt: nil,
            id: id,
            image: "https://example.com/avatar.jpg",
            invisible: false,
            language: "en",
            lastActive: Date(),
            name: name,
            online: true,
            privacySettings: nil,
            revokeTokensIssuedBefore: nil,
            role: "user",
            teams: ["team1"],
            teamsRole: ["team1": "member"],
            updatedAt: Date()
        )
    }
}
