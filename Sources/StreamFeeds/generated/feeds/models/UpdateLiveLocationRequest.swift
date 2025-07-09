//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class UpdateLiveLocationRequest: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdByDeviceId: String
    public var endAt: Date?
    public var latitude: Float?
    public var longitude: Float?
    public var messageId: String

    public init(createdByDeviceId: String, endAt: Date? = nil, latitude: Float? = nil, longitude: Float? = nil, messageId: String) {
        self.createdByDeviceId = createdByDeviceId
        self.endAt = endAt
        self.latitude = latitude
        self.longitude = longitude
        self.messageId = messageId
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdByDeviceId = "created_by_device_id"
        case endAt = "end_at"
        case latitude
        case longitude
        case messageId = "message_id"
    }

    public static func == (lhs: UpdateLiveLocationRequest, rhs: UpdateLiveLocationRequest) -> Bool {
        lhs.createdByDeviceId == rhs.createdByDeviceId &&
            lhs.endAt == rhs.endAt &&
            lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude &&
            lhs.messageId == rhs.messageId
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdByDeviceId)
        hasher.combine(endAt)
        hasher.combine(latitude)
        hasher.combine(longitude)
        hasher.combine(messageId)
    }
}
