//
// Copyright © 2025 Stream.io Inc. All rights reserved.
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
    
    /// Custom options for activity selection and processing.
    public var activitySelectorOptions: [String: RawJSON]?
    
    /// Additional data to associate with the feed.
    public var data: FeedInput?
    
    /// Additional data used for ranking activities in the feed.
    public var externalRanking: [String: RawJSON]?
    
    /// The unique identifier for the feed.
    public var fid: FeedId
    
    /// Maximum number of followers to retrieve.
    public var followerLimit: Int?
    
    /// Maximum number of following users to retrieve.
    public var followingLimit: Int?
    
    /// Weights for different interests to influence activity ranking.
    public var interestWeights: [String: Float]?
    
    /// Maximum number of feed members to retrieve.
    public var memberLimit: Int?
    
    /// Overwrite the default ranking or aggregation logic for this feed (for example: good for split testing).
    public var view: String?
    
    /// If true, subscribes to web-socket events for this feed.
    public var watch = true
    
    /// Creates a new feed query with the specified group and ID.
    ///
    /// - Parameters:
    ///   - group: The feed group (e.g., "user", "timeline", "notification").
    ///   - id: The unique identifier within the group.
    ///   - activityFilter: Optional filter criteria for activities.
    ///   - activityLimit: Maximum number of activities to retrieve.
    ///   - activitySelectorOptions: Custom options for activity selection.
    ///   - data: Additional data to associate with the feed.
    ///   - externalRanking: Additional data used for ranking activities.
    ///   - followerLimit: Maximum number of followers to retrieve.
    ///   - followingLimit: Maximum number of following users to retrieve.
    ///   - interestWeights: Weights for different interests to influence ranking.
    ///   - memberLimit: Maximum number of feed members to retrieve.
    ///   - view: Custom view for ranking or aggregation logic.
    ///   - watch: Whether to subscribe to real-time updates for this feed.
    public init(group: String, id: String, activityFilter: ActivitiesFilter? = nil, activityLimit: Int? = nil, activitySelectorOptions: [String: RawJSON]? = nil, data: FeedInput? = nil, externalRanking: [String: RawJSON]? = nil, followerLimit: Int? = nil, followingLimit: Int? = nil, interestWeights: [String: Float]? = nil, memberLimit: Int? = nil, view: String? = nil, watch: Bool = true) {
        self.init(
            fid: FeedId(group: group, id: id),
            activityFilter: activityFilter,
            activityLimit: activityLimit,
            activitySelectorOptions: activitySelectorOptions,
            data: data,
            externalRanking: externalRanking,
            followerLimit: followerLimit,
            followingLimit: followingLimit,
            interestWeights: interestWeights,
            memberLimit: memberLimit,
            view: view,
            watch: watch
        )
    }
    
    /// Creates a new feed query with the specified feed ID.
    ///
    /// - Parameters:
    ///   - fid: The feed identifier containing group and ID.
    ///   - activityFilter: Optional filter criteria for activities.
    ///   - activityLimit: Maximum number of activities to retrieve.
    ///   - activitySelectorOptions: Custom options for activity selection.
    ///   - data: Additional data to associate with the feed.
    ///   - externalRanking: Additional data used for ranking activities.
    ///   - followerLimit: Maximum number of followers to retrieve.
    ///   - followingLimit: Maximum number of following users to retrieve.
    ///   - interestWeights: Weights for different interests to influence ranking.
    ///   - memberLimit: Maximum number of feed members to retrieve.
    ///   - view: Custom view for ranking or aggregation logic.
    ///   - watch: Whether to subscribe to real-time updates for this feed.
    public init(fid: FeedId, activityFilter: ActivitiesFilter? = nil, activityLimit: Int? = nil, activitySelectorOptions: [String: RawJSON]? = nil, data: FeedInput? = nil, externalRanking: [String: RawJSON]? = nil, followerLimit: Int? = nil, followingLimit: Int? = nil, interestWeights: [String: Float]? = nil, memberLimit: Int? = nil, view: String? = nil, watch: Bool = true) {
        self.activityFilter = activityFilter
        self.activityLimit = activityLimit
        self.activitySelectorOptions = activitySelectorOptions
        self.data = data
        self.externalRanking = externalRanking
        self.fid = fid
        self.followerLimit = followerLimit
        self.followingLimit = followingLimit
        self.interestWeights = interestWeights
        self.memberLimit = memberLimit
        self.view = view
        self.watch = watch
    }
}

// MARK: -

extension FeedQuery {
    func toRequest() -> GetOrCreateFeedRequest {
        GetOrCreateFeedRequest(
            activitySelectorOptions: activitySelectorOptions,
            data: data,
            externalRanking: externalRanking,
            filter: activityFilter?.toRawJSON(),
            followersPagination: followerLimit.flatMap { PagerRequest(limit: $0) },
            followingPagination: followingLimit.flatMap { PagerRequest(limit: $0) },
            interestWeights: interestWeights,
            limit: activityLimit,
            memberPagination: memberLimit.flatMap { PagerRequest(limit: $0) },
            next: nil,
            prev: nil,
            view: view,
            watch: watch
        )
    }
}
