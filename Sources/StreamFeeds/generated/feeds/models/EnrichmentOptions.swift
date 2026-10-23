//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// Options to skip specific enrichments to improve performance. Default is false (enrichments are included). Setting a field to true skips that enrichment.
public final class EnrichmentOptions: Sendable, Codable, JSONEncodable {
    /// Default: false. When true, includes fetching and enriching own_followings (follows where activity author's feeds follow current user's feeds).
    public let enrichOwnFollowings: Bool?
    /// Controls the top-level flat 'activities' array for aggregated feeds. For new apps, defaults to false (excluded); set to true to include. For older apps, defaults to true (included) for backward compatibility; set to false to exclude.
    public let includeFlatActivities: Bool?
    /// Default: false. When true, includes score_vars in activity responses containing variable values used at ranking time.
    public let includeScoreVars: Bool?
    /// Default: false. When true, skips all activity enrichments.
    public let skipActivity: Bool?
    /// Default: false. When true, skips enriching collections on activities.
    public let skipActivityCollections: Bool?
    /// Default: false. When true, skips enriching comments on activities.
    public let skipActivityComments: Bool?
    /// Default: false. When true, skips enriching current_feed on activities. Note: CurrentFeed is still computed for permission checks, but enrichment is skipped.
    public let skipActivityCurrentFeed: Bool?
    /// Default: false. When true, skips enriching mentioned users on activities.
    public let skipActivityMentionedUsers: Bool?
    /// Default: false. When true, skips enriching own bookmarks on activities.
    public let skipActivityOwnBookmarks: Bool?
    /// Default: false. When true, skips enriching parent activities.
    public let skipActivityParents: Bool?
    /// Default: false. When true, skips enriching poll data on activities.
    public let skipActivityPoll: Bool?
    /// Default: false. When true, skips fetching and enriching latest and own reactions on activities. Note: If reactions are already denormalized in the database, they will still be included.
    public let skipActivityReactions: Bool?
    /// Default: false. When true, skips refreshing image URLs on activities.
    public let skipActivityRefreshImageUrls: Bool?
    /// Default: false. When true, skips all enrichments.
    public let skipAll: Bool?
    /// Default: false. When true, skips enriching user data on feed members.
    public let skipFeedMemberUser: Bool?
    /// Default: false. When true, skips fetching and enriching followers. Note: If followers_pagination is explicitly provided, followers will be fetched regardless of this setting.
    public let skipFollowers: Bool?
    /// Default: false. When true, skips fetching and enriching following. Note: If following_pagination is explicitly provided, following will be fetched regardless of this setting.
    public let skipFollowing: Bool?
    /// Default: false. When true, skips computing and including capabilities for feeds.
    public let skipOwnCapabilities: Bool?
    /// Default: false. When true, skips fetching and enriching own_follows (follows where user's feeds follow target feeds).
    public let skipOwnFollows: Bool?
    /// Default: false. When true, skips enriching pinned activities.
    public let skipPins: Bool?

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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)
        self.enrichOwnFollowings = try container.decodeIfPresent(Bool.self, forKey: .enrichOwnFollowings)
        self.includeFlatActivities = try container.decodeIfPresent(Bool.self, forKey: .includeFlatActivities)
        self.includeScoreVars = try container.decodeIfPresent(Bool.self, forKey: .includeScoreVars)
        self.skipActivity = try container.decodeIfPresent(Bool.self, forKey: .skipActivity)
        self.skipActivityCollections = try container.decodeIfPresent(Bool.self, forKey: .skipActivityCollections)
        self.skipActivityComments = try container.decodeIfPresent(Bool.self, forKey: .skipActivityComments)
        self.skipActivityCurrentFeed = try container.decodeIfPresent(Bool.self, forKey: .skipActivityCurrentFeed)
        self.skipActivityMentionedUsers = try container.decodeIfPresent(Bool.self, forKey: .skipActivityMentionedUsers)
        self.skipActivityOwnBookmarks = try container.decodeIfPresent(Bool.self, forKey: .skipActivityOwnBookmarks)
        self.skipActivityParents = try container.decodeIfPresent(Bool.self, forKey: .skipActivityParents)
        self.skipActivityPoll = try container.decodeIfPresent(Bool.self, forKey: .skipActivityPoll)
        self.skipActivityReactions = try container.decodeIfPresent(Bool.self, forKey: .skipActivityReactions)
        self.skipActivityRefreshImageUrls = try container.decodeIfPresent(Bool.self, forKey: .skipActivityRefreshImageUrls)
        self.skipAll = try container.decodeIfPresent(Bool.self, forKey: .skipAll)
        self.skipFeedMemberUser = try container.decodeIfPresent(Bool.self, forKey: .skipFeedMemberUser)
        self.skipFollowers = try container.decodeIfPresent(Bool.self, forKey: .skipFollowers)
        self.skipFollowing = try container.decodeIfPresent(Bool.self, forKey: .skipFollowing)
        self.skipOwnCapabilities = try container.decodeIfPresent(Bool.self, forKey: .skipOwnCapabilities)
        self.skipOwnFollows = try container.decodeIfPresent(Bool.self, forKey: .skipOwnFollows)
        self.skipPins = try container.decodeIfPresent(Bool.self, forKey: .skipPins)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)
        try container.encodeIfPresent(enrichOwnFollowings, forKey: .enrichOwnFollowings)
        try container.encodeIfPresent(includeFlatActivities, forKey: .includeFlatActivities)
        try container.encodeIfPresent(includeScoreVars, forKey: .includeScoreVars)
        try container.encodeIfPresent(skipActivity, forKey: .skipActivity)
        try container.encodeIfPresent(skipActivityCollections, forKey: .skipActivityCollections)
        try container.encodeIfPresent(skipActivityComments, forKey: .skipActivityComments)
        try container.encodeIfPresent(skipActivityCurrentFeed, forKey: .skipActivityCurrentFeed)
        try container.encodeIfPresent(skipActivityMentionedUsers, forKey: .skipActivityMentionedUsers)
        try container.encodeIfPresent(skipActivityOwnBookmarks, forKey: .skipActivityOwnBookmarks)
        try container.encodeIfPresent(skipActivityParents, forKey: .skipActivityParents)
        try container.encodeIfPresent(skipActivityPoll, forKey: .skipActivityPoll)
        try container.encodeIfPresent(skipActivityReactions, forKey: .skipActivityReactions)
        try container.encodeIfPresent(skipActivityRefreshImageUrls, forKey: .skipActivityRefreshImageUrls)
        try container.encodeIfPresent(skipAll, forKey: .skipAll)
        try container.encodeIfPresent(skipFeedMemberUser, forKey: .skipFeedMemberUser)
        try container.encodeIfPresent(skipFollowers, forKey: .skipFollowers)
        try container.encodeIfPresent(skipFollowing, forKey: .skipFollowing)
        try container.encodeIfPresent(skipOwnCapabilities, forKey: .skipOwnCapabilities)
        try container.encodeIfPresent(skipOwnFollows, forKey: .skipOwnFollows)
        try container.encodeIfPresent(skipPins, forKey: .skipPins)
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
