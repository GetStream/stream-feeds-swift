//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Emitted when a follow relationship is updated.
public final class FollowUpdatedEvent: Sendable, Event, Decodable {
    /// Date/time of creation
    public let createdAt: Date
    public let custom: [String: RawJSON]
    /// Who can see and follow a feed.
    public let feedVisibility: FeedVisibility?
    public let fid: String
    public let follow: FollowResponse
    public let receivedAt: Date?
    /// The type of event: "feeds.follow.updated" in this case
    public let type: String

    public init(createdAt: Date, custom: [String: RawJSON], feedVisibility: FeedVisibility? = nil, fid: String, follow: FollowResponse, receivedAt: Date? = nil, type: String = "feeds.follow.updated") {
        self.createdAt = createdAt
        self.custom = custom
        self.feedVisibility = feedVisibility
        self.fid = fid
        self.follow = follow
        self.receivedAt = receivedAt
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.feedVisibility = try container.decodeIfPresent(FeedVisibility.self, forKey: .feedVisibility)
        self.fid = try container.decode(String.self, forKey: .fid)
        self.follow = try container.decode(FollowResponse.self, forKey: .follow)
        self.receivedAt = try container.decodeIfPresent(Date.self, forKey: .receivedAt)
        self.type = try container.decode(String.self, forKey: .type)
    }
}

extension FollowUpdatedEvent: Hashable {
    public static func == (lhs: FollowUpdatedEvent, rhs: FollowUpdatedEvent) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.custom == rhs.custom &&
            lhs.feedVisibility == rhs.feedVisibility &&
            lhs.fid == rhs.fid &&
            lhs.follow == rhs.follow &&
            lhs.receivedAt == rhs.receivedAt &&
            lhs.type == rhs.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(custom)
        hasher.combine(feedVisibility)
        hasher.combine(fid)
        hasher.combine(follow)
        hasher.combine(receivedAt)
        hasher.combine(type)
    }
}
