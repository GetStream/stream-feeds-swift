//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedCreatedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var feed: FeedResponse
    public var fid: String
    public var members: [FeedMemberResponse]
    public var receivedAt: Date?
    public var type: String = "feeds.feed.created"
    public var user: UserResponseCommonFields

    public init(createdAt: Date, custom: [String: RawJSON], feed: FeedResponse, fid: String, members: [FeedMemberResponse], receivedAt: Date? = nil, user: UserResponseCommonFields) {
        self.createdAt = createdAt
        self.custom = custom
        self.feed = feed
        self.fid = fid
        self.members = members
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case feed
        case fid
        case members
        case receivedAt = "received_at"
        case type
        case user
    }

    public static func == (lhs: FeedCreatedEvent, rhs: FeedCreatedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feed == rhs.feed &&
            lhs.fid == rhs.fid &&
            lhs.members == rhs.members &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feed)
        hasher.combine(fid)
        hasher.combine(members)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
