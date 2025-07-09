//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FollowUpdatedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var fid: String
    public var follow: FollowResponse
    public var receivedAt: Date?
    public var type: String = "feeds.follow.updated"

    public init(createdAt: Date, custom: [String: RawJSON], fid: String, follow: FollowResponse, receivedAt: Date? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.fid = fid
        self.follow = follow
        self.receivedAt = receivedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case fid
        case follow
        case receivedAt = "received_at"
        case type
    }

    public static func == (lhs: FollowUpdatedEvent, rhs: FollowUpdatedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.fid == rhs.fid &&
            lhs.follow == rhs.follow &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(fid)
        hasher.combine(follow)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
}
