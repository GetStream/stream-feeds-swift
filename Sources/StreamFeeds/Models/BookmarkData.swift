//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct BookmarkData: Equatable, Sendable {
    public private(set) var activity: ActivityData
    public let createdAt: Date
    public let custom: [String: RawJSON]?
    public internal(set) var folder: BookmarkFolderData?
    public let updatedAt: Date
    public let user: UserData
}

extension BookmarkData: Identifiable {
    public var id: String {
        "\(user.id)-\(activity.id)"
    }
}

// MARK: - Mutating the Data

extension BookmarkData {
    mutating func merge(with incomingData: ActivityData) {
        activity.merge(with: incomingData)
    }
    
    // MARK: - Current Feed Capabilities
    
    mutating func mergeFeedOwnCapabilities(from capabilitiesMap: [FeedId: Set<FeedOwnCapability>]) {
        activity.mergeFeedOwnCapabilities(from: capabilitiesMap)
    }
    
    func withFeedOwnCapabilities(from capabilitiesMap: [FeedId: Set<FeedOwnCapability>]) -> BookmarkData {
        var updated = self
        updated.mergeFeedOwnCapabilities(from: capabilitiesMap)
        return updated
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
