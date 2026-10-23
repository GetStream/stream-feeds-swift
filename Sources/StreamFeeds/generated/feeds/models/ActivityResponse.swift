//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public final class ActivityResponse: @unchecked Sendable, Codable, JSONEncodable {
    public enum ActivityResponseRestrictReplies: String, Sendable, Codable, CaseIterable {
        case everyone
        case nobody
        case peopleIFollow = "people_i_follow"
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }
    
    public enum ActivityResponseVisibility: String, Sendable, Codable, CaseIterable {
        case `private`
        case `public`
        case tag
        case unknown = "_unknown"

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let decodedValue = try? container.decode(String.self),
               let value = Self(rawValue: decodedValue) {
                self = value
            } else {
                self = .unknown
            }
        }
    }

    /// Media attachments for the activity
    public var attachments: [Attachment]
    /// Number of bookmarks on the activity
    public var bookmarkCount: Int
    /// Enriched collection data referenced by this activity
    public var collections: [String: EnrichedCollectionResponse]
    /// Number of comments on the activity
    public var commentCount: Int
    /// Latest 5 comments of this activity (comment replies excluded)
    public var comments: [CommentResponse]
    /// When the activity was created
    public var createdAt: Date
    public var currentFeed: FeedResponse?
    /// Custom data for the activity
    public var custom: [String: RawJSON]
    /// When the activity was deleted
    public var deletedAt: Date?
    /// When the activity was last edited
    public var editedAt: Date?
    /// When the activity will expire
    public var expiresAt: Date?
    /// List of feed IDs containing this activity
    public var feeds: [String]
    /// Tags for filtering
    public var filterTags: [String]
    /// Total count of reactions from friends on this activity
    public var friendReactionCount: Int?
    /// Reactions from users the current user follows or has mutual follows with
    public var friendReactions: [FeedsReactionResponse]?
    /// If this activity is hidden by this user (using activity feedback)
    public var hidden: Bool
    public var i18n: [String: String]?
    /// Unique identifier for the activity
    public var id: String
    /// Tags for user interests
    public var interestTags: [String]
    /// Whether this activity has been read. Only set for feed groups with notification config (track_seen/track_read enabled).
    public var isRead: Bool?
    /// Whether this activity has been seen. Only set for feed groups with notification config (track_seen/track_read enabled).
    public var isSeen: Bool?
    public var isWatched: Bool?
    /// Recent reactions to the activity
    public var latestReactions: [FeedsReactionResponse]
    /// Recent shares of the activity, one entry per share (org-gated)
    public var latestShares: [ShareResponse]?
    public var location: Location?
    /// Users mentioned in the activity
    public var mentionedUsers: [UserResponse]
    public var metrics: [String: Int]?
    public var moderation: ModerationV2Response?
    public var moderationAction: String?
    public var notificationContext: NotificationContext?
    /// Current user's bookmarks for this activity
    public var ownBookmarks: [BookmarkResponse]
    /// Current user's reactions to this activity
    public var ownReactions: [FeedsReactionResponse]
    public var parent: ActivityResponse?
    public var poll: PollResponseData?
    /// Popularity score of the activity
    public var popularity: Int
    /// If this activity is obfuscated for this user. For premium content where you want to show a preview
    public var preview: Bool
    /// Number of reactions to the activity
    public var reactionCount: Int
    /// Grouped reactions by type
    public var reactionGroups: [String: FeedsReactionGroupResponse]
    /// Controls who can add comments/replies to this activity. One of: everyone, people_i_follow, nobody
    public var restrictReplies: ActivityResponseRestrictReplies
    /// Ranking score for this activity
    public var score: Float
    /// Variable values used at ranking time. Only included when include_score_vars is enabled in enrichment options.
    public var scoreVars: [String: RawJSON]?
    /// Data for search indexing
    public var searchData: [String: RawJSON]
    /// Which activity selector provided this activity (e.g., 'following', 'popular', 'interest'). Only set when using multiple activity selectors with ranking.
    public var selectorSource: String?
    /// Number of times the activity was shared
    public var shareCount: Int
    /// Text content of the activity
    public var text: String?
    /// Number of top-level comments (comments directly on the activity, excluding replies). Only returned by GetActivity when include_top_level_comment_count=true; never set on feed reads or events. Same status/deletion rules as comment_count; not adjusted per viewer.
    public var topLevelCommentCount: Int?
    /// Type of activity
    public var type: String
    /// When the activity was last updated
    public var updatedAt: Date
    /// User response object
    public var user: UserResponse
    /// Visibility setting for the activity. One of: public, private, tag
    public var visibility: ActivityResponseVisibility
    /// If visibility is 'tag', this is the tag name
    public var visibilityTag: String?

    public init(
        attachments: [Attachment],
        bookmarkCount: Int,
        collections: [String: EnrichedCollectionResponse],
        commentCount: Int,
        comments: [CommentResponse],
        createdAt: Date,
        currentFeed: FeedResponse? = nil,
        custom: [String: RawJSON],
        deletedAt: Date? = nil,
        editedAt: Date? = nil,
        expiresAt: Date? = nil,
        feeds: [String],
        filterTags: [String],
        friendReactionCount: Int? = nil,
        friendReactions: [FeedsReactionResponse]? = nil,
        hidden: Bool,
        i18n: [String: String]? = nil,
        id: String,
        interestTags: [String],
        isRead: Bool? = nil,
        isSeen: Bool? = nil,
        isWatched: Bool? = nil,
        latestReactions: [FeedsReactionResponse],
        latestShares: [ShareResponse]? = nil,
        location: Location? = nil,
        mentionedUsers: [UserResponse],
        metrics: [String: Int]? = nil,
        moderation: ModerationV2Response? = nil,
        moderationAction: String? = nil,
        notificationContext: NotificationContext? = nil,
        ownBookmarks: [BookmarkResponse],
        ownReactions: [FeedsReactionResponse],
        parent: ActivityResponse? = nil,
        poll: PollResponseData? = nil,
        popularity: Int,
        preview: Bool,
        reactionCount: Int,
        reactionGroups: [String: FeedsReactionGroupResponse],
        restrictReplies: ActivityResponseRestrictReplies,
        score: Float,
        scoreVars: [String: RawJSON]? = nil,
        searchData: [String: RawJSON],
        selectorSource: String? = nil,
        shareCount: Int,
        text: String? = nil,
        topLevelCommentCount: Int? = nil,
        type: String,
        updatedAt: Date,
        user: UserResponse,
        visibility: ActivityResponseVisibility,
        visibilityTag: String? = nil
    ) {
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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case bookmarkCount = "bookmark_count"
        case collections
        case commentCount = "comment_count"
        case comments
        case createdAt = "created_at"
        case currentFeed = "current_feed"
        case custom
        case deletedAt = "deleted_at"
        case editedAt = "edited_at"
        case expiresAt = "expires_at"
        case feeds
        case filterTags = "filter_tags"
        case friendReactionCount = "friend_reaction_count"
        case friendReactions = "friend_reactions"
        case hidden
        case i18n
        case id
        case interestTags = "interest_tags"
        case isRead = "is_read"
        case isSeen = "is_seen"
        case isWatched = "is_watched"
        case latestReactions = "latest_reactions"
        case latestShares = "latest_shares"
        case location
        case mentionedUsers = "mentioned_users"
        case metrics
        case moderation
        case moderationAction = "moderation_action"
        case notificationContext = "notification_context"
        case ownBookmarks = "own_bookmarks"
        case ownReactions = "own_reactions"
        case parent
        case poll
        case popularity
        case preview
        case reactionCount = "reaction_count"
        case reactionGroups = "reaction_groups"
        case restrictReplies = "restrict_replies"
        case score
        case scoreVars = "score_vars"
        case searchData = "search_data"
        case selectorSource = "selector_source"
        case shareCount = "share_count"
        case text
        case topLevelCommentCount = "top_level_comment_count"
        case type
        case updatedAt = "updated_at"
        case user
        case visibility
        case visibilityTag = "visibility_tag"
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
