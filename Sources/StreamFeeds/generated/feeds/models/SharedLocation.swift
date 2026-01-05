//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class SharedLocation: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var channelCid: String
    public var createdAt: Date
    public var createdByDeviceId: String
    public var endAt: Date?
    public var latitude: Float?
    public var longitude: Float?
    public var messageId: String
    public var updatedAt: Date
    public var userId: String

    public init(channelCid: String, createdAt: Date, createdByDeviceId: String, endAt: Date? = nil, latitude: Float? = nil, longitude: Float? = nil, messageId: String, updatedAt: Date, userId: String) {
        self.channelCid = channelCid
        self.createdAt = createdAt
        self.createdByDeviceId = createdByDeviceId
        self.endAt = endAt
        self.latitude = latitude
        self.longitude = longitude
        self.messageId = messageId
        self.updatedAt = updatedAt
        self.userId = userId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case channelCid = "channel_cid"
        case createdAt = "created_at"
        case createdByDeviceId = "created_by_device_id"
        case endAt = "end_at"
        case latitude
        case longitude
        case messageId = "message_id"
        case updatedAt = "updated_at"
        case userId = "user_id"
    }

    public static func == (lhs: SharedLocation, rhs: SharedLocation) -> Bool {
        lhs.channelCid == rhs.channelCid &&
            lhs.createdAt == rhs.createdAt &&
            lhs.createdByDeviceId == rhs.createdByDeviceId &&
            lhs.endAt == rhs.endAt &&
            lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude &&
            lhs.messageId == rhs.messageId &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.userId == rhs.userId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(channelCid)
        hasher.combine(createdAt)
        hasher.combine(createdByDeviceId)
        hasher.combine(endAt)
        hasher.combine(latitude)
        hasher.combine(longitude)
        hasher.combine(messageId)
        hasher.combine(updatedAt)
        hasher.combine(userId)
    }
}
