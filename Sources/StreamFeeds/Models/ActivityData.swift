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
    /// - Note: Empty when ``FeedQuery/enrichmentOptions`` has ``EnrichmentOptions/skipActivityCollections`` set to true.
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
    /// - Note: Only set on feed reads when ``FeedQuery/friendReactionsOptions`` has `enabled` set to true.
    public private(set) var friendReactionCount: Int?
    /// Reactions from users the current user follows, or only from mutual follows when ``FriendReactionsOptions/type`` is ``FriendReactionType/mutual``.
    ///
    /// - Note: Only set on feed reads when ``FeedQuery/friendReactionsOptions`` has `enabled` set to true.
    public private(set) var friendReactions: [FeedsReactionData]?
    public let hidden: Bool
    public let id: String
    public let interestTags: [String]
    public private(set) var latestReactions: [FeedsReactionData]
    public let location: CLLocationCoordinate2D?
    public let mentionedUsers: [UserData]
    public let moderation: ModerationV2Response?
    public let notificationContext: NotificationContext?
    public private(set) var ownBookmarks: [BookmarkData]
    public private(set) var ownReactions: [FeedsReactionData]
    public var parent: ActivityData? { _parent?.getValue() }
    public internal(set) var poll: PollData?
    public let popularity: Int
    /// The 1-based position of the activity in a ranked feed, continuing across pages.
    ///
    /// - Note: Only set by ``Feed/getOrCreate()`` and ``Feed/queryMoreActivities(limit:)``, and only when the app's plan includes activity metrics and a feed group uses exploration or ranks For You by `impressions_bucket`. No request property turns it on.
    public private(set) var position: Int?
    public private(set) var reactionCount: Int
    public private(set) var reactionGroups: [String: ReactionGroupData]
    /// Codes explaining why the activity was shown, for example `following` or `popular`.
    ///
    /// - Note: Only set on For You feed reads when ``FeedQuery/enrichmentOptions`` has ``EnrichmentOptions/includeReasons`` set to true.
    public private(set) var reasons: [String]?
    public let score: Double
    /// Variable values used for ranking the activity.
    ///
    /// - Note: Only set on ranked feed reads when ``FeedQuery/enrichmentOptions`` has ``EnrichmentOptions/includeScoreVars`` set to true.
    public private(set) var scoreVariables: [String: RawJSON]?
    public let searchData: [String: RawJSON]
    /// The activity selector that provided the activity, for example `following` or `popular`.
    ///
    /// - Note: Only set on feed reads when the feed group uses several activity selectors.
    public private(set) var selectorSource: String?
    public let shareCount: Int
    public let text: String?
    public let type: String
    public let updatedAt: Date
    public let user: UserData
    public let visibility: ActivityDataVisibility
    public let visibilityTag: String?
    
    fileprivate let _parent: BoxedAny?
}

public typealias ActivityDataVisibility = ActivityVisibility

// MARK: - Mutating the Data

extension ActivityData {
    // MARK: - Activity and Its Reactions

    mutating func merge(with incomingData: ActivityData) {
        let ownBookmarks = ownBookmarks
        let ownReactions = ownReactions
        let friendReactionCount = friendReactionCount
        let friendReactions = friendReactions
        let position = position
        let reasons = reasons
        let scoreVariables = scoreVariables
        let selectorSource = selectorSource
        self = incomingData
        self.ownBookmarks = ownBookmarks
        self.ownReactions = ownReactions
        // Feed reads add these, and web-socket events don't carry them
        self.friendReactionCount = incomingData.friendReactionCount ?? friendReactionCount
        self.friendReactions = incomingData.friendReactions ?? friendReactions
        self.position = incomingData.position ?? position
        self.reasons = incomingData.reasons ?? reasons
        self.scoreVariables = incomingData.scoreVariables ?? scoreVariables
        self.selectorSource = incomingData.selectorSource ?? selectorSource
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
            latestReactions: latestReactions.map { $0.toModel() },
            location: location.flatMap { CLLocationCoordinate2D(latitude: CLLocationDegrees($0.lat), longitude: CLLocationDegrees($0.lng)) },
            mentionedUsers: mentionedUsers.map { $0.toModel() },
            moderation: moderation,
            notificationContext: notificationContext,
            ownBookmarks: ownBookmarks.map { $0.toModel() },
            ownReactions: ownReactions.map { $0.toModel() },
            poll: poll?.toModel(),
            popularity: popularity,
            position: position,
            reactionCount: reactionCount,
            reactionGroups: reactionGroups.mapValues { $0.toModel() },
            reasons: reasons,
            score: score,
            scoreVariables: scoreVars,
            searchData: searchData,
            selectorSource: selectorSource,
            shareCount: shareCount,
            text: text,
            type: type,
            updatedAt: updatedAt,
            user: user.toModel(),
            visibility: visibility,
            visibilityTag: visibilityTag,
            _parent: BoxedAny(parent?.toModel())
        )
    }
}
