//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var createdAt: Date
    public var createdBy: UserResponse
    public var custom: [String: RawJSON]?
    public var deletedAt: Date?
    public var description: String
    public var feed: String
    public var filterTags: [String]?
    public var followerCount: Int
    public var followingCount: Int
    public var groupId: String
    public var id: String
    public var memberCount: Int
    public var name: String
    public var ownFollows: [FollowResponse]?
    public var pinCount: Int
    public var updatedAt: Date
    public var visibility: String?

    public init(createdAt: Date, createdBy: UserResponse, custom: [String: RawJSON]? = nil, deletedAt: Date? = nil, description: String, feed: String, filterTags: [String]? = nil, followerCount: Int, followingCount: Int, groupId: String, id: String, memberCount: Int, name: String, ownFollows: [FollowResponse]? = nil, pinCount: Int, updatedAt: Date, visibility: String? = nil) {
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
        self.ownFollows = ownFollows
        self.pinCount = pinCount
        self.updatedAt = updatedAt
        self.visibility = visibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case createdBy = "created_by"
        case custom
        case deletedAt = "deleted_at"
        case description
        case feed = "fid" // TODO: temp
        case filterTags = "filter_tags"
        case followerCount = "follower_count"
        case followingCount = "following_count"
        case groupId = "group_id"
        case id
        case memberCount = "member_count"
        case name
        case ownFollows = "own_follows"
        case pinCount = "pin_count"
        case updatedAt = "updated_at"
        case visibility
    }

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
            lhs.ownFollows == rhs.ownFollows &&
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
        hasher.combine(ownFollows)
        hasher.combine(pinCount)
        hasher.combine(updatedAt)
        hasher.combine(visibility)
    }
}
