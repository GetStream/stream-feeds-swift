import Foundation
import StreamCore

public final class GetOrCreateFeedResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var activities: [Activity]
    public var aggregatedActivities: [AggregatedActivity]
    public var duration: String
    public var feed: Feed
    public var followers: [Follow]
    public var followersPagination: PagerResponse?
    public var following: [Follow]
    public var followingPagination: PagerResponse?
    public var memberPagination: PagerResponse?
    public var members: [FeedMember]
    public var next: String?
    public var notificationStatus: NotificationStatus?
    public var ownFollows: [Follow]?
    public var ownMembership: FeedMember?
    public var pinnedActivities: [ActivityPin]
    public var prev: String?

    public init(activities: [Activity], aggregatedActivities: [AggregatedActivity], duration: String, feed: Feed, followers: [Follow], followersPagination: PagerResponse? = nil, following: [Follow], followingPagination: PagerResponse? = nil, memberPagination: PagerResponse? = nil, members: [FeedMember], next: String? = nil, notificationStatus: NotificationStatus? = nil, ownFollows: [Follow]? = nil, ownMembership: FeedMember? = nil, pinnedActivities: [ActivityPin], prev: String? = nil) {
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
        self.ownFollows = ownFollows
        self.ownMembership = ownMembership
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
        case ownFollows = "own_follows"
        case ownMembership = "own_membership"
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
            lhs.ownFollows == rhs.ownFollows &&
            lhs.ownMembership == rhs.ownMembership &&
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
        hasher.combine(ownFollows)
        hasher.combine(ownMembership)
        hasher.combine(pinnedActivities)
        hasher.combine(prev)
    }
}
