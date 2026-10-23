//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityResponseRestrictReplies: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let everyone = ActivityResponseRestrictReplies(rawValue: "everyone")
    public static let nobody = ActivityResponseRestrictReplies(rawValue: "nobody")
    public static let peopleIFollow = ActivityResponseRestrictReplies(rawValue: "people_i_follow")
}

public final class ActivityResponseVisibility: RawRepresentable, Codable, Hashable, Sendable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let `private` = ActivityResponseVisibility(rawValue: "private")
    public static let `public` = ActivityResponseVisibility(rawValue: "public")
    public static let tag = ActivityResponseVisibility(rawValue: "tag")
}

public final class ActivityResponse: Sendable, Codable, JSONEncodable {
    /// Media attachments for the activity
    public let attachments: [Attachment]
    /// Number of bookmarks on the activity
    public let bookmarkCount: Int
    /// Enriched collection data referenced by this activity
    public let collections: [String: EnrichedCollectionResponse]
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
    /// Total count of reactions from friends on this activity
    public let friendReactionCount: Int?
    /// Reactions from users the current user follows or has mutual follows with
    public let friendReactions: [FeedsReactionResponse]?
    /// If this activity is hidden by this user (using activity feedback)
    public let hidden: Bool
    public let i18n: [String: String]?
    /// Unique identifier for the activity
    public let id: String
    /// Tags for user interests
    public let interestTags: [String]
    /// Whether this activity has been read. Only set for feed groups with notification config (track_seen/track_read enabled).
    public let isRead: Bool?
    /// Whether this activity has been seen. Only set for feed groups with notification config (track_seen/track_read enabled).
    public let isSeen: Bool?
    public let isWatched: Bool?
    /// Recent reactions to the activity
    public let latestReactions: [FeedsReactionResponse]
    /// Recent shares of the activity, one entry per share (org-gated)
    public let latestShares: [ShareResponse]?
    public let location: Location?
    /// Users mentioned in the activity
    public let mentionedUsers: [UserResponse]
    public let metrics: [String: Int]?
    public let moderation: ModerationV2Response?
    public let moderationAction: String?
    public let notificationContext: NotificationContext?
    /// Current user's bookmarks for this activity
    public let ownBookmarks: [BookmarkResponse]
    /// Current user's reactions to this activity
    public let ownReactions: [FeedsReactionResponse]
    public let parent: ActivityResponse?
    public let poll: PollResponseData?
    /// Popularity score of the activity
    public let popularity: Int
    /// If this activity is obfuscated for this user. For premium content where you want to show a preview
    public let preview: Bool
    /// Number of reactions to the activity
    public let reactionCount: Int
    /// Grouped reactions by type
    public let reactionGroups: [String: FeedsReactionGroupResponse]
    /// Controls who can add comments/replies to this activity. One of: everyone, people_i_follow, nobody
    public let restrictReplies: ActivityResponseRestrictReplies
    /// Ranking score for this activity
    public let score: Double
    /// Variable values used at ranking time. Only included when include_score_vars is enabled in enrichment options.
    public let scoreVars: [String: RawJSON]?
    /// Data for search indexing
    public let searchData: [String: RawJSON]
    /// Which activity selector provided this activity (e.g., 'following', 'popular', 'interest'). Only set when using multiple activity selectors with ranking.
    public let selectorSource: String?
    /// Number of times the activity was shared
    public let shareCount: Int
    /// Text content of the activity
    public let text: String?
    /// Number of top-level comments (comments directly on the activity, excluding replies). Only returned by GetActivity when include_top_level_comment_count=true; never set on feed reads or events. Same status/deletion rules as comment_count; not adjusted per viewer.
    public let topLevelCommentCount: Int?
    /// Type of activity
    public let type: String
    /// When the activity was last updated
    public let updatedAt: Date
    /// User response object
    public let user: UserResponse
    /// Visibility setting for the activity. One of: public, private, tag
    public let visibility: ActivityResponseVisibility
    /// If visibility is 'tag', this is the tag name
    public let visibilityTag: String?

    public init(attachments: [Attachment], bookmarkCount: Int, collections: [String: EnrichedCollectionResponse], commentCount: Int, comments: [CommentResponse], createdAt: Date, currentFeed: FeedResponse? = nil, custom: [String: RawJSON], deletedAt: Date? = nil, editedAt: Date? = nil, expiresAt: Date? = nil, feeds: [String], filterTags: [String], friendReactionCount: Int? = nil, friendReactions: [FeedsReactionResponse]? = nil, hidden: Bool, i18n: [String: String]? = nil, id: String, interestTags: [String], isRead: Bool? = nil, isSeen: Bool? = nil, isWatched: Bool? = nil, latestReactions: [FeedsReactionResponse], latestShares: [ShareResponse]? = nil, location: Location? = nil, mentionedUsers: [UserResponse], metrics: [String: Int]? = nil, moderation: ModerationV2Response? = nil, moderationAction: String? = nil, notificationContext: NotificationContext? = nil, ownBookmarks: [BookmarkResponse], ownReactions: [FeedsReactionResponse], parent: ActivityResponse? = nil, poll: PollResponseData? = nil, popularity: Int, preview: Bool, reactionCount: Int, reactionGroups: [String: FeedsReactionGroupResponse], restrictReplies: ActivityResponseRestrictReplies, score: Double, scoreVars: [String: RawJSON]? = nil, searchData: [String: RawJSON], selectorSource: String? = nil, shareCount: Int, text: String? = nil, topLevelCommentCount: Int? = nil, type: String, updatedAt: Date, user: UserResponse, visibility: ActivityResponseVisibility, visibilityTag: String? = nil) {
        self.attachments = attachments
        self.bookmarkCount = bookmarkCount
        self.collections = collections
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
        self.friendReactionCount = friendReactionCount
        self.friendReactions = friendReactions
        self.hidden = hidden
        self.i18n = i18n
        self.id = id
        self.interestTags = interestTags
        self.isRead = isRead
        self.isSeen = isSeen
        self.isWatched = isWatched
        self.latestReactions = latestReactions
        self.latestShares = latestShares
        self.location = location
        self.mentionedUsers = mentionedUsers
        self.metrics = metrics
        self.moderation = moderation
        self.moderationAction = moderationAction
        self.notificationContext = notificationContext
        self.ownBookmarks = ownBookmarks
        self.ownReactions = ownReactions
        self.parent = parent
        self.poll = poll
        self.popularity = popularity
        self.preview = preview
        self.reactionCount = reactionCount
        self.reactionGroups = reactionGroups
        self.restrictReplies = restrictReplies
        self.score = score
        self.scoreVars = scoreVars
        self.searchData = searchData
        self.selectorSource = selectorSource
        self.shareCount = shareCount
        self.text = text
        self.topLevelCommentCount = topLevelCommentCount
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
        self.collections = try container.decode([String: EnrichedCollectionResponse].self, forKey: .collections)
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
        self.friendReactionCount = try container.decodeIfPresent(Int.self, forKey: .friendReactionCount)
        self.friendReactions = try container.decodeIfPresent([FeedsReactionResponse].self, forKey: .friendReactions)
        self.hidden = try container.decode(Bool.self, forKey: .hidden)
        self.i18n = try container.decodeIfPresent([String: String].self, forKey: .i18n)
        self.id = try container.decode(String.self, forKey: .id)
        self.interestTags = try container.decode([String].self, forKey: .interestTags)
        self.isRead = try container.decodeIfPresent(Bool.self, forKey: .isRead)
        self.isSeen = try container.decodeIfPresent(Bool.self, forKey: .isSeen)
        self.isWatched = try container.decodeIfPresent(Bool.self, forKey: .isWatched)
        self.latestReactions = try container.decode([FeedsReactionResponse].self, forKey: .latestReactions)
        self.latestShares = try container.decodeIfPresent([ShareResponse].self, forKey: .latestShares)
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.mentionedUsers = try container.decode([UserResponse].self, forKey: .mentionedUsers)
        self.metrics = try container.decodeIfPresent([String: Int].self, forKey: .metrics)
        self.moderation = try container.decodeIfPresent(ModerationV2Response.self, forKey: .moderation)
        self.moderationAction = try container.decodeIfPresent(String.self, forKey: .moderationAction)
        self.notificationContext = try container.decodeIfPresent(NotificationContext.self, forKey: .notificationContext)
        self.ownBookmarks = try container.decode([BookmarkResponse].self, forKey: .ownBookmarks)
        self.ownReactions = try container.decode([FeedsReactionResponse].self, forKey: .ownReactions)
        self.parent = try container.decodeIfPresent(ActivityResponse.self, forKey: .parent)
        self.poll = try container.decodeIfPresent(PollResponseData.self, forKey: .poll)
        self.popularity = try container.decode(Int.self, forKey: .popularity)
        self.preview = try container.decode(Bool.self, forKey: .preview)
        self.reactionCount = try container.decode(Int.self, forKey: .reactionCount)
        self.reactionGroups = try container.decode([String: FeedsReactionGroupResponse].self, forKey: .reactionGroups)
        self.restrictReplies = try container.decode(ActivityResponseRestrictReplies.self, forKey: .restrictReplies)
        self.score = try container.decode(Double.self, forKey: .score)
        self.scoreVars = try container.decodeIfPresent([String: RawJSON].self, forKey: .scoreVars)
        self.searchData = try container.decode([String: RawJSON].self, forKey: .searchData)
        self.selectorSource = try container.decodeIfPresent(String.self, forKey: .selectorSource)
        self.shareCount = try container.decode(Int.self, forKey: .shareCount)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.topLevelCommentCount = try container.decodeIfPresent(Int.self, forKey: .topLevelCommentCount)
        self.type = try container.decode(String.self, forKey: .type)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        self.user = try container.decode(UserResponse.self, forKey: .user)
        self.visibility = try container.decode(ActivityResponseVisibility.self, forKey: .visibility)
        self.visibilityTag = try container.decodeIfPresent(String.self, forKey: .visibilityTag)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encode(attachments, forKey: .attachments)
        try container.encode(bookmarkCount, forKey: .bookmarkCount)
        try container.encode(collections, forKey: .collections)
        try container.encode(commentCount, forKey: .commentCount)
        try container.encode(comments, forKey: .comments)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(currentFeed, forKey: .currentFeed)
        try container.encode(custom, forKey: .custom)
        try container.encodeIfPresent(deletedAt, forKey: .deletedAt)
        try container.encodeIfPresent(editedAt, forKey: .editedAt)
        try container.encodeIfPresent(expiresAt, forKey: .expiresAt)
        try container.encode(feeds, forKey: .feeds)
        try container.encode(filterTags, forKey: .filterTags)
        try container.encodeIfPresent(friendReactionCount, forKey: .friendReactionCount)
        try container.encodeIfPresent(friendReactions, forKey: .friendReactions)
        try container.encode(hidden, forKey: .hidden)
        try container.encodeIfPresent(i18n, forKey: .i18n)
        try container.encode(id, forKey: .id)
        try container.encode(interestTags, forKey: .interestTags)
        try container.encodeIfPresent(isRead, forKey: .isRead)
        try container.encodeIfPresent(isSeen, forKey: .isSeen)
        try container.encodeIfPresent(isWatched, forKey: .isWatched)
        try container.encode(latestReactions, forKey: .latestReactions)
        try container.encodeIfPresent(latestShares, forKey: .latestShares)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encode(mentionedUsers, forKey: .mentionedUsers)
        try container.encodeIfPresent(metrics, forKey: .metrics)
        try container.encodeIfPresent(moderation, forKey: .moderation)
        try container.encodeIfPresent(moderationAction, forKey: .moderationAction)
        try container.encodeIfPresent(notificationContext, forKey: .notificationContext)
        try container.encode(ownBookmarks, forKey: .ownBookmarks)
        try container.encode(ownReactions, forKey: .ownReactions)
        try container.encodeIfPresent(parent, forKey: .parent)
        try container.encodeIfPresent(poll, forKey: .poll)
        try container.encode(popularity, forKey: .popularity)
        try container.encode(preview, forKey: .preview)
        try container.encode(reactionCount, forKey: .reactionCount)
        try container.encode(reactionGroups, forKey: .reactionGroups)
        try container.encode(restrictReplies, forKey: .restrictReplies)
        try container.encode(score, forKey: .score)
        try container.encodeIfPresent(scoreVars, forKey: .scoreVars)
        try container.encode(searchData, forKey: .searchData)
        try container.encodeIfPresent(selectorSource, forKey: .selectorSource)
        try container.encode(shareCount, forKey: .shareCount)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(topLevelCommentCount, forKey: .topLevelCommentCount)
        try container.encode(type, forKey: .type)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(user, forKey: .user)
        try container.encode(visibility, forKey: .visibility)
        try container.encodeIfPresent(visibilityTag, forKey: .visibilityTag)
    }
}

extension ActivityResponse: Hashable {
    public static func == (lhs: ActivityResponse, rhs: ActivityResponse) -> Bool {
        lhs.attachments == rhs.attachments &&
            lhs.bookmarkCount == rhs.bookmarkCount &&
            lhs.collections == rhs.collections &&
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
            lhs.friendReactionCount == rhs.friendReactionCount &&
            lhs.friendReactions == rhs.friendReactions &&
            lhs.hidden == rhs.hidden &&
            lhs.i18n == rhs.i18n &&
            lhs.id == rhs.id &&
            lhs.interestTags == rhs.interestTags &&
            lhs.isRead == rhs.isRead &&
            lhs.isSeen == rhs.isSeen &&
            lhs.isWatched == rhs.isWatched &&
            lhs.latestReactions == rhs.latestReactions &&
            lhs.latestShares == rhs.latestShares &&
            lhs.location == rhs.location &&
            lhs.mentionedUsers == rhs.mentionedUsers &&
            lhs.metrics == rhs.metrics &&
            lhs.moderation == rhs.moderation &&
            lhs.moderationAction == rhs.moderationAction &&
            lhs.notificationContext == rhs.notificationContext &&
            lhs.ownBookmarks == rhs.ownBookmarks &&
            lhs.ownReactions == rhs.ownReactions &&
            lhs.parent == rhs.parent &&
            lhs.poll == rhs.poll &&
            lhs.popularity == rhs.popularity &&
            lhs.preview == rhs.preview &&
            lhs.reactionCount == rhs.reactionCount &&
            lhs.reactionGroups == rhs.reactionGroups &&
            lhs.restrictReplies == rhs.restrictReplies &&
            lhs.score == rhs.score &&
            lhs.scoreVars == rhs.scoreVars &&
            lhs.searchData == rhs.searchData &&
            lhs.selectorSource == rhs.selectorSource &&
            lhs.shareCount == rhs.shareCount &&
            lhs.text == rhs.text &&
            lhs.topLevelCommentCount == rhs.topLevelCommentCount &&
            lhs.type == rhs.type &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user &&
            lhs.visibility == rhs.visibility &&
            lhs.visibilityTag == rhs.visibilityTag
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(attachments)
        hasher.combine(bookmarkCount)
        hasher.combine(collections)
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
        hasher.combine(friendReactionCount)
        hasher.combine(friendReactions)
        hasher.combine(hidden)
        hasher.combine(i18n)
        hasher.combine(id)
        hasher.combine(interestTags)
        hasher.combine(isRead)
        hasher.combine(isSeen)
        hasher.combine(isWatched)
        hasher.combine(latestReactions)
        hasher.combine(latestShares)
        hasher.combine(location)
        hasher.combine(mentionedUsers)
        hasher.combine(metrics)
        hasher.combine(moderation)
        hasher.combine(moderationAction)
        hasher.combine(notificationContext)
        hasher.combine(ownBookmarks)
        hasher.combine(ownReactions)
        hasher.combine(parent)
        hasher.combine(poll)
        hasher.combine(popularity)
        hasher.combine(preview)
        hasher.combine(reactionCount)
        hasher.combine(reactionGroups)
        hasher.combine(restrictReplies)
        hasher.combine(score)
        hasher.combine(scoreVars)
        hasher.combine(searchData)
        hasher.combine(selectorSource)
        hasher.combine(shareCount)
        hasher.combine(text)
        hasher.combine(topLevelCommentCount)
        hasher.combine(type)
        hasher.combine(updatedAt)
        hasher.combine(user)
        hasher.combine(visibility)
        hasher.combine(visibilityTag)
    }
}
