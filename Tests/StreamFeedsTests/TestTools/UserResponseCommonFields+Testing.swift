//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UserResponseCommonFields {
    static func dummy(id: String = "test-user-id") -> UserResponseCommonFields {
        UserResponseCommonFields(
            avgResponseTime: 100,
            banned: false,
            blockedUserIds: [],
            createdAt: Date(),
            custom: [:],
            deactivatedAt: nil,
            deletedAt: nil,
            id: id,
            image: "https://example.com/avatar.jpg",
            language: "en",
            lastActive: Date(),
            name: "Test User",
            online: true,
            revokeTokensIssuedBefore: nil,
            role: "user",
            teams: ["team1"],
            teamsRole: ["team1": "member"],
            updatedAt: Date()
        )
    }
}
