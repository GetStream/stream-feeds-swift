//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct ActivityInfo: Identifiable, Sendable {
    public let attachments: [Attachment]
    public private(set) var bookmarkCount: Int
    public private(set) var commentCount: Int
    public private(set) var comments: [CommentInfo]
    public let createdAt: Date
    public let currentFeed: FeedInfo?
    public let custom: [String: RawJSON]
    public let deletedAt: Date?
    public let editedAt: Date?
    public let expiresAt: Date?
    public let feeds: [String]
    public let filterTags: [String]
    public let id: String
    public let interestTags: [String]
    public private(set) var latestReactions: [ActivityReactionInfo]
    public let location: ActivityLocation?
    public let mentionedUsers: [UserResponse]
    public let moderation: ModerationV2Response?
    public private(set) var ownBookmarks: [BookmarkInfo]
    public private(set) var ownReactions: [ActivityReactionInfo]
    public let parent: BaseActivityResponse?
    public let poll: PollResponseData?
    public let popularity: Int
    public private(set) var reactionGroups: [String: ReactionGroupInfo]
    public let score: Float
    public let searchData: [String: RawJSON]
    public let shareCount: Int
    public let text: String?
    public let type: String
    public let updatedAt: Date
    public let user: UserResponse
    public let visibility: String
    public let visibilityTag: String?
    
    // Additional computed
    
    public let reactionCount: Int
    
    /// Creates a new instance of `ActivityInfo` from a `ActivityResponse`.
    /// - Parameter response: The response object containing the activity data.
    init(from response: ActivityResponse) {
        self.attachments = response.attachments
        self.bookmarkCount = response.bookmarkCount
        self.commentCount = response.commentCount
        self.comments = response.comments.map(CommentInfo.init(from:))
        self.createdAt = response.createdAt
        self.currentFeed = response.currentFeed.flatMap(FeedInfo.init(from:))
        self.custom = response.custom
        self.deletedAt = response.deletedAt
        self.editedAt = response.editedAt
        self.expiresAt = response.expiresAt
        self.feeds = response.feeds
        self.filterTags = response.filterTags
        self.id = response.id
        self.interestTags = response.interestTags
        self.latestReactions = response.latestReactions.map(ActivityReactionInfo.init(from:))
        self.location = response.location
        self.mentionedUsers = response.mentionedUsers
        self.moderation = response.moderation
        self.ownBookmarks = response.ownBookmarks.map(BookmarkInfo.init(from:))
        self.ownReactions = response.ownReactions.map(ActivityReactionInfo.init(from:))
        self.parent = response.parent
        self.poll = response.poll
        self.popularity = response.popularity
        self.reactionGroups = response.reactionGroups.mapValues(ReactionGroupInfo.init(from:))
        self.score = response.score
        self.searchData = response.searchData
        self.shareCount = response.shareCount
        self.text = response.text
        self.type = response.type
        self.updatedAt = response.updatedAt
        self.user = response.user
        self.visibility = response.visibility
        self.visibilityTag = response.visibilityTag
        
        // Additional
        self.reactionCount = reactionGroups.values.compactMap(\.count).reduce(0, +)
    }
}

// MARK: - Mutating the Data

extension ActivityInfo {
    mutating func addComment(_ comment: CommentInfo) {
        comments.insert(byId: comment)
        commentCount += 1
    }
    
    mutating func deleteComment(_ comment: CommentInfo) {
        commentCount = max(0, commentCount - 1)
        comments.remove(byId: comment)
    }
    
    mutating func addBookmark(_ bookmark: BookmarkInfo) {
        if bookmark.user.id == user.id {
            ownBookmarks.insert(byId: bookmark)
        }
        bookmarkCount += 1
    }
    
    mutating func deleteBookmark(_ bookmark: BookmarkInfo) {
        bookmarkCount = max(0, bookmarkCount - 1)
        ownBookmarks.remove(byId: bookmark)
    }
    
    mutating func addReaction(_ reaction: ActivityReactionInfo) {
        latestReactions.insert(byId: reaction)
        if reaction.user.id == user.id {
            ownReactions.insert(byId: reaction)
        }
        var reactionGroup = reactionGroups[reaction.type] ?? ReactionGroupInfo(count: 0, firstReactionAt: reaction.createdAt, lastReactionAt: reaction.createdAt)
        reactionGroup.increment(with: reaction.createdAt)
        reactionGroups[reaction.type] = reactionGroup
    }
}

// MARK: - Sorting

extension ActivityInfo {
    static let defaultSorting: (ActivityInfo, ActivityInfo) -> Bool = { $0.createdAt > $1.createdAt }
}
