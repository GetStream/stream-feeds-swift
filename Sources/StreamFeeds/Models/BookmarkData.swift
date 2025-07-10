//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct BookmarkData: Sendable {
    public let activity: ActivityData
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public internal(set) var folder: BookmarkFolderData?
    public let updatedAt: Date
    public let user: UserData
}

extension BookmarkData: Identifiable {
    public var id: String {
        activity.id + user.id
    }
}

// MARK: - Model Conversions

extension BookmarkResponse {
    func toModel() -> BookmarkData {
        BookmarkData(
            activity: activity.toModel(),
            createdAt: createdAt,
            custom: custom,
            folder: folder?.toModel(),
            updatedAt: updatedAt,
            user: user.toModel()
        )
    }
}

extension UserResponseCommonFields {
    func toUserResponse() -> UserResponse {
        UserResponse(
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
