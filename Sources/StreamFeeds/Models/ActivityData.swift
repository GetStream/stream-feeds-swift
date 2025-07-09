//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct ActivityData: Identifiable, Sendable {
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
    public private(set) var ownBookmarks: [BookmarkData]
    public private(set) var ownReactions: [FeedsReactionData]
    public var parent: ActivityData? { _parent?.value as? ActivityData }
    public let poll: PollData?
    public let popularity: Int
    public private(set) var reactionGroups: [String: ReactionGroupData]
    public let score: Float
    public let searchData: [String: RawJSON]
    public let shareCount: Int
    public let text: String?
    public let type: String
    public let updatedAt: Date
    public let user: UserData
    public let visibility: String
    public let visibilityTag: String?
    
    // Additional
    public var reactionCount: Int {
        reactionGroups.values.reduce(0) { $0 + $1.count }
    }
    
    fileprivate let _parent: BoxedAny?
}

// MARK: - Mutating the Data

extension ActivityData {
    mutating func addComment(_ comment: CommentData) {
        comments.insert(byId: comment)
        commentCount += 1
    }
    
    mutating func deleteComment(_ comment: CommentData) {
        commentCount = max(0, commentCount - 1)
        comments.remove(byId: comment.id)
    }
    
    mutating func addBookmark(_ bookmark: BookmarkData) {
        if bookmark.user.id == user.id {
            ownBookmarks.insert(byId: bookmark)
        }
        bookmarkCount += 1
    }
    
    mutating func deleteBookmark(_ bookmark: BookmarkData) {
        bookmarkCount = max(0, bookmarkCount - 1)
        ownBookmarks.remove(byId: bookmark.id)
    }
    
    mutating func addReaction(_ reaction: FeedsReactionData) {
        FeedsReactionData.updateByAdding(reaction: reaction, to: &latestReactions, reactionGroups: &reactionGroups)
        if reaction.user.id == user.id {
            ownReactions.insert(byId: reaction)
        }
    }
    
    mutating func removeReaction(_ reaction: FeedsReactionData) {
        FeedsReactionData.updateByRemoving(reaction: reaction, from: &latestReactions, reactionGroups: &reactionGroups)
        if reaction.user.id == user.id {
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
            ownBookmarks: ownBookmarks.map { $0.toModel() },
            ownReactions: ownReactions.map { $0.toModel() },
            poll: poll?.toModel(),
            popularity: popularity,
            reactionGroups: reactionGroups.compactMapValues { $0?.toModel() },
            score: score,
            searchData: searchData,
            shareCount: shareCount,
            text: text,
            type: type,
            updatedAt: updatedAt,
            user: user.toModel(),
            visibility: visibility.rawValue,
            visibilityTag: visibilityTag,
            _parent: BoxedAny(parent?.toModel())
        )
    }
}
