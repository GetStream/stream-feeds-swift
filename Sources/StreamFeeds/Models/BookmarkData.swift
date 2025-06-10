//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct BookmarkData: Sendable {
    public let activityId: String
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public let folder: BookmarkFolderResponse
    public let updatedAt: Date
    public let user: UserData
}

extension BookmarkData: Identifiable {
    public var id: String {
        activityId + user.id
    }
}

// MARK: - Model Conversions

extension BookmarkResponse {
    func toModel() -> BookmarkData {
        BookmarkData(
            activityId: activityId,
            createdAt: createdAt,
            custom: custom,
            folder: folder,
            updatedAt: updatedAt,
            user: user.toModel()
        )
    }
}

// TODO: Event is missing the response

extension BookmarkAddedEvent {
    var bookmark: BookmarkResponse? {
        guard let user = user?.toUserResponse() else { return nil }
        return BookmarkResponse(
            activityId: activityId,
            createdAt: createdAt,
            custom: custom,
            folder: BookmarkFolderResponse(
                createdAt: Date(),
                id: "bookmarks",
                name: "Bookmarks",
                updatedAt: Date()
            ),
            updatedAt: createdAt,
            user: user
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
