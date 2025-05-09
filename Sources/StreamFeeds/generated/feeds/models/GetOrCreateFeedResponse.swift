import Foundation
import StreamCore

public final class GetOrCreateFeedResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activities: [Activity]
    public var aggregatedActivities: [AggregatedActivity]?
    public var duration: String
    public var feed: Feed
    public var followers: [Follow]?
    public var followersPagination: PagerResponse?
    public var following: [Follow]?
    public var followingPagination: PagerResponse?
    public var memberPagination: PagerResponse?
    public var members: [FeedMember]?
    public var next: String?
    public var notificationStatus: NotificationStatus?
    public var ownFeedFollow: Follow
    public var ownFeedMembership: FeedMember
    public var pinnedActivities: [ActivityPin]?
    public var prev: String?

    public init(activities: [Activity], aggregatedActivities: [AggregatedActivity]? = nil, duration: String, feed: Feed, followers: [Follow]? = nil, followersPagination: PagerResponse? = nil, following: [Follow]? = nil, followingPagination: PagerResponse? = nil, memberPagination: PagerResponse? = nil, members: [FeedMember]? = nil, next: String? = nil, notificationStatus: NotificationStatus? = nil, ownFeedFollow: Follow, ownFeedMembership: FeedMember, pinnedActivities: [ActivityPin]? = nil, prev: String? = nil) {
        self.activities = activities
        self.aggregatedActivities = aggregatedActivities
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
        self.ownFeedFollow = ownFeedFollow
        self.ownFeedMembership = ownFeedMembership
        self.pinnedActivities = pinnedActivities
        self.prev = prev
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case activities
        case aggregatedActivities = "aggregated_activities"
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
        case ownFeedFollow = "own_feed_follow"
        case ownFeedMembership = "own_feed_membership"
        case pinnedActivities = "pinned_activities"
        case prev
    }

    public static func == (lhs: GetOrCreateFeedResponse, rhs: GetOrCreateFeedResponse) -> Bool {
        lhs.activities == rhs.activities &&
            lhs.aggregatedActivities == rhs.aggregatedActivities &&
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
            lhs.ownFeedFollow == rhs.ownFeedFollow &&
            lhs.ownFeedMembership == rhs.ownFeedMembership &&
            lhs.pinnedActivities == rhs.pinnedActivities &&
            lhs.prev == rhs.prev
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(activities)
        hasher.combine(aggregatedActivities)
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
        hasher.combine(ownFeedFollow)
        hasher.combine(ownFeedMembership)
        hasher.combine(pinnedActivities)
        hasher.combine(prev)
    }
}
