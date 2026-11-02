//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a feed member is removed.
public final class FeedMemberRemovedEvent: Sendable, Event, Decodable {
    /// Date/time of creation
    public let createdAt: Date
    public let custom: [String: RawJSON]
    /// Who can see and follow a feed.
    public let feedVisibility: FeedVisibility?
    public let fid: String
    public let memberId: String
    public let receivedAt: Date?
    /// The type of event: "feeds.feed_member.removed" in this case
    public let type: String
    public let user: UserResponseCommonFields?

    public init(createdAt: Date, custom: [String: RawJSON], feedVisibility: FeedVisibility? = nil, fid: String, memberId: String, receivedAt: Date? = nil, type: String = "feeds.feed_member.removed", user: UserResponseCommonFields? = nil) {
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.memberId = memberId
        self.receivedAt = receivedAt
        self.type = type
        self.user = user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.feedVisibility = try container.decodeIfPresent(FeedVisibility.self, forKey: .feedVisibility)
        self.fid = try container.decode(String.self, forKey: .fid)
        self.memberId = try container.decode(String.self, forKey: .memberId)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
        self.user = try container.decodeIfPresent(UserResponseCommonFields.self, forKey: .user)
    }
}

extension FeedMemberRemovedEvent: Hashable {
    public static func == (lhs: FeedMemberRemovedEvent, rhs: FeedMemberRemovedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.memberId == rhs.memberId &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type &&
            lhs.user == rhs.user
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(memberId)
        hasher.combine(receivedAt)
        hasher.combine(type)
        hasher.combine(user)
    }
}
