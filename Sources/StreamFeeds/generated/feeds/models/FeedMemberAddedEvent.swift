//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedMemberAddedEvent: @unchecked Sendable, Event, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var custom: [String: RawJSON]
    public var feedVisibility: String?
    public var fid: String
    public var member: FeedMemberResponse
    public var receivedAt: Date?
    public var type: String = "feeds.feed_member.added"
    public var user: UserResponseCommonFields?

    public init(createdAt: Date, custom: [String: RawJSON], feedVisibility: String? = nil, fid: String, member: FeedMemberResponse, receivedAt: Date? = nil, user: UserResponseCommonFields? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.member = member
        self.receivedAt = receivedAt
        self.user = user
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case custom
        case feedVisibility = "feed_visibility"
        case fid
        case member
        case receivedAt = "received_at"
        case type
        case user
    }

    public static func == (lhs: FeedMemberAddedEvent, rhs: FeedMemberAddedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.member == rhs.member &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(member)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
