//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedResponseVisibility: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let `private` = FeedResponseVisibility(rawValue: "private")
    public static let `public` = FeedResponseVisibility(rawValue: "public")
    public static let followers = FeedResponseVisibility(rawValue: "followers")
    public static let members = FeedResponseVisibility(rawValue: "members")
    public static let visible = FeedResponseVisibility(rawValue: "visible")
}

public final class FeedResponse: Sendable, Codable, JSONEncodable {
    /// When the feed was created
    public let createdAt: Date
    /// User response object
    public let createdBy: UserResponse
    /// Custom data for the feed
    public let custom: [String: RawJSON]?
    /// When the feed was deleted
    public let deletedAt: Date?
    /// Description of the feed
    public let description: String
    /// Fully qualified feed ID (group_id:id)
    public let feed: String
    /// Tags used for filtering feeds
    public let filterTags: [String]?
    /// Number of followers of this feed
    public let followerCount: Int
    /// Number of feeds this feed follows
    public let followingCount: Int
    /// Group this feed belongs to
    public let groupId: String
    /// Unique identifier for the feed
    public let id: String
    /// Number of members in this feed
    public let memberCount: Int
    /// Name of the feed
    public let name: String
    /// Capabilities the current user has for this feed
    public let ownCapabilities: [FeedOwnCapability]?
    /// Follow relationships where the current user's feeds are following this feed
    public let ownFollows: [FollowResponse]?
    public let ownMembership: FeedMemberResponse?
    /// Number of pinned activities in this feed
    public let pinCount: Int
    /// When the feed was last updated
    public let updatedAt: Date
    /// Visibility setting for the feed
    public let visibility: FeedResponseVisibility?

    public init(createdAt: Date, createdBy: UserResponse, custom: [String: RawJSON]? = nil, deletedAt: Date? = nil, description: String, feed: String, filterTags: [String]? = nil, followerCount: Int, followingCount: Int, groupId: String, id: String, memberCount: Int, name: String, ownCapabilities: [FeedOwnCapability]? = nil, ownFollows: [FollowResponse]? = nil, ownMembership: FeedMemberResponse? = nil, pinCount: Int, updatedAt: Date, visibility: FeedResponseVisibility? = nil) {
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.custom = custom
        self.deletedAt = deletedAt
        self.description = description
        self.feed = feed
        self.filterTags = filterTags
        self.followerCount = followerCount
        self.followingCount = followingCount
        self.groupId = groupId
        self.id = id
        self.memberCount = memberCount
        self.name = name
        self.ownCapabilities = ownCapabilities
        self.ownFollows = ownFollows
        self.ownMembership = ownMembership
        self.pinCount = pinCount
        self.updatedAt = updatedAt
        self.visibility = visibility
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.createdBy = try container.decode(UserResponse.self, forKey: .createdBy)
        self.custom = try container.decodeIfPresent([String: RawJSON].self, forKey: .custom)
        self.deletedAt = try container.decodeIfPresent(Date.self, forKey: .deletedAt)
        self.description = try container.decode(String.self, forKey: .description)
        self.feed = try container.decode(String.self, forKey: .feed)
        self.filterTags = try container.decodeIfPresent([String].self, forKey: .filterTags)
        self.followerCount = try container.decode(Int.self, forKey: .followerCount)
        self.followingCount = try container.decode(Int.self, forKey: .followingCount)
        self.groupId = try container.decode(String.self, forKey: .groupId)
        self.id = try container.decode(String.self, forKey: .id)
        self.memberCount = try container.decode(Int.self, forKey: .memberCount)
        self.name = try container.decode(String.self, forKey: .name)
        self.ownCapabilities = try container.decodeIfPresent([FeedOwnCapability].self, forKey: .ownCapabilities)
        self.ownFollows = try container.decodeIfPresent([FollowResponse].self, forKey: .ownFollows)
        self.ownMembership = try container.decodeIfPresent(FeedMemberResponse.self, forKey: .ownMembership)
        self.pinCount = try container.decode(Int.self, forKey: .pinCount)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.visibility = try container.decodeIfPresent(FeedResponseVisibility.self, forKey: .visibility)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(createdBy, forKey: .createdBy)
        try container.encodeIfPresent(custom, forKey: .custom)
        try container.encodeIfPresent(deletedAt, forKey: .deletedAt)
        try container.encode(description, forKey: .description)
        try container.encode(feed, forKey: .feed)
        try container.encodeIfPresent(filterTags, forKey: .filterTags)
        try container.encode(followerCount, forKey: .followerCount)
        try container.encode(followingCount, forKey: .followingCount)
        try container.encode(groupId, forKey: .groupId)
        try container.encode(id, forKey: .id)
        try container.encode(memberCount, forKey: .memberCount)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(ownCapabilities, forKey: .ownCapabilities)
        try container.encodeIfPresent(ownFollows, forKey: .ownFollows)
        try container.encodeIfPresent(ownMembership, forKey: .ownMembership)
        try container.encode(pinCount, forKey: .pinCount)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(visibility, forKey: .visibility)
    }
}

extension FeedResponse: Hashable {
    public static func == (lhs: FeedResponse, rhs: FeedResponse) -> Bool {
        lhs.createdAt == rhs.createdAt &&
            lhs.createdBy == rhs.createdBy &&
            lhs.custom == rhs.custom &&
            lhs.deletedAt == rhs.deletedAt &&
            lhs.description == rhs.description &&
            lhs.feed == rhs.feed &&
            lhs.filterTags == rhs.filterTags &&
            lhs.followerCount == rhs.followerCount &&
            lhs.followingCount == rhs.followingCount &&
            lhs.groupId == rhs.groupId &&
            lhs.id == rhs.id &&
            lhs.memberCount == rhs.memberCount &&
            lhs.name == rhs.name &&
            lhs.ownCapabilities == rhs.ownCapabilities &&
            lhs.ownFollows == rhs.ownFollows &&
            lhs.ownMembership == rhs.ownMembership &&
            lhs.pinCount == rhs.pinCount &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
        hasher.combine(createdBy)
        hasher.combine(custom)
        hasher.combine(deletedAt)
        hasher.combine(description)
        hasher.combine(feed)
        hasher.combine(filterTags)
        hasher.combine(followerCount)
        hasher.combine(followingCount)
        hasher.combine(groupId)
        hasher.combine(id)
        hasher.combine(memberCount)
        hasher.combine(name)
        hasher.combine(ownCapabilities)
        hasher.combine(ownFollows)
        hasher.combine(ownMembership)
        hasher.combine(pinCount)
        hasher.combine(updatedAt)
        hasher.combine(visibility)
    }
}
