//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class EntityCreator: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var avgResponseTime: Int?
    public var banCount: Int
    public var banExpires: Date?
    public var banned: Bool
    public var createdAt: Date?
    public var custom: [String: RawJSON]
    public var deactivatedAt: Date?
    public var deletedAt: Date?
    public var deletedContentCount: Int
    public var id: String
    public var invisible: Bool?
    public var language: String?
    public var lastActive: Date?
    public var lastEngagedAt: Date?
    public var online: Bool
    public var privacySettings: PrivacySettings?
    public var revokeTokensIssuedBefore: Date?
    public var role: String
    public var teams: [String]?
    public var teamsRole: [String: String]
    public var updatedAt: Date?

    public init(avgResponseTime: Int? = nil, banCount: Int, banExpires: Date? = nil, banned: Bool, createdAt: Date? = nil, custom: [String: RawJSON], deactivatedAt: Date? = nil, deletedAt: Date? = nil, deletedContentCount: Int, id: String, invisible: Bool? = nil, language: String? = nil, lastActive: Date? = nil, lastEngagedAt: Date? = nil, online: Bool, privacySettings: PrivacySettings? = nil, revokeTokensIssuedBefore: Date? = nil, role: String, teams: [String]? = nil, teamsRole: [String: String], updatedAt: Date? = nil) {
        self.avgResponseTime = avgResponseTime
        self.banCount = banCount
        self.banExpires = banExpires
        self.banned = banned
        self.createdAt = createdAt
        self.custom = custom
        self.deactivatedAt = deactivatedAt
        self.deletedAt = deletedAt
        self.deletedContentCount = deletedContentCount
        self.id = id
        self.invisible = invisible
        self.language = language
        self.lastActive = lastActive
        self.lastEngagedAt = lastEngagedAt
        self.online = online
        self.privacySettings = privacySettings
        self.revokeTokensIssuedBefore = revokeTokensIssuedBefore
        self.role = role
        self.teams = teams
        self.teamsRole = teamsRole
        self.updatedAt = updatedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case avgResponseTime = "avg_response_time"
        case banCount = "ban_count"
        case banExpires = "ban_expires"
        case banned
        case createdAt = "created_at"
        case custom
        case deactivatedAt = "deactivated_at"
        case deletedAt = "deleted_at"
        case deletedContentCount = "deleted_content_count"
        case id
        case invisible
        case language
        case lastActive = "last_active"
        case lastEngagedAt = "last_engaged_at"
        case online
        case privacySettings = "privacy_settings"
        case revokeTokensIssuedBefore = "revoke_tokens_issued_before"
        case role
        case teams
        case teamsRole = "teams_role"
        case updatedAt = "updated_at"
    }

    public static func == (lhs: EntityCreator, rhs: EntityCreator) -> Bool {
        lhs.avgResponseTime == rhs.avgResponseTime &&
            lhs.banCount == rhs.banCount &&
            lhs.banExpires == rhs.banExpires &&
            lhs.banned == rhs.banned &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.deactivatedAt == rhs.deactivatedAt &&
            lhs.deletedAt == rhs.deletedAt &&
            lhs.deletedContentCount == rhs.deletedContentCount &&
            lhs.id == rhs.id &&
            lhs.invisible == rhs.invisible &&
            lhs.language == rhs.language &&
            lhs.lastActive == rhs.lastActive &&
            lhs.lastEngagedAt == rhs.lastEngagedAt &&
            lhs.online == rhs.online &&
            lhs.privacySettings == rhs.privacySettings &&
            lhs.revokeTokensIssuedBefore == rhs.revokeTokensIssuedBefore &&
            lhs.role == rhs.role &&
            lhs.teams == rhs.teams &&
            lhs.teamsRole == rhs.teamsRole &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(avgResponseTime)
        hasher.combine(banCount)
        hasher.combine(banExpires)
        hasher.combine(banned)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(deactivatedAt)
        hasher.combine(deletedAt)
        hasher.combine(deletedContentCount)
        hasher.combine(id)
        hasher.combine(invisible)
        hasher.combine(language)
        hasher.combine(lastActive)
        hasher.combine(lastEngagedAt)
        hasher.combine(online)
        hasher.combine(privacySettings)
        hasher.combine(revokeTokensIssuedBefore)
        hasher.combine(role)
        hasher.combine(teams)
        hasher.combine(teamsRole)
        hasher.combine(updatedAt)
    }
}
