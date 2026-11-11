//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import CoreLocation
import Foundation
import StreamCore

public struct ActivityData: Identifiable, Equatable, Sendable {
    public let attachments: [Attachment]
    public private(set) var bookmarkCount: Int
    /// Collections referenced by the activity, keyed by collection reference (`name:id`).
    ///
    /// - Important: Empty when ``FeedQuery/enrichmentOptions`` has ``EnrichmentOptions/skipActivityCollections``, ``EnrichmentOptions/skipActivity`` or ``EnrichmentOptions/skipAll`` set to true.
    /// - Important: Leaves out references to collections that don't exist.
    public let collections: [String: CollectionData]
    public private(set) var commentCount: Int
    public private(set) var comments: [CommentData]
    public let createdAt: Date
    public private(set) var currentFeed: FeedData?
    public let custom: [String: RawJSON]
    public let deletedAt: Date?
    public let editedAt: Date?
    public let expiresAt: Date?
    public let feeds: [String]
    public let filterTags: [String]
    /// The number of reactions from users the current user follows, or only from mutual follows when ``FriendReactionsOptions/type`` is ``FriendReactionType/mutual``.
    ///
    /// - Important: Only set on feed reads when ``FeedQuery/friendReactionsOptions`` has `enabled` set to true.
    public private(set) var friendReactionCount: Int?
    /// Reactions from users the current user follows, or only from mutual follows when ``FriendReactionsOptions/type`` is ``FriendReactionType/mutual``.
    ///
    /// - Important: Only set on feed reads when ``FeedQuery/friendReactionsOptions`` has `enabled` set to true.
    public private(set) var friendReactions: [FeedsReactionData]?
    public private(set) var hidden: Bool
    public let id: String
    public let interestTags: [String]
    /// Whether the activity has been read.
    ///
    /// - Important: Only set by ``Feed/getOrCreate()`` and ``Feed/queryMoreActivities(limit:)`` for feed groups that track seen and read state. No request property turns it on.
    public private(set) var isRead: Bool?
    /// Whether the activity has been seen.
    ///
    /// - Important: Only set by ``Feed/getOrCreate()`` and ``Feed/queryMoreActivities(limit:)`` for feed groups that track seen and read state. No request property turns it on.
    public private(set) var isSeen: Bool?
    /// Whether the activity has been read or seen.
    ///
    /// - Important: Only set by ``Feed/getOrCreate()`` and ``Feed/queryMoreActivities(limit:)`` for feed groups that track seen and read state. No request property turns it on.
    public private(set) var isWatched: Bool?
    public private(set) var latestReactions: [FeedsReactionData]
    /// The most recent shares of the activity.
    ///
    /// - Important: Only set when activity shares are enabled for the organization.
    public let latestShares: [ShareData]?
    public let location: CLLocationCoordinate2D?
    public let mentionedUsers: [UserData]
    /// Metric counts of the activity, keyed by metric name.
    ///
    /// - Important: Only set when metrics were tracked for the activity.
    public let metrics: [String: Int]?
    public let moderation: ModerationV2Response?
    /// The latest moderation action taken on the activity.
    public let moderationAction: String?
    public let notificationContext: NotificationContext?
    /// The language code of the original ``text``.
    ///
    /// - Important: Only set when the activity is loaded with a language, such as ``FeedQuery/language``, and the activity has translations. Loading with a language doesn't translate the activity. It returns a translation only when the activity was translated to that language with ``Activity/translate(to:)``, ``Feed/translateActivity(id:to:)`` or from your server.
    public private(set) var originalLanguage: String?
    public private(set) var ownBookmarks: [BookmarkData]
    public private(set) var ownReactions: [FeedsReactionData]
    public var parent: ActivityData? { _parent?.getValue() }
    public internal(set) var poll: PollData?
    public let popularity: Int
    /// The 1-based position of the activity in the feed. Ranked feeds continue counting across pages. Other feeds restart at 1 on each page.
    ///
    /// - Important: Only set by ``Feed/getOrCreate()`` and ``Feed/queryMoreActivities(limit:)``, and only when the app's plan includes activity metrics and a feed group uses exploration or ranks For You by `impressions_bucket`. Not set for aggregated feeds. No request property turns it on.
    public private(set) var position: Int?
    /// Whether the activity is a shortened preview of premium content the current user can't access.
    public private(set) var preview: Bool
    public private(set) var reactionCount: Int
    public private(set) var reactionGroups: [String: ReactionGroupData]
    /// Codes explaining why the activity was shown, for example `following` or `popular`.
    ///
    /// - Important: Only set on For You feed reads when ``FeedQuery/enrichmentOptions`` has ``EnrichmentOptions/includeReasons`` set to true.
    public private(set) var reasons: [String]?
    /// Who can comment on the activity.
    public let restrictReplies: RestrictReplies
    public let score: Double
    /// Variable values used for ranking the activity.
    ///
    /// - Important: Only set on ranked feed reads when ``FeedQuery/enrichmentOptions`` has ``EnrichmentOptions/includeScoreVars`` set to true.
    public private(set) var scoreVariables: [String: RawJSON]?
    public let searchData: [String: RawJSON]
    /// The activity selector that provided the activity, for example `following` or `popular`.
    ///
    /// - Important: Only set on feed reads, and only by some activity selectors, such as `following` and `popular`.
    public private(set) var selectorSource: String?
    public let shareCount: Int
    public let text: String?
    /// The number of comments on the activity, excluding replies.
    ///
    /// - Important: Only set by ``Activity/get()``.
    public private(set) var topLevelCommentCount: Int?
    /// Automatic translations of ``text``, keyed by language code.
    ///
    /// - Important: Only set when the activity is loaded with a language, such as ``FeedQuery/language``, and the activity has translations. Loading with a language doesn't translate the activity. It returns a translation only when the activity was translated to that language with ``Activity/translate(to:)``, ``Feed/translateActivity(id:to:)`` or from your server. Holds the translation to that language and the original text.
    public private(set) var translations: [String: String]?
    public let type: String
    public let updatedAt: Date
    public let user: UserData
    public let visibility: ActivityDataVisibility
    public let visibilityTag: String?
    
    fileprivate let _parent: BoxedAny?
}

public typealias ActivityDataVisibility = ActivityVisibility

// MARK: - Translations

extension ActivityData {
    /// The translation of ``text`` to the given language code, or `nil` when there is none, or it is the same as the original text.
    public func translatedText(for language: String) -> String? {
        I18n.validTranslation(of: text, in: translations, for: language, originalLanguage: originalLanguage)
    }
}

// MARK: - Mutating the Data

extension Array where Element == ActivityData {
    func mergingExisting(_ incomingData: ActivityData) -> ActivityData {
        guard var existing = first(where: { $0.id == incomingData.id }) else { return incomingData }
        existing.merge(with: incomingData)
        return existing
    }
}

extension ActivityData {
    // MARK: - Activity and Its Reactions

    mutating func merge(with incomingData: ActivityData) {
        let ownBookmarks = ownBookmarks
        let ownReactions = ownReactions
        let friendReactionCount = friendReactionCount
        let isRead = isRead
        let isSeen = isSeen
        let isWatched = isWatched
        let friendReactions = friendReactions
        let hidden = hidden
        let position = position
        let preview = preview
        let reasons = reasons
        let scoreVariables = scoreVariables
        let selectorSource = selectorSource
        let text = text
        let topLevelCommentCount = topLevelCommentCount
        let translations = translations
        let originalLanguage = originalLanguage
        self = incomingData
        self.ownBookmarks = ownBookmarks
        self.ownReactions = ownReactions
        // Per-viewer, web-socket events always send false
        self.hidden = hidden
        self.preview = preview
        // Feed reads add these, and web-socket events don't carry them
        self.friendReactionCount = incomingData.friendReactionCount ?? friendReactionCount
        self.friendReactions = incomingData.friendReactions ?? friendReactions
        self.isRead = incomingData.isRead ?? isRead
        self.isSeen = incomingData.isSeen ?? isSeen
        self.isWatched = incomingData.isWatched ?? isWatched
        self.position = incomingData.position ?? position
        self.reasons = incomingData.reasons ?? reasons
        self.scoreVariables = incomingData.scoreVariables ?? scoreVariables
        self.selectorSource = incomingData.selectorSource ?? selectorSource
        self.topLevelCommentCount = incomingData.topLevelCommentCount ?? topLevelCommentCount
        // Web-socket events don't carry translations, and the backend clears them when the text changes
        if incomingData.translations == nil, incomingData.originalLanguage == nil, incomingData.text == text {
            self.originalLanguage = originalLanguage
            self.translations = translations
        }
    }
    
    mutating func merge(with incomingData: ActivityData, add reaction: FeedsReactionData, currentUserId: String) {
        merge(with: incomingData)
        guard reaction.user.id == currentUserId else { return }
        ownReactions.insert(byId: reaction)
    }
    
    mutating func merge(with incomingData: ActivityData, remove reaction: FeedsReactionData, currentUserId: String) {
        merge(with: incomingData)
        guard reaction.user.id == currentUserId else { return }
        ownReactions.remove(byId: reaction.id)
    }
    
    mutating func merge(with incomingData: ActivityData, update reaction: FeedsReactionData, currentUserId: String) {
        merge(with: incomingData)
        guard reaction.user.id == currentUserId else { return }
        ownReactions.replace(byId: reaction)
    }
    
    // MARK: - Activity Bookmarks
    
    mutating func merge(with incomingData: ActivityData, add bookmark: BookmarkData, currentUserId: String) {
        merge(with: incomingData)
        guard bookmark.user.id == currentUserId else { return }
        ownBookmarks.insert(byId: bookmark)
    }
    
    mutating func merge(with incomingData: ActivityData, remove bookmark: BookmarkData, currentUserId: String) {
        merge(with: incomingData)
        guard bookmark.user.id == currentUserId else { return }
        ownBookmarks.remove(byId: bookmark.id)
    }
    
    mutating func merge(with incomingData: ActivityData, update bookmark: BookmarkData, currentUserId: String) {
        merge(with: incomingData)
        guard bookmark.user.id == currentUserId else { return }
        ownBookmarks.replace(byId: bookmark)
    }
    
    /// Deleting a folder deletes its bookmarks, and the event only carries the folder.
    mutating func removeOwnBookmarks(inFolder folderId: String) {
        let count = ownBookmarks.count
        ownBookmarks.removeAll { $0.folder?.id == folderId }
        bookmarkCount = max(0, bookmarkCount - (count - ownBookmarks.count))
    }
    
    // MARK: - Activity Comments and Comment Reactions
    
    mutating func addComment(_ incomingData: CommentData) {
        if comments.insert(byId: incomingData) {
            commentCount += 1
        }
    }
    
    mutating func deleteComment(_ comment: CommentData) {
        if comments.remove(byId: comment.id) {
            commentCount = max(0, commentCount - 1)
        }
    }
    
    mutating func updateComment(_ incomingData: CommentData) {
        comments.updateFirstElement(where: { $0.id == incomingData.id }, changes: { $0.merge(with: incomingData) })
    }
    
    mutating func updateComment(_ incomingData: CommentData, add reaction: FeedsReactionData, currentUserId: String) {
        comments.updateFirstElement(
            where: { $0.id == incomingData.id },
            changes: { $0.merge(with: incomingData, add: reaction, currentUserId: currentUserId) }
        )
    }
    
    mutating func updateComment(_ incomingData: CommentData, remove reaction: FeedsReactionData, currentUserId: String) {
        comments.updateFirstElement(
            where: { $0.id == incomingData.id },
            changes: { $0.merge(with: incomingData, remove: reaction, currentUserId: currentUserId) }
        )
    }
    
    mutating func updateComment(_ incomingData: CommentData, update reaction: FeedsReactionData, currentUserId: String) {
        comments.updateFirstElement(
            where: { $0.id == incomingData.id },
            changes: { $0.merge(with: incomingData, update: reaction, currentUserId: currentUserId) }
        )
    }
    
    // MARK: - Current Feed Capabilities
    
    mutating func setFeedOwnCapabilities(_ capabilities: Set<FeedOwnCapability>) {
        currentFeed?.setOwnCapabilities(capabilities)
    }
    
    mutating func mergeFeedOwnCapabilities(from capabilitiesMap: [FeedId: Set<FeedOwnCapability>]) {
        guard let feedId = currentFeed?.feed else { return }
        guard let capabilities = capabilitiesMap[feedId] else { return }
        currentFeed?.setOwnCapabilities(capabilities)
    }
    
    func withFeedOwnCapabilities(from capabilitiesMap: [FeedId: Set<FeedOwnCapability>]) -> ActivityData {
        var updated = self
        updated.mergeFeedOwnCapabilities(from: capabilitiesMap)
        return updated
    }
}

// MARK: - Model Conversions

extension ActivityResponse {
    func toModel() -> ActivityData {
        ActivityData(
            attachments: attachments,
            bookmarkCount: bookmarkCount,
            collections: collections.compactMapValues { $0.status == .ok ? $0.collection.toModel() : nil },
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
            friendReactionCount: friendReactionCount,
            friendReactions: friendReactions?.map { $0.toModel() },
            hidden: hidden,
            id: id,
            interestTags: interestTags,
            isRead: isRead,
            isSeen: isSeen,
            isWatched: isWatched,
            latestReactions: latestReactions.map { $0.toModel() },
            latestShares: latestShares?.map { $0.toModel() },
            location: location.flatMap { CLLocationCoordinate2D(latitude: CLLocationDegrees($0.lat), longitude: CLLocationDegrees($0.lng)) },
            mentionedUsers: mentionedUsers.map { $0.toModel() },
            metrics: metrics,
            moderation: moderation,
            moderationAction: moderationAction,
            notificationContext: notificationContext,
            originalLanguage: I18n.originalLanguage(from: i18n),
            ownBookmarks: ownBookmarks.map { $0.toModel() },
            ownReactions: ownReactions.map { $0.toModel() },
            poll: poll?.toModel(),
            popularity: popularity,
            position: position,
            preview: preview,
            reactionCount: reactionCount,
            reactionGroups: reactionGroups.mapValues { $0.toModel() },
            reasons: reasons,
            restrictReplies: restrictReplies,
            score: score,
            scoreVariables: scoreVars,
            searchData: searchData,
            selectorSource: selectorSource,
            shareCount: shareCount,
            text: text,
            topLevelCommentCount: topLevelCommentCount,
            translations: I18n.translations(from: i18n),
            type: type,
            updatedAt: updatedAt,
            user: user.toModel(),
            visibility: visibility,
            visibilityTag: visibilityTag,
            _parent: BoxedAny(parent?.toModel())
        )
    }
}
