//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetOrCreateFeedResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activities: [ActivityResponse]
    public var aggregatedActivities: [AggregatedActivityResponse]
    public var created: Bool
    public var duration: String
    public var feed: FeedResponse
    public var followers: [FollowResponse]
    public var followersPagination: PagerResponse?
    public var following: [FollowResponse]
    public var followingPagination: PagerResponse?
    public var memberPagination: PagerResponse?
    public var members: [FeedMemberResponse]
    public var next: String?
    public var notificationStatus: NotificationStatusResponse?
    public var ownCapabilities: [FeedOwnCapability]
    public var ownFollows: [FollowResponse]?
    public var ownMembership: FeedMemberResponse?
    public var pinnedActivities: [ActivityPinResponse]
    public var prev: String?

    public init(activities: [ActivityResponse], aggregatedActivities: [AggregatedActivityResponse], created: Bool, duration: String, feed: FeedResponse, followers: [FollowResponse], followersPagination: PagerResponse? = nil, following: [FollowResponse], followingPagination: PagerResponse? = nil, memberPagination: PagerResponse? = nil, members: [FeedMemberResponse], next: String? = nil, notificationStatus: NotificationStatusResponse? = nil, ownCapabilities: [FeedOwnCapability], ownFollows: [FollowResponse]? = nil, ownMembership: FeedMemberResponse? = nil, pinnedActivities: [ActivityPinResponse], prev: String? = nil) {
        self.activities = activities
        self.aggregatedActivities = aggregatedActivities
        self.created = created
        self.duration = duration
        self.feed = feed
        self.followers = followers
        self.followersPagination = followersPagination
        self.following = following
        self.followingPagination = followingPagination
        self.memberPagination = memberPagination
        self.members = members
        self.next = next
        self.notificationStatus = notificationStatus
        self.ownCapabilities = ownCapabilities
        self.ownFollows = ownFollows
        self.ownMembership = ownMembership
        self.pinnedActivities = pinnedActivities
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activities
        case aggregatedActivities = "aggregated_activities"
        case created
        case duration
        case feed
        case followers
        case followersPagination = "followers_pagination"
        case following
        case followingPagination = "following_pagination"
        case memberPagination = "member_pagination"
        case members
        case next
        case notificationStatus = "notification_status"
        case ownCapabilities = "own_capabilities"
        case ownFollows = "own_follows"
        case ownMembership = "own_membership"
        case pinnedActivities = "pinned_activities"
        case prev
    }

    public static func == (lhs: GetOrCreateFeedResponse, rhs: GetOrCreateFeedResponse) -> Bool {
        lhs.activities == rhs.activities &&
            lhs.aggregatedActivities == rhs.aggregatedActivities &&
            lhs.created == rhs.created &&
            lhs.duration == rhs.duration &&
            lhs.feed == rhs.feed &&
            lhs.followers == rhs.followers &&
            lhs.followersPagination == rhs.followersPagination &&
            lhs.following == rhs.following &&
            lhs.followingPagination == rhs.followingPagination &&
            lhs.memberPagination == rhs.memberPagination &&
            lhs.members == rhs.members &&
            lhs.next == rhs.next &&
            lhs.notificationStatus == rhs.notificationStatus &&
            lhs.ownCapabilities == rhs.ownCapabilities &&
            lhs.ownFollows == rhs.ownFollows &&
            lhs.ownMembership == rhs.ownMembership &&
            lhs.pinnedActivities == rhs.pinnedActivities &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activities)
        hasher.combine(aggregatedActivities)
        hasher.combine(created)
        hasher.combine(duration)
        hasher.combine(feed)
        hasher.combine(followers)
        hasher.combine(followersPagination)
        hasher.combine(following)
        hasher.combine(followingPagination)
        hasher.combine(memberPagination)
        hasher.combine(members)
        hasher.combine(next)
        hasher.combine(notificationStatus)
        hasher.combine(ownCapabilities)
        hasher.combine(ownFollows)
        hasher.combine(ownMembership)
        hasher.combine(pinnedActivities)
        hasher.combine(prev)
    }
}
