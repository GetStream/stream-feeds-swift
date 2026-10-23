//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class FeedSuggestionResponse: @unchecked Sendable, Codable, JSONEncodable {
    public enum FeedSuggestionResponseVisibility: String, Sendable, Codable, CaseIterable {
        case `private`
        case `public`
        case followers
        case members
        case visible
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    public var activityCount: Int
    public var algorithmScores: [String: Float]?
    /// When the feed was created
    public var createdAt: Date
    /// User response object
    public var createdBy: UserResponse
    /// Custom data for the feed
    public var custom: [String: RawJSON]?
    /// When the feed was deleted
    public var deletedAt: Date?
    /// Description of the feed
    public var description: String
    /// Fully qualified feed ID (group_id:id)
    public var feed: String
    /// Tags used for filtering feeds
    public var filterTags: [String]?
    /// Number of followers of this feed
    public var followerCount: Int
    /// Number of feeds this feed follows
    public var followingCount: Int
    /// Group this feed belongs to
    public var groupId: String
    /// Unique identifier for the feed
    public var id: String
    public var location: Location?
    /// Number of members in this feed
    public var memberCount: Int
    /// Name of the feed
    public var name: String
    /// Capabilities the current user has for this feed
    public var ownCapabilities: [FeedOwnCapability]?
    /// Follow relationships where the feed owner’s feeds are following the current user's feeds
    public var ownFollowings: [FollowResponse]?
    /// Follow relationships where the current user's feeds are following this feed
    public var ownFollows: [FollowResponse]?
    public var ownMembership: FeedMemberResponse?
    /// Number of pinned activities in this feed
    public var pinCount: Int
    public var reason: String?
    public var recommendationScore: Float?
    /// When the feed was last updated
    public var updatedAt: Date
    /// Visibility setting for the feed
    public var visibility: FeedSuggestionResponseVisibility?

    public init(activityCount: Int, algorithmScores: [String: Float]? = nil, createdAt: Date, createdBy: UserResponse, custom: [String: RawJSON]? = nil, deletedAt: Date? = nil, description: String, feed: String, filterTags: [String]? = nil, followerCount: Int, followingCount: Int, groupId: String, id: String, location: Location? = nil, memberCount: Int, name: String, ownCapabilities: [FeedOwnCapability]? = nil, ownFollowings: [FollowResponse]? = nil, ownFollows: [FollowResponse]? = nil, ownMembership: FeedMemberResponse? = nil, pinCount: Int, reason: String? = nil, recommendationScore: Float? = nil, updatedAt: Date, visibility: FeedSuggestionResponseVisibility? = nil) {
        self.activityCount = activityCount
        self.algorithmScores = algorithmScores
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
        self.location = location
        self.memberCount = memberCount
        self.name = name
        self.ownCapabilities = ownCapabilities
        self.ownFollowings = ownFollowings
        self.ownFollows = ownFollows
        self.ownMembership = ownMembership
        self.pinCount = pinCount
        self.reason = reason
        self.recommendationScore = recommendationScore
        self.updatedAt = updatedAt
        self.visibility = visibility
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activityCount = "activity_count"
        case algorithmScores = "algorithm_scores"
        case createdAt = "created_at"
        case createdBy = "created_by"
        case custom
        case deletedAt = "deleted_at"
        case description
        case feed
        case filterTags = "filter_tags"
        case followerCount = "follower_count"
        case followingCount = "following_count"
        case groupId = "group_id"
        case id
        case location
        case memberCount = "member_count"
        case name
        case ownCapabilities = "own_capabilities"
        case ownFollowings = "own_followings"
        case ownFollows = "own_follows"
        case ownMembership = "own_membership"
        case pinCount = "pin_count"
        case reason
        case recommendationScore = "recommendation_score"
        case updatedAt = "updated_at"
        case visibility
    }
}

extension FeedSuggestionResponse: Hashable {
    public static func == (lhs: FeedSuggestionResponse, rhs: FeedSuggestionResponse) -> Bool {
        lhs.activityCount == rhs.activityCount &&
            lhs.algorithmScores == rhs.algorithmScores &&
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
            lhs.location == rhs.location &&
            lhs.memberCount == rhs.memberCount &&
            lhs.name == rhs.name &&
            lhs.ownCapabilities == rhs.ownCapabilities &&
            lhs.ownFollowings == rhs.ownFollowings &&
            lhs.ownFollows == rhs.ownFollows &&
            lhs.ownMembership == rhs.ownMembership &&
            lhs.pinCount == rhs.pinCount &&
            lhs.reason == rhs.reason &&
            lhs.recommendationScore == rhs.recommendationScore &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.visibility == rhs.visibility
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activityCount)
        hasher.combine(algorithmScores)
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
        hasher.combine(location)
        hasher.combine(memberCount)
        hasher.combine(name)
        hasher.combine(ownCapabilities)
        hasher.combine(ownFollowings)
        hasher.combine(ownFollows)
        hasher.combine(ownMembership)
        hasher.combine(pinCount)
        hasher.combine(reason)
        hasher.combine(recommendationScore)
        hasher.combine(updatedAt)
        hasher.combine(visibility)
    }
}
