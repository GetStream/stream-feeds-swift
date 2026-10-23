//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class GetOrCreateFeedResponse: Sendable, Decodable {
    public let activities: [ActivityResponse]
    public let aggregatedActivities: [AggregatedActivityResponse]
    public let created: Bool
    /// Duration of the request in milliseconds
    public let duration: String
    public let feed: FeedResponse
    public let followers: [FollowResponse]
    public let followersPagination: PagerResponse?
    public let following: [FollowResponse]
    public let followingPagination: PagerResponse?
    public let memberPagination: PagerResponse?
    public let members: [FeedMemberResponse]
    public let next: String?
    public let notificationStatus: NotificationStatusResponse?
    public let pinnedActivities: [ActivityPinResponse]
    public let prev: String?

    public init(activities: [ActivityResponse], aggregatedActivities: [AggregatedActivityResponse], created: Bool, duration: String, feed: FeedResponse, followers: [FollowResponse], followersPagination: PagerResponse? = nil, following: [FollowResponse], followingPagination: PagerResponse? = nil, memberPagination: PagerResponse? = nil, members: [FeedMemberResponse], next: String? = nil, notificationStatus: NotificationStatusResponse? = nil, pinnedActivities: [ActivityPinResponse], prev: String? = nil) {
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
        self.pinnedActivities = pinnedActivities
        self.prev = prev
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.activities = try container.decode([ActivityResponse].self, forKey: .activities)
        self.aggregatedActivities = try container.decode([AggregatedActivityResponse].self, forKey: .aggregatedActivities)
        self.created = try container.decode(Bool.self, forKey: .created)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.feed = try container.decode(FeedResponse.self, forKey: .feed)
        self.followers = try container.decode([FollowResponse].self, forKey: .followers)
        self.followersPagination = try container.decodeIfPresent(PagerResponse.self, forKey: .followersPagination)
        self.following = try container.decode([FollowResponse].self, forKey: .following)
        self.followingPagination = try container.decodeIfPresent(PagerResponse.self, forKey: .followingPagination)
        self.memberPagination = try container.decodeIfPresent(PagerResponse.self, forKey: .memberPagination)
        self.members = try container.decode([FeedMemberResponse].self, forKey: .members)
        self.next = try container.decodeIfPresent(String.self, forKey: .next)
        self.notificationStatus = try container.decodeIfPresent(NotificationStatusResponse.self, forKey: .notificationStatus)
        self.pinnedActivities = try container.decode([ActivityPinResponse].self, forKey: .pinnedActivities)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }
}

extension GetOrCreateFeedResponse: Hashable {
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
        hasher.combine(pinnedActivities)
        hasher.combine(prev)
    }
}
