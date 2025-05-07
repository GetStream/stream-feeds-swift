import Foundation
import StreamCore

public final class Activity: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var attachments: [ActivityAttachment]?
    public var bookmarkCount: Int
    public var commentCount: Int
    public var comments: [Comment]?
    public var createdAt: Date
    public var currentFeed: Feed?
    public var custom: [String: RawJSON]?
    public var deletedAt: Date?
    public var editedAt: Date?
    public var expiresAt: Date?
    public var feeds: [String]
    public var filterTags: [String]?
    public var id: String
    public var interestTags: [String]?
    public var latestReactions: [ActivityReaction]?
    public var location: ActivityLocation?
    public var mentionedUsers: [UserResponse]?
    public var ownBookmarks: [Bookmark]?
    public var ownReactions: [ActivityReaction]?
    public var parent: BaseActivity?
    public var popularity: Int?
    public var reactionGroups: [String: ReactionGroup]?
    public var score: Float?
    public var searchData: [String: RawJSON]?
    public var shareCount: Int?
    public var text: String
    public var type: String
    public var updatedAt: Date
    public var user: UserResponse
    public var visibility: String

    public init(attachments: [ActivityAttachment]? = nil, bookmarkCount: Int, commentCount: Int, comments: [Comment]? = nil, createdAt: Date, currentFeed: Feed? = nil, custom: [String: RawJSON]? = nil, deletedAt: Date? = nil, editedAt: Date? = nil, expiresAt: Date? = nil, feeds: [String], filterTags: [String]? = nil, id: String, interestTags: [String]? = nil, latestReactions: [ActivityReaction]? = nil, location: ActivityLocation? = nil, mentionedUsers: [UserResponse]? = nil, ownBookmarks: [Bookmark]? = nil, ownReactions: [ActivityReaction]? = nil, parent: BaseActivity? = nil, popularity: Int? = nil, reactionGroups: [String: ReactionGroup]? = nil, score: Float? = nil, searchData: [String: RawJSON]? = nil, shareCount: Int? = nil, text: String, type: String, updatedAt: Date, user: UserResponse, visibility: String) {
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
        self.id = id
        self.interestTags = interestTags
        self.latestReactions = latestReactions
        self.location = location
        self.mentionedUsers = mentionedUsers
        self.ownBookmarks = ownBookmarks
        self.ownReactions = ownReactions
        self.parent = parent
        self.popularity = popularity
        self.reactionGroups = reactionGroups
        self.score = score
        self.searchData = searchData
        self.shareCount = shareCount
        self.text = text
        self.type = type
        self.updatedAt = updatedAt
        self.user = user
        self.visibility = visibility
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
        case id
        case interestTags = "interest_tags"
        case latestReactions = "latest_reactions"
        case location
        case mentionedUsers = "mentioned_users"
        case ownBookmarks = "own_bookmarks"
        case ownReactions = "own_reactions"
        case parent
        case popularity
        case reactionGroups = "reaction_groups"
        case score
        case searchData = "search_data"
        case shareCount = "share_count"
        case text
        case type
        case updatedAt = "updated_at"
        case user
        case visibility
    }

    public static func == (lhs: Activity, rhs: Activity) -> Bool {
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
            lhs.id == rhs.id &&
            lhs.interestTags == rhs.interestTags &&
            lhs.latestReactions == rhs.latestReactions &&
            lhs.location == rhs.location &&
            lhs.mentionedUsers == rhs.mentionedUsers &&
            lhs.ownBookmarks == rhs.ownBookmarks &&
            lhs.ownReactions == rhs.ownReactions &&
            lhs.parent == rhs.parent &&
            lhs.popularity == rhs.popularity &&
            lhs.reactionGroups == rhs.reactionGroups &&
            lhs.score == rhs.score &&
            lhs.searchData == rhs.searchData &&
            lhs.shareCount == rhs.shareCount &&
            lhs.text == rhs.text &&
            lhs.type == rhs.type &&
            lhs.updatedAt == rhs.updatedAt &&
            lhs.user == rhs.user &&
            lhs.visibility == rhs.visibility
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
        hasher.combine(id)
        hasher.combine(interestTags)
        hasher.combine(latestReactions)
        hasher.combine(location)
        hasher.combine(mentionedUsers)
        hasher.combine(ownBookmarks)
        hasher.combine(ownReactions)
        hasher.combine(parent)
        hasher.combine(popularity)
        hasher.combine(reactionGroups)
        hasher.combine(score)
        hasher.combine(searchData)
        hasher.combine(shareCount)
        hasher.combine(text)
        hasher.combine(type)
        hasher.combine(updatedAt)
        hasher.combine(user)
        hasher.combine(visibility)
    }
}
