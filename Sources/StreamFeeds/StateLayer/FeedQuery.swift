//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

/// A query configuration for retrieving and managing feed data from Stream Feeds.
///
/// `FeedQuery` defines the parameters used to fetch activities, followers, following, and members
/// for a specific feed. It supports filtering, pagination, ranking, and real-time updates.
///
/// ## Example Usage
/// ```swift
/// let query = FeedQuery(
///     group: "user",
///     id: "john",
///     activityLimit: 25,
///     watch: true
/// )
/// ```
public struct FeedQuery: Sendable {
    /// Filter criteria for activities in the feed.
    public var activityFilter: ActivitiesFilter?
    
    /// Maximum number of activities to retrieve.
    public var activityLimit: Int?
    
    /// Pagination cursor for fetching the next page of activities.
    public var activityNext: String?
    
    /// Pagination cursor for fetching the previous page of activities.
    public var activityPrevious: String?
    
    /// Additional data to associate with the feed.
    public var data: FeedInput?
    
    /// Options for skipping or adding enrichments to the feed response. Backend default runs all enrichments.
    public var enrichmentOptions: EnrichmentOptions?
    
    /// Additional data used for ranking activities in the feed.
    public var externalRanking: [String: RawJSON]?
    
    /// The unique identifier for the feed.
    public var feed: FeedId
    
    /// Maximum number of followers to retrieve.
    public var followerLimit: Int?
    
    /// Maximum number of following users to retrieve.
    public var followingLimit: Int?
    
    /// Options for including reactions from followed or mutually followed users on activities. Backend default doesn't include them.
    public var friendReactionsOptions: FriendReactionsOptions?
    
    /// Weights for different interests to influence activity ranking.
    public var interestWeights: [String: Double]?
    
    /// Maximum number of feed members to retrieve.
    public var memberLimit: Int?
    
    /// If true, `interestWeights` replace the user's stored interest weights instead of merging with them. Backend default is false.
    public var overwriteInterestWeights: Bool?
    
    /// Overwrite the default ranking or aggregation logic for this feed (for example: good for split testing).
    public var view: String?
    
    /// The viewer's location.
    ///
    /// - Note: Only the proximity activity selector uses it.
    public var viewerLocation: Location?
    
    /// If true, subscribes to web-socket events for this feed.
    public var watch = true
    
    /// Creates a new feed query with the specified group and ID.
    ///
    /// - Parameters:
    ///   - group: The feed group (e.g., "user", "timeline", "notification").
    ///   - id: The unique identifier within the group.
    ///   - activityFilter: Optional filter criteria for activities.
    ///   - activityLimit: Maximum number of activities to retrieve.
    ///   - data: Additional data to associate with the feed.
    ///   - enrichmentOptions: Options for skipping or adding enrichments to the feed response. Backend default runs all enrichments.
    ///   - externalRanking: Additional data used for ranking activities.
    ///   - followerLimit: Maximum number of followers to retrieve. Defaults to 10.
    ///   - followingLimit: Maximum number of following users to retrieve. Defaults to 10.
    ///   - friendReactionsOptions: Options for including reactions from followed or mutually followed users on activities. Backend default doesn't include them.
    ///   - interestWeights: Weights for different interests to influence ranking.
    ///   - memberLimit: Maximum number of feed members to retrieve.
    ///   - overwriteInterestWeights: If true, `interestWeights` replace the stored interest weights. Backend default is false.
    ///   - view: Custom view for ranking or aggregation logic.
    ///   - viewerLocation: The viewer's location for the proximity activity selector.
    ///   - watch: Whether to subscribe to real-time updates for this feed.
    public init(
        group: String,
        id: String,
        activityFilter: ActivitiesFilter? = nil,
        activityLimit: Int? = nil,
        data: FeedInput? = nil,
        enrichmentOptions: EnrichmentOptions? = nil,
        externalRanking: [String: RawJSON]? = nil,
        followerLimit: Int? = 10,
        followingLimit: Int? = 10,
        friendReactionsOptions: FriendReactionsOptions? = nil,
        interestWeights: [String: Double]? = nil,
        memberLimit: Int? = nil,
        overwriteInterestWeights: Bool? = nil,
        view: String? = nil,
        viewerLocation: Location? = nil,
        watch: Bool = true
    ) {
        self.init(
            feed: FeedId(group: group, id: id),
            activityFilter: activityFilter,
            activityLimit: activityLimit,
            data: data,
            enrichmentOptions: enrichmentOptions,
            externalRanking: externalRanking,
            followerLimit: followerLimit,
            followingLimit: followingLimit,
            friendReactionsOptions: friendReactionsOptions,
            interestWeights: interestWeights,
            memberLimit: memberLimit,
            overwriteInterestWeights: overwriteInterestWeights,
            view: view,
            viewerLocation: viewerLocation,
            watch: watch
        )
    }
    
    /// Creates a new feed query with the specified feed ID.
    ///
    /// - Parameters:
    ///   - feed: The feed identifier containing group and ID.
    ///   - activityFilter: Optional filter criteria for activities.
    ///   - activityLimit: Maximum number of activities to retrieve.
    ///   - data: Additional data to associate with the feed.
    ///   - enrichmentOptions: Options for skipping or adding enrichments to the feed response. Backend default runs all enrichments.
    ///   - externalRanking: Additional data used for ranking activities.
    ///   - followerLimit: Maximum number of followers to retrieve. Defaults to 10.
    ///   - followingLimit: Maximum number of following users to retrieve. Defaults to 10.
    ///   - friendReactionsOptions: Options for including reactions from followed or mutually followed users on activities. Backend default doesn't include them.
    ///   - interestWeights: Weights for different interests to influence ranking.
    ///   - memberLimit: Maximum number of feed members to retrieve.
    ///   - overwriteInterestWeights: If true, `interestWeights` replace the stored interest weights. Backend default is false.
    ///   - view: Custom view for ranking or aggregation logic.
    ///   - viewerLocation: The viewer's location for the proximity activity selector.
    ///   - watch: Whether to subscribe to real-time updates for this feed.
    public init(
        feed: FeedId,
        activityFilter: ActivitiesFilter? = nil,
        activityLimit: Int? = nil,
        data: FeedInput? = nil,
        enrichmentOptions: EnrichmentOptions? = nil,
        externalRanking: [String: RawJSON]? = nil,
        followerLimit: Int? = 10,
        followingLimit: Int? = 10,
        friendReactionsOptions: FriendReactionsOptions? = nil,
        interestWeights: [String: Double]? = nil,
        memberLimit: Int? = nil,
        overwriteInterestWeights: Bool? = nil,
        view: String? = nil,
        viewerLocation: Location? = nil,
        watch: Bool = true
    ) {
        self.activityFilter = activityFilter
        self.activityLimit = activityLimit
        self.data = data
        self.enrichmentOptions = enrichmentOptions
        self.externalRanking = externalRanking
        self.feed = feed
        self.followerLimit = followerLimit
        self.followingLimit = followingLimit
        self.friendReactionsOptions = friendReactionsOptions
        self.interestWeights = interestWeights
        self.memberLimit = memberLimit
        self.overwriteInterestWeights = overwriteInterestWeights
        self.view = view
        self.viewerLocation = viewerLocation
        self.watch = watch
    }
}

// MARK: -

extension FeedQuery {
    func toRequest() -> GetOrCreateFeedRequest {
        GetOrCreateFeedRequest(
            data: data,
            enrichmentOptions: enrichmentOptions,
            externalRanking: externalRanking,
            filter: activityFilter?.toRawJSONDictionary(),
            followersPagination: followerLimit.flatMap { PagerRequest(limit: $0) },
            followingPagination: followingLimit.flatMap { PagerRequest(limit: $0) },
            friendReactionsOptions: friendReactionsOptions,
            interestWeights: interestWeights,
            limit: activityLimit,
            memberPagination: memberLimit.flatMap { PagerRequest(limit: $0) },
            next: activityNext,
            overwriteInterestWeights: overwriteInterestWeights,
            prev: activityPrevious,
            view: view,
            viewerLocation: viewerLocation,
            watch: watch
        )
    }
}
