//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public struct OwnCapability: RawRepresentable, ExpressibleByStringLiteral, Hashable {
    public var rawValue: String
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(stringLiteral value: String) {
        rawValue = value
    }
    
    public static let queryFollows: Self = "query-follows"
    public static let pinActivity: Self = "pin-activity"
    public static let updateActivity: Self = "update-activity"
    public static let queryFeedMembers: Self = "query-feed-members"
    public static let addComment: Self = "add-comment"
    public static let readFeed: Self = "read-feed"
    public static let deleteFeed: Self = "delete-feed"
    public static let addActivityReaction: Self = "add-activity-reaction"
    public static let removeActivityReaction: Self = "remove-activity-reaction"
    public static let removeCommentReaction: Self = "remove-comment-reaction"
    public static let updateFeedFollowers: Self = "update-feed-followers"
    public static let updateFeed: Self = "update-feed"
    public static let updateComment: Self = "update-comment"
    public static let updateFeedMembers: Self = "update-feed-members"
    public static let addActivity: Self = "add-activity"
    public static let markActivity: Self = "mark-activity"
    public static let deleteComment: Self = "delete-comment"
    public static let addCommentReaction: Self = "add-comment-reaction"
    public static let follow: Self = "follow"
    public static let unfollow: Self = "unfollow"
    public static let removeActivity: Self = "remove-activity"
}
