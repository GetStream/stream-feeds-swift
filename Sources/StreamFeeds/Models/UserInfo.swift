//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct UserInfo: Identifiable, Sendable {
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
    
    init(from response: UserResponse) {
        self.banned = response.banned
        self.blockedUserIds = response.blockedUserIds
        self.createdAt = response.createdAt
        self.custom = response.custom
        self.deactivatedAt = response.deactivatedAt
        self.deletedAt = response.deletedAt
        self.id = response.id
        self.image = response.image
        self.language = response.language
        self.lastActive = response.lastActive
        self.name = response.name
        self.online = response.online
        self.revokeTokensIssuedBefore = response.revokeTokensIssuedBefore
        self.role = response.role
        self.teams = response.teams
        self.teamsRole = response.teamsRole
        self.updatedAt = response.updatedAt
    }
} 
