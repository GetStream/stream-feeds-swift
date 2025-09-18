//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct ActivityData: Identifiable, Equatable, Sendable {
    public let attachments: [Attachment]
    public private(set) var bookmarkCount: Int
    public private(set) var commentCount: Int
    public private(set) var comments: [CommentData]
    public let createdAt: Date
    public let currentFeed: FeedData?
    public let custom: [String: RawJSON]
    public let deletedAt: Date?
    public let editedAt: Date?
    public let expiresAt: Date?
    public let feeds: [String]
    public let filterTags: [String]
    public let id: String
    public let interestTags: [String]
    public private(set) var latestReactions: [FeedsReactionData]
    public let location: ActivityLocation?
    public let mentionedUsers: [UserData]
    public let moderation: ModerationV2Response?
    public let notificationContext: NotificationContext?
    public private(set) var ownBookmarks: [BookmarkData]
    public private(set) var ownReactions: [FeedsReactionData]
    public var parent: ActivityData? { _parent?.getValue() }
    public let poll: PollData?
    public let popularity: Int
    public private(set) var reactionCount: Int
    public private(set) var reactionGroups: [String: ReactionGroupData]
    public let score: Float
    public let searchData: [String: RawJSON]
    public let shareCount: Int
    public let text: String?
    public let type: String
    public let updatedAt: Date
    public let user: UserData
    public let visibility: ActivityDataVisibility
    public let visibilityTag: String?
    
    fileprivate let _parent: BoxedAny?
}

public typealias ActivityDataVisibility = ActivityResponse.ActivityResponseVisibility

// MARK: - Mutating the Data

extension ActivityData {
    mutating func addComment(_ comment: CommentData) {
        if comments.insert(byId: comment) {
            commentCount += 1
        }
    }
    
    mutating func deleteComment(_ comment: CommentData) {
        if comments.remove(byId: comment.id) {
            commentCount = max(0, commentCount - 1)
        }
    }
    
    mutating func updateComment(_ comment: CommentData) {
        comments.replace(byId: comment)
    }
    
    mutating func addBookmark(_ bookmark: BookmarkData, currentUserId: String) {
        if bookmark.user.id == currentUserId {
            if ownBookmarks.insert(byId: bookmark) {
                bookmarkCount += 1
            }
        } else {
            bookmarkCount += 1
        }
    }
    
    mutating func deleteBookmark(_ bookmark: BookmarkData, currentUserId: String) {
        if bookmark.user.id == currentUserId {
            if ownBookmarks.remove(byId: bookmark.id) {
                bookmarkCount = max(0, bookmarkCount - 1)
            }
        } else {
            bookmarkCount = max(0, bookmarkCount - 1)
        }
    }
    
    mutating func addReaction(_ reaction: FeedsReactionData, currentUserId: String) {
        FeedsReactionData.updateByAdding(reaction: reaction, to: &latestReactions, reactionGroups: &reactionGroups)
        reactionCount = reactionGroups.values.reduce(0) { $0 + $1.count }
        if reaction.user.id == currentUserId {
            ownReactions.insert(byId: reaction)
        }
    }
    
    mutating func removeReaction(_ reaction: FeedsReactionData, currentUserId: String) {
        FeedsReactionData.updateByRemoving(reaction: reaction, from: &latestReactions, reactionGroups: &reactionGroups)
        reactionCount = reactionGroups.values.reduce(0) { $0 + $1.count }
        if reaction.user.id == currentUserId {
            ownReactions.remove(byId: reaction.id)
        }
    }
}

// MARK: - Model Conversions

extension ActivityResponse {
    func toModel() -> ActivityData {
        ActivityData(
            attachments: attachments,
            bookmarkCount: bookmarkCount,
            commentCount: commentCount,
            comments: comments.map { $0.toModel() },
            createdAt: createdAt,
            currentFeed: currentFeed?.toModel(),
            custom: custom,
            deletedAt: deletedAt,
            editedAt: editedAt,
            expiresAt: expiresAt,
            feeds: feeds,
            filterTags: filterTags,
            id: id,
            interestTags: interestTags,
            latestReactions: latestReactions.map { $0.toModel() },
            location: location,
            mentionedUsers: mentionedUsers.map { $0.toModel() },
            moderation: moderation,
            notificationContext: notificationContext,
            ownBookmarks: ownBookmarks.map { $0.toModel() },
            ownReactions: ownReactions.map { $0.toModel() },
            poll: poll?.toModel(),
            popularity: popularity,
            reactionCount: reactionCount,
            reactionGroups: reactionGroups.compactMapValues { $0?.toModel() },
            score: score,
            searchData: searchData,
            shareCount: shareCount,
            text: text,
            type: type,
            updatedAt: updatedAt,
            user: user.toModel(),
            visibility: visibility,
            visibilityTag: visibilityTag,
            _parent: BoxedAny(parent?.toModel())
        )
    }
}
