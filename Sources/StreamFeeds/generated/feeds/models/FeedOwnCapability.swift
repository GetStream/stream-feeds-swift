//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public enum FeedOwnCapability: String, Sendable, Codable, CaseIterable {
    case addActivity = "add-activity"
    case addActivityReaction = "add-activity-reaction"
    case addComment = "add-comment"
    case addCommentReaction = "add-comment-reaction"
    case bookmarkActivity = "bookmark-activity"
    case createFeed = "create-feed"
    case deleteBookmark = "delete-bookmark"
    case deleteComment = "delete-comment"
    case deleteFeed = "delete-feed"
    case editBookmark = "edit-bookmark"
    case follow
    case inviteFeed = "invite-feed"
    case joinFeed = "join-feed"
    case leaveFeed = "leave-feed"
    case manageFeedGroup = "manage-feed-group"
    case markActivity = "mark-activity"
    case pinActivity = "pin-activity"
    case queryFeedMembers = "query-feed-members"
    case queryFollows = "query-follows"
    case readActivities = "read-activities"
    case readFeed = "read-feed"
    case removeActivity = "remove-activity"
    case removeActivityReaction = "remove-activity-reaction"
    case removeCommentReaction = "remove-comment-reaction"
    case unfollow
    case updateActivity = "update-activity"
    case updateComment = "update-comment"
    case updateFeed = "update-feed"
    case updateFeedFollowers = "update-feed-followers"
    case updateFeedMembers = "update-feed-members"
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
