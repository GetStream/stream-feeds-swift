//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public enum FeedOwnCapability: String, Sendable, Codable, CaseIterable {
    case addActivity = "add-activity"
    case addActivityBookmark = "add-activity-bookmark"
    case addActivityReaction = "add-activity-reaction"
    case addComment = "add-comment"
    case addCommentReaction = "add-comment-reaction"
    case createFeed = "create-feed"
    case deleteAnyActivity = "delete-any-activity"
    case deleteAnyComment = "delete-any-comment"
    case deleteFeed = "delete-feed"
    case deleteOwnActivity = "delete-own-activity"
    case deleteOwnActivityBookmark = "delete-own-activity-bookmark"
    case deleteOwnActivityReaction = "delete-own-activity-reaction"
    case deleteOwnComment = "delete-own-comment"
    case deleteOwnCommentReaction = "delete-own-comment-reaction"
    case follow = "follow"
    case pinActivity = "pin-activity"
    case queryFeedMembers = "query-feed-members"
    case queryFollows = "query-follows"
    case readActivities = "read-activities"
    case readFeed = "read-feed"
    case unfollow = "unfollow"
    case updateAnyActivity = "update-any-activity"
    case updateAnyComment = "update-any-comment"
    case updateFeed = "update-feed"
    case updateFeedFollowers = "update-feed-followers"
    case updateFeedMembers = "update-feed-members"
    case updateOwnActivity = "update-own-activity"
    case updateOwnActivityBookmark = "update-own-activity-bookmark"
    case updateOwnComment = "update-own-comment"
    case unknown = "_unknown"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let decodedValue = try? container.decode(String.self),
           let value = FeedOwnCapability(rawValue: decodedValue) {
            self = value
        } else {
            self = .unknown
        }
    }
}
