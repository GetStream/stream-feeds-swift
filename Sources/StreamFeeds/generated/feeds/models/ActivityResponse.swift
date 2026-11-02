//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityResponse: Sendable, Decodable {
    /// Media attachments for the activity
    public let attachments: [Attachment]
    /// Number of bookmarks on the activity
    public let bookmarkCount: Int
    /// Number of comments on the activity
    public let commentCount: Int
    /// Latest 5 comments of this activity (comment replies excluded)
    public let comments: [CommentResponse]
    /// When the activity was created
    public let createdAt: Date
    public let currentFeed: FeedResponse?
    /// Custom data for the activity
    public let custom: [String: RawJSON]
    /// When the activity was deleted
    public let deletedAt: Date?
    /// When the activity was last edited
    public let editedAt: Date?
    /// When the activity will expire
    public let expiresAt: Date?
    /// List of feed IDs containing this activity
    public let feeds: [String]
    /// Tags for filtering
    public let filterTags: [String]
    /// If this activity is hidden by this user (using activity feedback)
    public let hidden: Bool
    /// Unique identifier for the activity
    public let id: String
    /// Tags for user interests
    public let interestTags: [String]
    /// Recent reactions to the activity
    public let latestReactions: [FeedsReactionResponse]
    public let location: Location?
    /// Users mentioned in the activity
    public let mentionedUsers: [UserResponse]
    public let moderation: ModerationV2Response?
    public let notificationContext: NotificationContext?
    /// Current user's bookmarks for this activity
    public let ownBookmarks: [BookmarkResponse]
    /// Current user's reactions to this activity
    public let ownReactions: [FeedsReactionResponse]
    public let parent: ActivityResponse?
    public let poll: PollResponseData?
    /// Popularity score of the activity
    public let popularity: Int
    /// Number of reactions to the activity
    public let reactionCount: Int
    /// Grouped reactions by type
    public let reactionGroups: [String: FeedsReactionGroupResponse]
    /// Ranking score for this activity
    public let score: Double
    /// Data for search indexing
    public let searchData: [String: RawJSON]
    /// Number of times the activity was shared
    public let shareCount: Int
    /// Text content of the activity
    public let text: String?
    /// Type of activity
    public let type: String
    /// When the activity was last updated
    public let updatedAt: Date
    /// User response object
    public let user: UserResponse
    /// Visibility setting for the activity. One of: public, private, tag
    public let visibility: ActivityVisibility
    /// If visibility is 'tag', this is the tag name
    public let visibilityTag: String?

    public init(attachments: [Attachment], bookmarkCount: Int, commentCount: Int, comments: [CommentResponse], createdAt: Date, currentFeed: FeedResponse? = nil, custom: [String: RawJSON], deletedAt: Date? = nil, editedAt: Date? = nil, expiresAt: Date? = nil, feeds: [String], filterTags: [String], hidden: Bool, id: String, interestTags: [String], latestReactions: [FeedsReactionResponse], location: Location? = nil, mentionedUsers: [UserResponse], moderation: ModerationV2Response? = nil, notificationContext: NotificationContext? = nil, ownBookmarks: [BookmarkResponse], ownReactions: [FeedsReactionResponse], parent: ActivityResponse? = nil, poll: PollResponseData? = nil, popularity: Int, reactionCount: Int, reactionGroups: [String: FeedsReactionGroupResponse], score: Double, searchData: [String: RawJSON], shareCount: Int, text: String? = nil, type: String, updatedAt: Date, user: UserResponse, visibility: ActivityVisibility, visibilityTag: String? = nil) {
        self.attachments = attachments
        self.bookmarkCount = bookmarkCount
        self.commentCount = commentCount
        self.comments = comments
        self.createdAt = createdAt
        self.currentFeed = currentFeed
        self.custom = custom
        self.deletedAt = deletedAt
        self.editedAt = editedAt
        self.expiresAt = expiresAt
        self.feeds = feeds
        self.filterTags = filterTags
        self.hidden = hidden
        self.id = id
        self.interestTags = interestTags
        self.latestReactions = latestReactions
        self.location = location
        self.mentionedUsers = mentionedUsers
        self.moderation = moderation
        self.notificationContext = notificationContext
        self.ownBookmarks = ownBookmarks
        self.ownReactions = ownReactions
        self.parent = parent
        self.poll = poll
        self.popularity = popularity
        self.reactionCount = reactionCount
        self.reactionGroups = reactionGroups
        self.score = score
        self.searchData = searchData
        self.shareCount = shareCount
        self.text = text
        self.type = type
        self.updatedAt = updatedAt
        self.user = user
        self.visibility = visibility
        self.visibilityTag = visibilityTag
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.attachments = try container.decode([Attachment].self, forKey: .attachments)
        self.bookmarkCount = try container.decode(Int.self, forKey: .bookmarkCount)
        self.commentCount = try container.decode(Int.self, forKey: .commentCount)
        self.comments = try container.decode([CommentResponse].self, forKey: .comments)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.currentFeed = try container.decodeIfPresent(FeedResponse.self, forKey: .currentFeed)
        self.custom = try container.decode([String: RawJSON].self, forKey: .custom)
        self.deletedAt = try container.decodeIfPresent(Date.self, forKey: .deletedAt)
        self.editedAt = try container.decodeIfPresent(Date.self, forKey: .editedAt)
        self.expiresAt = try container.decodeIfPresent(Date.self, forKey: .expiresAt)
        self.feeds = try container.decode([String].self, forKey: .feeds)
        self.filterTags = try container.decode([String].self, forKey: .filterTags)
        self.hidden = try container.decode(Bool.self, forKey: .hidden)
        self.id = try container.decode(String.self, forKey: .id)
        self.interestTags = try container.decode([String].self, forKey: .interestTags)
        self.latestReactions = try container.decode([FeedsReactionResponse].self, forKey: .latestReactions)
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.mentionedUsers = try container.decode([UserResponse].self, forKey: .mentionedUsers)
        self.moderation = try container.decodeIfPresent(ModerationV2Response.self, forKey: .moderation)
        self.notificationContext = try container.decodeIfPresent(NotificationContext.self, forKey: .notificationContext)
        self.ownBookmarks = try container.decode([BookmarkResponse].self, forKey: .ownBookmarks)
        self.ownReactions = try container.decode([FeedsReactionResponse].self, forKey: .ownReactions)
        self.parent = try container.decodeIfPresent(ActivityResponse.self, forKey: .parent)
        self.poll = try container.decodeIfPresent(PollResponseData.self, forKey: .poll)
        self.popularity = try container.decode(Int.self, forKey: .popularity)
        self.reactionCount = try container.decode(Int.self, forKey: .reactionCount)
        self.reactionGroups = try container.decode([String: FeedsReactionGroupResponse].self, forKey: .reactionGroups)
        self.score = try container.decode(Double.self, forKey: .score)
        self.searchData = try container.decode([String: RawJSON].self, forKey: .searchData)
        self.shareCount = try container.decode(Int.self, forKey: .shareCount)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.type = try container.decode(String.self, forKey: .type)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decode(UserResponse.self, forKey: .user)
        self.visibility = try container.decode(ActivityVisibility.self, forKey: .visibility)
        self.visibilityTag = try container.decodeIfPresent(String.self, forKey: .visibilityTag)
    }
}

extension ActivityResponse: Hashable {
    public static func == (lhs: ActivityResponse, rhs: ActivityResponse) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.bookmarkCount == rhs.bookmarkCount &&
            lhs.commentCount == rhs.commentCount &&
            lhs.comments == rhs.comments &&
            lhs.createdAt == rhs.createdAt &&
            lhs.currentFeed == rhs.currentFeed &&
            lhs.custom == rhs.custom &&
            lhs.deletedAt == rhs.deletedAt &&
            lhs.editedAt == rhs.editedAt &&
            lhs.expiresAt == rhs.expiresAt &&
            lhs.feeds == rhs.feeds &&
            lhs.filterTags == rhs.filterTags &&
            lhs.hidden == rhs.hidden &&
            lhs.id == rhs.id &&
            lhs.interestTags == rhs.interestTags &&
            lhs.latestReactions == rhs.latestReactions &&
            lhs.location == rhs.location &&
            lhs.mentionedUsers == rhs.mentionedUsers &&
            lhs.moderation == rhs.moderation &&
            lhs.notificationContext == rhs.notificationContext &&
            lhs.ownBookmarks == rhs.ownBookmarks &&
            lhs.ownReactions == rhs.ownReactions &&
            lhs.parent == rhs.parent &&
            lhs.poll == rhs.poll &&
            lhs.popularity == rhs.popularity &&
            lhs.reactionCount == rhs.reactionCount &&
            lhs.reactionGroups == rhs.reactionGroups &&
            lhs.score == rhs.score &&
            lhs.searchData == rhs.searchData &&
            lhs.shareCount == rhs.shareCount &&
            lhs.text == rhs.text &&
            lhs.type == rhs.type &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user &&
            lhs.visibility == rhs.visibility &&
            lhs.visibilityTag == rhs.visibilityTag
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(bookmarkCount)
        hasher.combine(commentCount)
        hasher.combine(comments)
        hasher.combine(createdAt)
        hasher.combine(currentFeed)
        hasher.combine(custom)
        hasher.combine(deletedAt)
        hasher.combine(editedAt)
        hasher.combine(expiresAt)
        hasher.combine(feeds)
        hasher.combine(filterTags)
        hasher.combine(hidden)
        hasher.combine(id)
        hasher.combine(interestTags)
        hasher.combine(latestReactions)
        hasher.combine(location)
        hasher.combine(mentionedUsers)
        hasher.combine(moderation)
        hasher.combine(notificationContext)
        hasher.combine(ownBookmarks)
        hasher.combine(ownReactions)
        hasher.combine(parent)
        hasher.combine(poll)
        hasher.combine(popularity)
        hasher.combine(reactionCount)
        hasher.combine(reactionGroups)
        hasher.combine(score)
        hasher.combine(searchData)
        hasher.combine(shareCount)
        hasher.combine(text)
        hasher.combine(type)
        hasher.combine(updatedAt)
        hasher.combine(user)
        hasher.combine(visibility)
        hasher.combine(visibilityTag)
    }
}
