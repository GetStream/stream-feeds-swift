import Foundation
import StreamCore

public final class ActivityResponse: @unchecked Sendable, Codable, JSONEncodable, Hashable {
    public var attachments: [Attachment]
    public var bookmarkCount: Int
    public var commentCount: Int
    public var comments: [CommentResponse]
    public var createdAt: Date
    public var currentFeed: FeedResponse?
    public var custom: [String: RawJSON]
    public var deletedAt: Date?
    public var editedAt: Date?
    public var expiresAt: Date?
    public var feeds: [String]
    public var filterTags: [String]
    public var id: String
    public var interestTags: [String]
    public var latestReactions: [FeedsReactionResponse]
    public var location: ActivityLocation?
    public var mentionedUsers: [UserResponse]
    public var moderation: ModerationV2Response?
    public var ownBookmarks: [BookmarkResponse]
    public var ownReactions: [FeedsReactionResponse]
    public var parent: ActivityResponse?
    public var poll: PollResponseData?
    public var popularity: Int
    public var reactionGroups: [String: ReactionGroupResponse?]
    public var score: Float
    public var searchData: [String: RawJSON]
    public var shareCount: Int
    public var text: String?
    public var type: String
    public var updatedAt: Date
    public var user: UserResponse
    public var visibility: String
    public var visibilityTag: String?

    public init(attachments: [Attachment], bookmarkCount: Int, commentCount: Int, comments: [CommentResponse], createdAt: Date, currentFeed: FeedResponse? = nil, custom: [String: RawJSON], deletedAt: Date? = nil, editedAt: Date? = nil, expiresAt: Date? = nil, feeds: [String], filterTags: [String], id: String, interestTags: [String], latestReactions: [FeedsReactionResponse], location: ActivityLocation? = nil, mentionedUsers: [UserResponse], moderation: ModerationV2Response? = nil, ownBookmarks: [BookmarkResponse], ownReactions: [FeedsReactionResponse], parent: ActivityResponse? = nil, poll: PollResponseData? = nil, popularity: Int, reactionGroups: [String: ReactionGroupResponse?], score: Float, searchData: [String: RawJSON], shareCount: Int, text: String? = nil, type: String, updatedAt: Date, user: UserResponse, visibility: String, visibilityTag: String? = nil) {
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
        self.moderation = moderation
        self.ownBookmarks = ownBookmarks
        self.ownReactions = ownReactions
        self.parent = parent
        self.poll = poll
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
        case id
        case interestTags = "interest_tags"
        case latestReactions = "latest_reactions"
        case location
        case mentionedUsers = "mentioned_users"
        case moderation
        case ownBookmarks = "own_bookmarks"
        case ownReactions = "own_reactions"
        case parent
        case poll
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
        case visibilityTag = "visibility_tag"
    }

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
            lhs.id == rhs.id &&
            lhs.interestTags == rhs.interestTags &&
            lhs.latestReactions == rhs.latestReactions &&
            lhs.location == rhs.location &&
            lhs.mentionedUsers == rhs.mentionedUsers &&
            lhs.moderation == rhs.moderation &&
            lhs.ownBookmarks == rhs.ownBookmarks &&
            lhs.ownReactions == rhs.ownReactions &&
            lhs.parent == rhs.parent &&
            lhs.poll == rhs.poll &&
            lhs.popularity == rhs.popularity &&
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
        hasher.combine(id)
        hasher.combine(interestTags)
        hasher.combine(latestReactions)
        hasher.combine(location)
        hasher.combine(mentionedUsers)
        hasher.combine(moderation)
        hasher.combine(ownBookmarks)
        hasher.combine(ownReactions)
        hasher.combine(parent)
        hasher.combine(poll)
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
        hasher.combine(visibilityTag)
    }
}
