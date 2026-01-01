//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityAddedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var activity: ActivityResponse
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var feedVisibility: String?
    public var fid: String
    public var receivedAt: Date?
    public var type: String = "feeds.activity.added"
    public var user: UserResponseCommonFields?

    public init(activity: ActivityResponse, createdAt: Date, custom: [String: RawJSON], feedVisibility: String? = nil, fid: String, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.activity = activity
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activity
        case createdAt = "created_at"
        case custom
        case feedVisibility = "feed_visibility"
        case fid
        case receivedAt = "received_at"
        case type
        case user
    }

    public static func == (lhs: ActivityAddedEvent, rhs: ActivityAddedEvent) -> Bool {
        lhs.activity == rhs.activity &&
            lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
