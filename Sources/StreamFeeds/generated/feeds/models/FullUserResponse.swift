//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FullUserResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
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
    public var latestHiddenChannels: [String]?
    public var mutes: [UserMuteResponse]
    public var name: String?
    public var online: Bool
    public var privacySettings: PrivacySettingsResponse?
    public var revokeTokensIssuedBefore: Date?
    public var role: String
    public var shadowBanned: Bool
    public var teams: [String]
    public var teamsRole: [String: String]?
    public var totalUnreadCount: Int
    public var unreadChannels: Int
    public var unreadCount: Int
    public var unreadThreads: Int
    public var updatedAt: Date

    public init(banExpires: Date? = nil, banned: Bool, blockedUserIds: [String], createdAt: Date, custom: [String: RawJSON], deactivatedAt: Date? = nil, deletedAt: Date? = nil, devices: [DeviceResponse], id: String, image: String? = nil, invisible: Bool, language: String, lastActive: Date? = nil, latestHiddenChannels: [String]? = nil, mutes: [UserMuteResponse], name: String? = nil, online: Bool, privacySettings: PrivacySettingsResponse? = nil, revokeTokensIssuedBefore: Date? = nil, role: String, shadowBanned: Bool, teams: [String], teamsRole: [String: String]? = nil, totalUnreadCount: Int, unreadChannels: Int, unreadCount: Int, unreadThreads: Int, updatedAt: Date) {
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
        self.latestHiddenChannels = latestHiddenChannels
        self.mutes = mutes
        self.name = name
        self.online = online
        self.privacySettings = privacySettings
        self.revokeTokensIssuedBefore = revokeTokensIssuedBefore
        self.role = role
        self.shadowBanned = shadowBanned
        self.teams = teams
        self.teamsRole = teamsRole
        self.totalUnreadCount = totalUnreadCount
        self.unreadChannels = unreadChannels
        self.unreadCount = unreadCount
        self.unreadThreads = unreadThreads
        self.updatedAt = updatedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
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
        case latestHiddenChannels = "latest_hidden_channels"
        case mutes
        case name
        case online
        case privacySettings = "privacy_settings"
        case revokeTokensIssuedBefore = "revoke_tokens_issued_before"
        case role
        case shadowBanned = "shadow_banned"
        case teams
        case teamsRole = "teams_role"
        case totalUnreadCount = "total_unread_count"
        case unreadChannels = "unread_channels"
        case unreadCount = "unread_count"
        case unreadThreads = "unread_threads"
        case updatedAt = "updated_at"
    }

    public static func == (lhs: FullUserResponse, rhs: FullUserResponse) -> Bool {
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
            lhs.latestHiddenChannels == rhs.latestHiddenChannels &&
            lhs.mutes == rhs.mutes &&
            lhs.name == rhs.name &&
            lhs.online == rhs.online &&
            lhs.privacySettings == rhs.privacySettings &&
            lhs.revokeTokensIssuedBefore == rhs.revokeTokensIssuedBefore &&
            lhs.role == rhs.role &&
            lhs.shadowBanned == rhs.shadowBanned &&
            lhs.teams == rhs.teams &&
            lhs.teamsRole == rhs.teamsRole &&
            lhs.totalUnreadCount == rhs.totalUnreadCount &&
            lhs.unreadChannels == rhs.unreadChannels &&
            lhs.unreadCount == rhs.unreadCount &&
            lhs.unreadThreads == rhs.unreadThreads &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
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
        hasher.combine(latestHiddenChannels)
        hasher.combine(mutes)
        hasher.combine(name)
        hasher.combine(online)
        hasher.combine(privacySettings)
        hasher.combine(revokeTokensIssuedBefore)
        hasher.combine(role)
        hasher.combine(shadowBanned)
        hasher.combine(teams)
        hasher.combine(teamsRole)
        hasher.combine(totalUnreadCount)
        hasher.combine(unreadChannels)
        hasher.combine(unreadCount)
        hasher.combine(unreadThreads)
        hasher.combine(updatedAt)
    }
}
