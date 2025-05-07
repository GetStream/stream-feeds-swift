//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ConnectedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    
    public var connectionId: String
    public var createdAt: Date
    public var me: OwnUserResponse
    public var type: String = "connection.ok"

    public init(connectionId: String, createdAt: Date, me: OwnUserResponse) {
        self.connectionId = connectionId
        self.createdAt = createdAt
        self.me = me
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case connectionId = "connection_id"
        case createdAt = "created_at"
        case me
        case type
    }
    
    public static func == (lhs: ConnectedEvent, rhs: ConnectedEvent) -> Bool {
        lhs.connectionId == rhs.connectionId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.me == rhs.me &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(connectionId)
        hasher.combine(createdAt)
        hasher.combine(me)
        hasher.combine(type)
    }
    
    public func healthcheck() -> HealthCheckInfo? {
        HealthCheckInfo(connectionId: connectionId)
    }
}

public final class OwnUserResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    
    public var blockedUserIds: [String]?
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var deactivatedAt: Date?
    public var deletedAt: Date?
    public var devices: [Device]
    public var id: String
    public var image: String?
    public var language: String
    public var lastActive: Date?
    public var name: String?
    public var pushNotifications: PushNotificationSettingsResponse?
    public var revokeTokensIssuedBefore: Date?
    public var role: String
    public var teams: [String]
    public var updatedAt: Date

    public init(
        blockedUserIds: [String]? = nil,
        createdAt: Date,
        custom: [String: RawJSON],
        deactivatedAt: Date? = nil,
        deletedAt: Date? = nil,
        devices: [Device],
        id: String,
        image: String? = nil,
        language: String,
        lastActive: Date? = nil,
        name: String? = nil,
        pushNotifications: PushNotificationSettingsResponse? = nil,
        revokeTokensIssuedBefore: Date? = nil,
        role: String,
        teams: [String],
        updatedAt: Date
    ) {
        self.blockedUserIds = blockedUserIds
        self.createdAt = createdAt
        self.custom = custom
        self.deactivatedAt = deactivatedAt
        self.deletedAt = deletedAt
        self.devices = devices
        self.id = id
        self.image = image
        self.language = language
        self.lastActive = lastActive
        self.name = name
        self.pushNotifications = pushNotifications
        self.revokeTokensIssuedBefore = revokeTokensIssuedBefore
        self.role = role
        self.teams = teams
        self.updatedAt = updatedAt
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case blockedUserIds = "blocked_user_ids"
        case createdAt = "created_at"
        case custom
        case deactivatedAt = "deactivated_at"
        case deletedAt = "deleted_at"
        case devices
        case id
        case image
        case language
        case lastActive = "last_active"
        case name
        case pushNotifications = "push_notifications"
        case revokeTokensIssuedBefore = "revoke_tokens_issued_before"
        case role
        case teams
        case updatedAt = "updated_at"
    }
    
    public static func == (lhs: OwnUserResponse, rhs: OwnUserResponse) -> Bool {
        lhs.blockedUserIds == rhs.blockedUserIds &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.deactivatedAt == rhs.deactivatedAt &&
            lhs.deletedAt == rhs.deletedAt &&
            lhs.devices == rhs.devices &&
            lhs.id == rhs.id &&
            lhs.image == rhs.image &&
            lhs.language == rhs.language &&
            lhs.lastActive == rhs.lastActive &&
            lhs.name == rhs.name &&
            lhs.pushNotifications == rhs.pushNotifications &&
            lhs.revokeTokensIssuedBefore == rhs.revokeTokensIssuedBefore &&
            lhs.role == rhs.role &&
            lhs.teams == rhs.teams &&
            lhs.updatedAt == rhs.updatedAt
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(blockedUserIds)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(deactivatedAt)
        hasher.combine(deletedAt)
        hasher.combine(devices)
        hasher.combine(id)
        hasher.combine(image)
        hasher.combine(language)
        hasher.combine(lastActive)
        hasher.combine(name)
        hasher.combine(pushNotifications)
        hasher.combine(revokeTokensIssuedBefore)
        hasher.combine(role)
        hasher.combine(teams)
        hasher.combine(updatedAt)
    }
}

public final class PushNotificationSettingsResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    
    public var disabled: Bool?
    public var disabledUntil: Date?

    public init(disabled: Bool? = nil, disabledUntil: Date? = nil) {
        self.disabled = disabled
        self.disabledUntil = disabledUntil
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case disabled
        case disabledUntil = "disabled_until"
    }
    
    public static func == (lhs: PushNotificationSettingsResponse, rhs: PushNotificationSettingsResponse) -> Bool {
        lhs.disabled == rhs.disabled &&
            lhs.disabledUntil == rhs.disabledUntil
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(disabled)
        hasher.combine(disabledUntil)
    }
}

public final class HealthCheckEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable, HealthCheck {
    
    public var cid: String?
    public var connectionId: String
    public var createdAt: Date
    public var receivedAt: Date?
    public var type: String = "health.check"

    public init(cid: String? = nil, connectionId: String, createdAt: Date, receivedAt: Date? = nil) {
        self.cid = cid
        self.connectionId = connectionId
        self.createdAt = createdAt
        self.receivedAt = receivedAt
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case cid
        case connectionId = "connection_id"
        case createdAt = "created_at"
        case receivedAt = "received_at"
        case type
    }
    
    public static func == (lhs: HealthCheckEvent, rhs: HealthCheckEvent) -> Bool {
        lhs.cid == rhs.cid &&
            lhs.connectionId == rhs.connectionId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(cid)
        hasher.combine(connectionId)
        hasher.combine(createdAt)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
    
    public func healthcheck() -> HealthCheckInfo? {
        HealthCheckInfo(connectionId: connectionId)
    }
}

public final class ConnectionErrorEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    
    public var connectionId: String
    public var createdAt: Date
    public var error: APIError
    public var type: String = "connection.error"

    public init(connectionId: String, createdAt: Date, error: APIError) {
        self.connectionId = connectionId
        self.createdAt = createdAt
        self.error = error
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case connectionId = "connection_id"
        case createdAt = "created_at"
        case error
        case type
    }
    
    public static func == (lhs: ConnectionErrorEvent, rhs: ConnectionErrorEvent) -> Bool {
        lhs.connectionId == rhs.connectionId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.error == rhs.error &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(connectionId)
        hasher.combine(createdAt)
        hasher.combine(error)
        hasher.combine(type)
    }
}
