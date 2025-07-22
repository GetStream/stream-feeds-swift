//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UserResponse {
    static func dummy(id: String = "test-user-id") -> UserResponse {
        UserResponse(
            banned: false,
            blockedUserIds: [],
            createdAt: Date(timeIntervalSince1970: 1_640_995_200),
            custom: [:],
            deactivatedAt: nil,
            deletedAt: nil,
            id: id,
            image: "https://example.com/avatar.jpg",
            language: "en",
            lastActive: Date(timeIntervalSince1970: 1_640_995_200),
            name: "Test User",
            online: true,
            revokeTokensIssuedBefore: nil,
            role: "user",
            teams: ["team1"],
            teamsRole: nil,
            updatedAt: Date(timeIntervalSince1970: 1_640_995_200)
        )
    }
}
