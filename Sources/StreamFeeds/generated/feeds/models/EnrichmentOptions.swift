//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Options to skip specific enrichments to improve performance. Default is false (enrichments are included). Setting a field to true skips that enrichment.
public final class EnrichmentOptions: @unchecked Sendable, Codable, JSONEncodable {
    /// Default: false. When true, includes fetching and enriching own_followings (follows where activity author's feeds follow current user's feeds).
    public var enrichOwnFollowings: Bool?
    /// Controls the top-level flat 'activities' array for aggregated feeds. For new apps, defaults to false (excluded); set to true to include. For older apps, defaults to true (included) for backward compatibility; set to false to exclude.
    public var includeFlatActivities: Bool?
    /// Default: false. When true, includes score_vars in activity responses containing variable values used at ranking time.
    public var includeScoreVars: Bool?
    /// Default: false. When true, skips all activity enrichments.
    public var skipActivity: Bool?
    /// Default: false. When true, skips enriching collections on activities.
    public var skipActivityCollections: Bool?
    /// Default: false. When true, skips enriching comments on activities.
    public var skipActivityComments: Bool?
    /// Default: false. When true, skips enriching current_feed on activities. Note: CurrentFeed is still computed for permission checks, but enrichment is skipped.
    public var skipActivityCurrentFeed: Bool?
    /// Default: false. When true, skips enriching mentioned users on activities.
    public var skipActivityMentionedUsers: Bool?
    /// Default: false. When true, skips enriching own bookmarks on activities.
    public var skipActivityOwnBookmarks: Bool?
    /// Default: false. When true, skips enriching parent activities.
    public var skipActivityParents: Bool?
    /// Default: false. When true, skips enriching poll data on activities.
    public var skipActivityPoll: Bool?
    /// Default: false. When true, skips fetching and enriching latest and own reactions on activities. Note: If reactions are already denormalized in the database, they will still be included.
    public var skipActivityReactions: Bool?
    /// Default: false. When true, skips refreshing image URLs on activities.
    public var skipActivityRefreshImageUrls: Bool?
    /// Default: false. When true, skips all enrichments.
    public var skipAll: Bool?
    /// Default: false. When true, skips enriching user data on feed members.
    public var skipFeedMemberUser: Bool?
    /// Default: false. When true, skips fetching and enriching followers. Note: If followers_pagination is explicitly provided, followers will be fetched regardless of this setting.
    public var skipFollowers: Bool?
    /// Default: false. When true, skips fetching and enriching following. Note: If following_pagination is explicitly provided, following will be fetched regardless of this setting.
    public var skipFollowing: Bool?
    /// Default: false. When true, skips computing and including capabilities for feeds.
    public var skipOwnCapabilities: Bool?
    /// Default: false. When true, skips fetching and enriching own_follows (follows where user's feeds follow target feeds).
    public var skipOwnFollows: Bool?
    /// Default: false. When true, skips enriching pinned activities.
    public var skipPins: Bool?

    public init(enrichOwnFollowings: Bool? = nil, includeFlatActivities: Bool? = nil, includeScoreVars: Bool? = nil, skipActivity: Bool? = nil, skipActivityCollections: Bool? = nil, skipActivityComments: Bool? = nil, skipActivityCurrentFeed: Bool? = nil, skipActivityMentionedUsers: Bool? = nil, skipActivityOwnBookmarks: Bool? = nil, skipActivityParents: Bool? = nil, skipActivityPoll: Bool? = nil, skipActivityReactions: Bool? = nil, skipActivityRefreshImageUrls: Bool? = nil, skipAll: Bool? = nil, skipFeedMemberUser: Bool? = nil, skipFollowers: Bool? = nil, skipFollowing: Bool? = nil, skipOwnCapabilities: Bool? = nil, skipOwnFollows: Bool? = nil, skipPins: Bool? = nil) {
        self.enrichOwnFollowings = enrichOwnFollowings
        self.includeFlatActivities = includeFlatActivities
        self.includeScoreVars = includeScoreVars
        self.skipActivity = skipActivity
        self.skipActivityCollections = skipActivityCollections
        self.skipActivityComments = skipActivityComments
        self.skipActivityCurrentFeed = skipActivityCurrentFeed
        self.skipActivityMentionedUsers = skipActivityMentionedUsers
        self.skipActivityOwnBookmarks = skipActivityOwnBookmarks
        self.skipActivityParents = skipActivityParents
        self.skipActivityPoll = skipActivityPoll
        self.skipActivityReactions = skipActivityReactions
        self.skipActivityRefreshImageUrls = skipActivityRefreshImageUrls
        self.skipAll = skipAll
        self.skipFeedMemberUser = skipFeedMemberUser
        self.skipFollowers = skipFollowers
        self.skipFollowing = skipFollowing
        self.skipOwnCapabilities = skipOwnCapabilities
        self.skipOwnFollows = skipOwnFollows
        self.skipPins = skipPins
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case enrichOwnFollowings = "enrich_own_followings"
        case includeFlatActivities = "include_flat_activities"
        case includeScoreVars = "include_score_vars"
        case skipActivity = "skip_activity"
        case skipActivityCollections = "skip_activity_collections"
        case skipActivityComments = "skip_activity_comments"
        case skipActivityCurrentFeed = "skip_activity_current_feed"
        case skipActivityMentionedUsers = "skip_activity_mentioned_users"
        case skipActivityOwnBookmarks = "skip_activity_own_bookmarks"
        case skipActivityParents = "skip_activity_parents"
        case skipActivityPoll = "skip_activity_poll"
        case skipActivityReactions = "skip_activity_reactions"
        case skipActivityRefreshImageUrls = "skip_activity_refresh_image_urls"
        case skipAll = "skip_all"
        case skipFeedMemberUser = "skip_feed_member_user"
        case skipFollowers = "skip_followers"
        case skipFollowing = "skip_following"
        case skipOwnCapabilities = "skip_own_capabilities"
        case skipOwnFollows = "skip_own_follows"
        case skipPins = "skip_pins"
    }
}

extension EnrichmentOptions: Hashable {
    public static func == (lhs: EnrichmentOptions, rhs: EnrichmentOptions) -> Bool {
        lhs.enrichOwnFollowings == rhs.enrichOwnFollowings &&
            lhs.includeFlatActivities == rhs.includeFlatActivities &&
            lhs.includeScoreVars == rhs.includeScoreVars &&
            lhs.skipActivity == rhs.skipActivity &&
            lhs.skipActivityCollections == rhs.skipActivityCollections &&
            lhs.skipActivityComments == rhs.skipActivityComments &&
            lhs.skipActivityCurrentFeed == rhs.skipActivityCurrentFeed &&
            lhs.skipActivityMentionedUsers == rhs.skipActivityMentionedUsers &&
            lhs.skipActivityOwnBookmarks == rhs.skipActivityOwnBookmarks &&
            lhs.skipActivityParents == rhs.skipActivityParents &&
            lhs.skipActivityPoll == rhs.skipActivityPoll &&
            lhs.skipActivityReactions == rhs.skipActivityReactions &&
            lhs.skipActivityRefreshImageUrls == rhs.skipActivityRefreshImageUrls &&
            lhs.skipAll == rhs.skipAll &&
            lhs.skipFeedMemberUser == rhs.skipFeedMemberUser &&
            lhs.skipFollowers == rhs.skipFollowers &&
            lhs.skipFollowing == rhs.skipFollowing &&
            lhs.skipOwnCapabilities == rhs.skipOwnCapabilities &&
            lhs.skipOwnFollows == rhs.skipOwnFollows &&
            lhs.skipPins == rhs.skipPins
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(enrichOwnFollowings)
        hasher.combine(includeFlatActivities)
        hasher.combine(includeScoreVars)
        hasher.combine(skipActivity)
        hasher.combine(skipActivityCollections)
        hasher.combine(skipActivityComments)
        hasher.combine(skipActivityCurrentFeed)
        hasher.combine(skipActivityMentionedUsers)
        hasher.combine(skipActivityOwnBookmarks)
        hasher.combine(skipActivityParents)
        hasher.combine(skipActivityPoll)
        hasher.combine(skipActivityReactions)
        hasher.combine(skipActivityRefreshImageUrls)
        hasher.combine(skipAll)
        hasher.combine(skipFeedMemberUser)
        hasher.combine(skipFollowers)
        hasher.combine(skipFollowing)
        hasher.combine(skipOwnCapabilities)
        hasher.combine(skipOwnFollows)
        hasher.combine(skipPins)
    }
}
