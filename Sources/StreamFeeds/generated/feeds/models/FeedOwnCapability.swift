//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Represents a feed capability value and enumerates all possible capability strings.
public final class FeedOwnCapability: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let addActivity = FeedOwnCapability(rawValue: "add-activity")
    public static let addActivityBookmark = FeedOwnCapability(rawValue: "add-activity-bookmark")
    public static let addActivityReaction = FeedOwnCapability(rawValue: "add-activity-reaction")
    public static let addComment = FeedOwnCapability(rawValue: "add-comment")
    public static let addCommentReaction = FeedOwnCapability(rawValue: "add-comment-reaction")
    public static let createFeed = FeedOwnCapability(rawValue: "create-feed")
    public static let deleteAnyActivity = FeedOwnCapability(rawValue: "delete-any-activity")
    public static let deleteAnyComment = FeedOwnCapability(rawValue: "delete-any-comment")
    public static let deleteFeed = FeedOwnCapability(rawValue: "delete-feed")
    public static let deleteOwnActivity = FeedOwnCapability(rawValue: "delete-own-activity")
    public static let deleteOwnActivityBookmark = FeedOwnCapability(rawValue: "delete-own-activity-bookmark")
    public static let deleteOwnActivityReaction = FeedOwnCapability(rawValue: "delete-own-activity-reaction")
    public static let deleteOwnComment = FeedOwnCapability(rawValue: "delete-own-comment")
    public static let deleteOwnCommentReaction = FeedOwnCapability(rawValue: "delete-own-comment-reaction")
    public static let follow = FeedOwnCapability(rawValue: "follow")
    public static let pinActivity = FeedOwnCapability(rawValue: "pin-activity")
    public static let queryFeedMembers = FeedOwnCapability(rawValue: "query-feed-members")
    public static let queryFollows = FeedOwnCapability(rawValue: "query-follows")
    public static let readActivities = FeedOwnCapability(rawValue: "read-activities")
    public static let readFeed = FeedOwnCapability(rawValue: "read-feed")
    public static let unfollow = FeedOwnCapability(rawValue: "unfollow")
    public static let updateAnyActivity = FeedOwnCapability(rawValue: "update-any-activity")
    public static let updateAnyComment = FeedOwnCapability(rawValue: "update-any-comment")
    public static let updateFeed = FeedOwnCapability(rawValue: "update-feed")
    public static let updateFeedFollowers = FeedOwnCapability(rawValue: "update-feed-followers")
    public static let updateFeedMembers = FeedOwnCapability(rawValue: "update-feed-members")
    public static let updateOwnActivity = FeedOwnCapability(rawValue: "update-own-activity")
    public static let updateOwnActivityBookmark = FeedOwnCapability(rawValue: "update-own-activity-bookmark")
    public static let updateOwnComment = FeedOwnCapability(rawValue: "update-own-comment")
}
