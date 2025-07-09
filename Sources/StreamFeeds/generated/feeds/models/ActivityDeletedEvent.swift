//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityDeletedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var activity: ActivityResponse
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var fid: String
    public var receivedAt: Date?
    public var type: String = "feeds.activity.deleted"
    public var user: UserResponseCommonFields?

    public init(activity: ActivityResponse, createdAt: Date, custom: [String: RawJSON], fid: String, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.activity = activity
        self.createdAt = createdAt
        self.custom = custom
        self.fid = fid
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case createdAt = "created_at"
        case custom
        case fid
        case receivedAt = "received_at"
        case type
        case user
    }

    public static func == (lhs: ActivityDeletedEvent, rhs: ActivityDeletedEvent) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.fid == rhs.fid &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(fid)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
