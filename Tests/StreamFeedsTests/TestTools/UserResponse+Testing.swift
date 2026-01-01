//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UserResponse {
    static func dummy(
        id: String = "test-user-id",
        name: String = "Test User"
    ) -> UserResponse {
        UserResponse(
            banned: false,
            blockedUserIds: [],
            createdAt: .fixed(),
            custom: [:],
            deactivatedAt: nil,
            deletedAt: nil,
            id: id,
            image: "https://example.com/avatar.jpg",
            language: "en",
            lastActive: .fixed(),
            name: name,
            online: true,
            revokeTokensIssuedBefore: nil,
            role: "user",
            teams: ["team1"],
            teamsRole: nil,
            updatedAt: .fixed()
        )
    }
}
