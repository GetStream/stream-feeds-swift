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
    
    private let _parent: BoxedAny?
    
    init(from response: ActivityResponse) {
        self.attachments = response.attachments
        self.bookmarkCount = response.bookmarkCount
        self.commentCount = response.commentCount
        self.comments = response.comments.map { CommentData(from: $0) }
        self.createdAt = response.createdAt
        self.currentFeed = response.currentFeed.map { FeedData(from: $0) }
        self.custom = response.custom
        self.deletedAt = response.deletedAt
        self.editedAt = response.editedAt
        self.expiresAt = response.expiresAt
        self.feeds = response.feeds
        self.filterTags = response.filterTags
        self.id = response.id
        self.interestTags = response.interestTags
        self.latestReactions = response.latestReactions.map { FeedsReactionData(from: $0) }
        self.location = response.location
        self.mentionedUsers = response.mentionedUsers.map { UserData(from: $0) }
        self.moderation = response.moderation
        self.ownBookmarks = response.ownBookmarks.map { BookmarkData(from: $0) }
        self.ownReactions = response.ownReactions.map { FeedsReactionData(from: $0) }
        self._parent = BoxedAny(response.parent)
        self.poll = response.poll.flatMap(PollData.init(from:))
        self.popularity = response.popularity
        self.reactionGroups = response.reactionGroups.mapValues { ReactionGroupData(from: $0) }
        self.score = response.score
        self.searchData = response.searchData
        self.shareCount = response.shareCount
        self.text = response.text
        self.type = response.type
        self.updatedAt = response.updatedAt
        self.user = UserData(from: response.user)
        self.visibility = response.visibility
        self.visibilityTag = response.visibilityTag
    }
    
    /// Creates a new instance of `ActivityData` from a `BaseActivityResponse`.
    /// - Parameter response: The base response object containing the activity data.
    init(from response: BaseActivityResponse) {
        self.attachments = response.attachments
        self.bookmarkCount = response.bookmarkCount
        self.commentCount = response.commentCount
        self.comments = response.comments.map { CommentData(from: $0) }
        self.createdAt = response.createdAt
        self.currentFeed = response.currentFeed.map { FeedData(from: $0) }
        self.custom = response.custom
        self.deletedAt = response.deletedAt
        self.editedAt = response.editedAt
        self.expiresAt = response.expiresAt
        self.feeds = response.feeds
        self.filterTags = response.filterTags
        self.id = response.id
        self.interestTags = response.interestTags
        self.latestReactions = response.latestReactions.map { FeedsReactionData(from: $0) }
        self.location = response.location
        self.mentionedUsers = response.mentionedUsers.map { UserData(from: $0) }
        self.moderation = response.moderation
        self.ownBookmarks = response.ownBookmarks.map { BookmarkData(from: $0) }
        self.ownReactions = response.ownReactions.map { FeedsReactionData(from: $0) }
        self._parent = nil // BaseActivityResponse doesn't have a parent
        self.poll = response.poll.flatMap(PollData.init(from:))
        self.popularity = response.popularity
        self.reactionGroups = response.reactionGroups.mapValues { ReactionGroupData(from: $0) }
        self.score = response.score
        self.searchData = response.searchData
        self.shareCount = response.shareCount
        self.text = response.text
        self.type = response.type
        self.updatedAt = response.updatedAt
        self.user = UserData(from: response.user)
        self.visibility = response.visibility
        self.visibilityTag = response.visibilityTag
    }
}

// MARK: - Mutating the Data

extension ActivityData {
    mutating func addComment(_ comment: CommentData) {
        comments.insert(byId: comment)
        commentCount += 1
    }
    
    mutating func deleteComment(_ comment: CommentData) {
        commentCount = max(0, commentCount - 1)
        comments.remove(byId: comment)
    }
    
    mutating func addBookmark(_ bookmark: BookmarkData) {
        if bookmark.user.id == user.id {
            ownBookmarks.insert(byId: bookmark)
        }
        bookmarkCount += 1
    }
    
    mutating func deleteBookmark(_ bookmark: BookmarkData) {
        bookmarkCount = max(0, bookmarkCount - 1)
        ownBookmarks.remove(byId: bookmark)
    }
    
    mutating func addReaction(_ reaction: FeedsReactionData) {
        latestReactions.insert(byId: reaction)
        if reaction.user.id == user.id {
            ownReactions.insert(byId: reaction)
        }
        var reactionGroup = reactionGroups[reaction.type] ?? ReactionGroupData(count: 0, firstReactionAt: reaction.createdAt, lastReactionAt: reaction.createdAt)
        reactionGroup.increment(with: reaction.createdAt)
        reactionGroups[reaction.type] = reactionGroup
    }
}

// MARK: - Sorting

extension ActivityData {
    static let defaultSorting: @Sendable (ActivityData, ActivityData) -> Bool = { $0.createdAt > $1.createdAt }
}
