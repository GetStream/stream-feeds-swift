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
    /// If this activity is hidden by this user (using activity feedback)
    public var hidden: Bool
    /// Unique identifier for the activity
    public var id: String
    /// Tags for user interests
    public var interestTags: [String]
    /// Recent reactions to the activity
    public var latestReactions: [FeedsReactionResponse]
    public var location: Location?
    /// Users mentioned in the activity
    public var mentionedUsers: [UserResponse]
    public var moderation: ModerationV2Response?
    public var notificationContext: NotificationContext?
    /// Current user's bookmarks for this activity
    public var ownBookmarks: [BookmarkResponse]
    /// Current user's reactions to this activity
    public var ownReactions: [FeedsReactionResponse]
    public var parent: ActivityResponse?
    public var poll: PollResponseData?
    /// Popularity score of the activity
    public var popularity: Int
    /// Number of reactions to the activity
    public var reactionCount: Int
    /// Grouped reactions by type
    public var reactionGroups: [String: FeedsReactionGroupResponse]
    /// Ranking score for this activity
    public var score: Float
    /// Data for search indexing
    public var searchData: [String: RawJSON]
    /// Number of times the activity was shared
    public var shareCount: Int
    /// Text content of the activity
    public var text: String?
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

    public init(attachments: [Attachment], bookmarkCount: Int, commentCount: Int, comments: [CommentResponse], createdAt: Date, currentFeed: FeedResponse? = nil, custom: [String: RawJSON], deletedAt: Date? = nil, editedAt: Date? = nil, expiresAt: Date? = nil, feeds: [String], filterTags: [String], hidden: Bool, id: String, interestTags: [String], latestReactions: [FeedsReactionResponse], location: Location? = nil, mentionedUsers: [UserResponse], moderation: ModerationV2Response? = nil, notificationContext: NotificationContext? = nil, ownBookmarks: [BookmarkResponse], ownReactions: [FeedsReactionResponse], parent: ActivityResponse? = nil, poll: PollResponseData? = nil, popularity: Int, reactionCount: Int, reactionGroups: [String: FeedsReactionGroupResponse], score: Float, searchData: [String: RawJSON], shareCount: Int, text: String? = nil, type: String, updatedAt: Date, user: UserResponse, visibility: ActivityResponseVisibility, visibilityTag: String? = nil) {
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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attachments
        case bookmarkCount = "bookmark_count"
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
        case hidden
        case id
        case interestTags = "interest_tags"
        case latestReactions = "latest_reactions"
        case location
        case mentionedUsers = "mentioned_users"
        case moderation
        case notificationContext = "notification_context"
        case ownBookmarks = "own_bookmarks"
        case ownReactions = "own_reactions"
        case parent
        case poll
        case popularity
        case reactionCount = "reaction_count"
        case reactionGroups = "reaction_groups"
        case score
        case searchData = "search_data"
        case shareCount = "share_count"
        case text
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
