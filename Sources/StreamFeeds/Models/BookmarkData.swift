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
    
    init(from response: BookmarkResponse) {
        self.activityId = response.activityId
        self.createdAt = response.createdAt
        self.custom = response.custom
        self.folder = response.folder
        self.updatedAt = response.updatedAt
        self.user = UserData(from: response.user)
    }
}

extension BookmarkData: Identifiable {
    public var id: String {
        activityId + user.id
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
