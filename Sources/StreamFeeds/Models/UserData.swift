//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct UserData: Identifiable, Equatable, Sendable, Hashable {
    public let banned: Bool
    public let blockedUserIds: [String]
    public let createdAt: Date
    public let custom: [String: RawJSON]
    public let deactivatedAt: Date?
    public let deletedAt: Date?
    public let id: String
    public let image: String?
    public let language: String
    public let lastActive: Date?
    public let name: String?
    public let online: Bool
    public let revokeTokensIssuedBefore: Date?
    public let role: String
    public let teams: [String]
    public let teamsRole: [String: String]?
    public let updatedAt: Date
    
    public var imageURL: URL? {
        guard let image else { return nil }
        return URL(string: image)
    }
}

// MARK: - Model Conversions

extension UserResponse {
    func toModel() -> UserData {
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

extension UserResponseCommonFields {
    func toModel() -> UserData {
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

extension UserResponsePrivacyFields {
    func toModel() -> UserData {
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
