//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class EntityCreatorResponse: Sendable, Codable, JSONEncodable {
    public let avgResponseTime: Int?
    /// Number of minor actions performed on the user
    public let banCount: Int
    public let banned: Bool
    public let blockedUserIds: [String]
    public let createdAt: Date
    public let custom: [String: RawJSON]
    public let deactivatedAt: Date?
    public let deletedAt: Date?
    /// Number of major actions performed on the user
    public let deletedContentCount: Int
    /// Number of flag actions performed on the user
    public let flaggedCount: Int
    public let id: String
    public let image: String?
    public let language: String
    public let lastActive: Date?
    public let name: String?
    public let online: Bool
    public let role: String
    public let teams: [String]
    public let teamsRole: [String: String]?
    public let updatedAt: Date

    public init(avgResponseTime: Int? = nil, banCount: Int, banned: Bool, blockedUserIds: [String], createdAt: Date, custom: [String: RawJSON], deactivatedAt: Date? = nil, deletedAt: Date? = nil, deletedContentCount: Int, flaggedCount: Int, id: String, image: String? = nil, language: String, lastActive: Date? = nil, name: String? = nil, online: Bool, role: String, teams: [String], teamsRole: [String: String]? = nil, updatedAt: Date) {
        self.avgResponseTime = avgResponseTime
        self.banCount = banCount
        self.banned = banned
        self.blockedUserIds = blockedUserIds
        self.createdAt = createdAt
        self.custom = custom
        self.deactivatedAt = deactivatedAt
        self.deletedAt = deletedAt
        self.deletedContentCount = deletedContentCount
        self.flaggedCount = flaggedCount
        self.id = id
        self.image = image
        self.language = language
        self.lastActive = lastActive
        self.name = name
        self.online = online
        self.role = role
        self.teams = teams
        self.teamsRole = teamsRole
        self.updatedAt = updatedAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.avgResponseTime = try container.decodeIfPresent(Int.self, forKey: .avgResponseTime)
        self.banCount = try container.decode(Int.self, forKey: .banCount)
        self.banned = try container.decode(Bool.self, forKey: .banned)
        self.blockedUserIds = try container.decode([String].self, forKey: .blockedUserIds)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.deactivatedAt = try container.decodeIfPresent(Date.self, forKey: .deactivatedAt)
        self.deletedAt = try container.decodeIfPresent(Date.self, forKey: .deletedAt)
        self.deletedContentCount = try container.decode(Int.self, forKey: .deletedContentCount)
        self.flaggedCount = try container.decode(Int.self, forKey: .flaggedCount)
        self.id = try container.decode(String.self, forKey: .id)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.language = try container.decode(String.self, forKey: .language)
        self.lastActive = try container.decodeIfPresent(Date.self, forKey: .lastActive)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.online = try container.decode(Bool.self, forKey: .online)
        self.role = try container.decode(String.self, forKey: .role)
        self.teams = try container.decode([String].self, forKey: .teams)
        self.teamsRole = try container.decodeIfPresent([String: String].self, forKey: .teamsRole)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(avgResponseTime, forKey: .avgResponseTime)
        try container.encode(banCount, forKey: .banCount)
        try container.encode(banned, forKey: .banned)
        try container.encode(blockedUserIds, forKey: .blockedUserIds)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(custom, forKey: .custom)
        try container.encodeIfPresent(deactivatedAt, forKey: .deactivatedAt)
        try container.encodeIfPresent(deletedAt, forKey: .deletedAt)
        try container.encode(deletedContentCount, forKey: .deletedContentCount)
        try container.encode(flaggedCount, forKey: .flaggedCount)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encode(language, forKey: .language)
        try container.encodeIfPresent(lastActive, forKey: .lastActive)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(online, forKey: .online)
        try container.encode(role, forKey: .role)
        try container.encode(teams, forKey: .teams)
        try container.encodeIfPresent(teamsRole, forKey: .teamsRole)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}

extension EntityCreatorResponse: Hashable {
    public static func == (lhs: EntityCreatorResponse, rhs: EntityCreatorResponse) -> Bool {
        lhs.avgResponseTime == rhs.avgResponseTime &&
            lhs.banCount == rhs.banCount &&
            lhs.banned == rhs.banned &&
            lhs.blockedUserIds == rhs.blockedUserIds &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.deactivatedAt == rhs.deactivatedAt &&
            lhs.deletedAt == rhs.deletedAt &&
            lhs.deletedContentCount == rhs.deletedContentCount &&
            lhs.flaggedCount == rhs.flaggedCount &&
            lhs.id == rhs.id &&
            lhs.image == rhs.image &&
            lhs.language == rhs.language &&
            lhs.lastActive == rhs.lastActive &&
            lhs.name == rhs.name &&
            lhs.online == rhs.online &&
            lhs.role == rhs.role &&
            lhs.teams == rhs.teams &&
            lhs.teamsRole == rhs.teamsRole &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(avgResponseTime)
        hasher.combine(banCount)
        hasher.combine(banned)
        hasher.combine(blockedUserIds)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(deactivatedAt)
        hasher.combine(deletedAt)
        hasher.combine(deletedContentCount)
        hasher.combine(flaggedCount)
        hasher.combine(id)
        hasher.combine(image)
        hasher.combine(language)
        hasher.combine(lastActive)
        hasher.combine(name)
        hasher.combine(online)
        hasher.combine(role)
        hasher.combine(teams)
        hasher.combine(teamsRole)
        hasher.combine(updatedAt)
    }
}
