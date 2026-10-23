//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FullUserResponse: @unchecked Sendable, Codable, JSONEncodable {
    public var avgResponseTime: Int?
    public var banExpires: Date?
    public var banned: Bool
    public var blockedUserIds: [String]
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var deactivatedAt: Date?
    public var deletedAt: Date?
    public var devices: [DeviceResponse]
    public var id: String
    public var image: String?
    public var invisible: Bool
    public var language: String
    public var lastActive: Date?
    public var mutes: [UserMuteResponse]
    public var name: String?
    public var online: Bool
    /// The privacy settings of the user.
    public var privacySettings: PrivacySettingsResponse?
    public var role: String
    public var teams: [String]
    public var teamsRole: [String: String]?
    public var updatedAt: Date

    public init(
        avgResponseTime: Int? = nil,
        banExpires: Date? = nil,
        banned: Bool,
        blockedUserIds: [String],
        createdAt: Date,
        custom: [String: RawJSON],
        deactivatedAt: Date? = nil,
        deletedAt: Date? = nil,
        devices: [DeviceResponse],
        id: String,
        image: String? = nil,
        invisible: Bool,
        language: String,
        lastActive: Date? = nil,
        mutes: [UserMuteResponse],
        name: String? = nil,
        online: Bool,
        privacySettings: PrivacySettingsResponse? = nil,
        role: String,
        teams: [String],
        teamsRole: [String: String]? = nil,
        updatedAt: Date
    ) {
        self.avgResponseTime = avgResponseTime
        self.banExpires = banExpires
        self.banned = banned
        self.blockedUserIds = blockedUserIds
        self.createdAt = createdAt
        self.custom = custom
        self.deactivatedAt = deactivatedAt
        self.deletedAt = deletedAt
        self.devices = devices
        self.id = id
        self.image = image
        self.invisible = invisible
        self.language = language
        self.lastActive = lastActive
        self.mutes = mutes
        self.name = name
        self.online = online
        self.privacySettings = privacySettings
        self.role = role
        self.teams = teams
        self.teamsRole = teamsRole
        self.updatedAt = updatedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case avgResponseTime = "avg_response_time"
        case banExpires = "ban_expires"
        case banned
        case blockedUserIds = "blocked_user_ids"
        case createdAt = "created_at"
        case custom
        case deactivatedAt = "deactivated_at"
        case deletedAt = "deleted_at"
        case devices
        case id
        case image
        case invisible
        case language
        case lastActive = "last_active"
        case mutes
        case name
        case online
        case privacySettings = "privacy_settings"
        case role
        case teams
        case teamsRole = "teams_role"
        case updatedAt = "updated_at"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.avgResponseTime = try container.decodeIfPresent(Int.self, forKey: .avgResponseTime)
        self.banExpires = try container.decodeIfPresent(Date.self, forKey: .banExpires)
        self.banned = try container.decode(Bool.self, forKey: .banned)
        self.blockedUserIds = try container.decode([String].self, forKey: .blockedUserIds)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.deactivatedAt = try container.decodeIfPresent(Date.self, forKey: .deactivatedAt)
        self.deletedAt = try container.decodeIfPresent(Date.self, forKey: .deletedAt)
        self.devices = try container.decode([DeviceResponse].self, forKey: .devices)
        self.id = try container.decode(String.self, forKey: .id)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.invisible = try container.decode(Bool.self, forKey: .invisible)
        self.language = try container.decode(String.self, forKey: .language)
        self.lastActive = try container.decodeIfPresent(Date.self, forKey: .lastActive)
        self.mutes = try container.decode([UserMuteResponse].self, forKey: .mutes)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.online = try container.decode(Bool.self, forKey: .online)
        self.privacySettings = try container.decodeIfPresent(
            PrivacySettingsResponse.self,
            forKey: .privacySettings
        )
        self.role = try container.decode(String.self, forKey: .role)
        self.teams = try container.decode([String].self, forKey: .teams)
        self.teamsRole = try container.decodeIfPresent([String: String].self, forKey: .teamsRole)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(avgResponseTime, forKey: .avgResponseTime)
        try container.encodeIfPresent(banExpires, forKey: .banExpires)
        try container.encode(banned, forKey: .banned)
        try container.encode(blockedUserIds, forKey: .blockedUserIds)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(custom, forKey: .custom)
        try container.encodeIfPresent(deactivatedAt, forKey: .deactivatedAt)
        try container.encodeIfPresent(deletedAt, forKey: .deletedAt)
        try container.encode(devices, forKey: .devices)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encode(invisible, forKey: .invisible)
        try container.encode(language, forKey: .language)
        try container.encodeIfPresent(lastActive, forKey: .lastActive)
        try container.encode(mutes, forKey: .mutes)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(online, forKey: .online)
        try container.encodeIfPresent(privacySettings, forKey: .privacySettings)
        try container.encode(role, forKey: .role)
        try container.encode(teams, forKey: .teams)
        try container.encodeIfPresent(teamsRole, forKey: .teamsRole)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}

extension FullUserResponse: Hashable {
    public static func == (lhs: FullUserResponse, rhs: FullUserResponse) -> Bool {
        lhs.avgResponseTime == rhs.avgResponseTime &&
            lhs.banExpires == rhs.banExpires &&
            lhs.banned == rhs.banned &&
            lhs.blockedUserIds == rhs.blockedUserIds &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.deactivatedAt == rhs.deactivatedAt &&
            lhs.deletedAt == rhs.deletedAt &&
            lhs.devices == rhs.devices &&
            lhs.id == rhs.id &&
            lhs.image == rhs.image &&
            lhs.invisible == rhs.invisible &&
            lhs.language == rhs.language &&
            lhs.lastActive == rhs.lastActive &&
            lhs.mutes == rhs.mutes &&
            lhs.name == rhs.name &&
            lhs.online == rhs.online &&
            lhs.privacySettings == rhs.privacySettings &&
            lhs.role == rhs.role &&
            lhs.teams == rhs.teams &&
            lhs.teamsRole == rhs.teamsRole &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(avgResponseTime)
        hasher.combine(banExpires)
        hasher.combine(banned)
        hasher.combine(blockedUserIds)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(deactivatedAt)
        hasher.combine(deletedAt)
        hasher.combine(devices)
        hasher.combine(id)
        hasher.combine(image)
        hasher.combine(invisible)
        hasher.combine(language)
        hasher.combine(lastActive)
        hasher.combine(mutes)
        hasher.combine(name)
        hasher.combine(online)
        hasher.combine(privacySettings)
        hasher.combine(role)
        hasher.combine(teams)
        hasher.combine(teamsRole)
        hasher.combine(updatedAt)
    }
}
