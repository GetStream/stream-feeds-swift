//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedGroupDeletedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var fid: String
    public var groupId: String
    public var receivedAt: Date?
    public var type: String = "feeds.feed_group.deleted"

    public init(createdAt: Date, custom: [String: RawJSON], fid: String, groupId: String, receivedAt: Date? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.fid = fid
        self.groupId = groupId
        self.receivedAt = receivedAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case fid
        case groupId = "group_id"
        case receivedAt = "received_at"
        case type
    }

    public static func == (lhs: FeedGroupDeletedEvent, rhs: FeedGroupDeletedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.fid == rhs.fid &&
            lhs.groupId == rhs.groupId &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(fid)
        hasher.combine(groupId)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
}
