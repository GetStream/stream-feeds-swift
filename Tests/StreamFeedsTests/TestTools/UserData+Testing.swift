//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds

extension UserData {
    static func dummy(
        id: String = "user-1",
        name: String? = "Test User",
        image: String? = nil,
        createdAt: Date = .fixed(),
        updatedAt: Date = .fixed(),
        banned: Bool = false,
        blockedUserIds: [String] = [],
        custom: [String: RawJSON] = [:],
        deactivatedAt: Date? = nil,
        deletedAt: Date? = nil,
        language: String = "en",
        lastActive: Date? = nil,
        online: Bool = false,
        revokeTokensIssuedBefore: Date? = nil,
        role: String = "user",
        teams: [String] = [],
        teamsRole: [String: String]? = nil
    ) -> UserData {
        UserData(
            banned: banned,
            blockedUserIds: blockedUserIds,
            createdAt: createdAt,
            custom: custom,
            deactivatedAt: deactivatedAt,
            deletedAt: deletedAt,
            id: id,
            image: image,
            language: language,
            lastActive: lastActive,
            name: name,
            online: online,
            revokeTokensIssuedBefore: revokeTokensIssuedBefore,
            role: role,
            teams: teams,
            teamsRole: teamsRole,
            updatedAt: updatedAt
        )
    }
}
