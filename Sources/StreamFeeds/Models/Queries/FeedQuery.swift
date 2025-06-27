//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

public struct FeedQuery: Sendable {
    public var activityFilter: ActivitiesFilter?
    public var activityLimit: Int?
    public var activitySelectorOptions: [String: RawJSON]?
    public var data: FeedInput?
    
    /// Additional data used for ranking.
    public var externalRanking: [String: RawJSON]?
    public var fid: FeedId
    public var followerLimit: Int?
    public var followingLimit: Int?
    public var interestWeights: [String: Float]?
    public var memberLimit: Int?
    
    /// Overwrite the default ranking or aggregation logic for this feed (for example: good for split testing).
    public var view: String?
    
    /// If true, subscribes to web-socket events for this feed.
    public var watch = true
    
    public init(group: String, id: String, activityFilter: ActivitiesFilter? = nil, activityLimit: Int? = nil, activitySelectorOptions: [String : RawJSON]? = nil, data: FeedInput? = nil, externalRanking: [String : RawJSON]? = nil, followerLimit: Int? = nil, followingLimit: Int? = nil, interestWeights: [String : Float]? = nil, memberLimit: Int? = nil, view: String? = nil, watch: Bool = true) {
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
    
    public init(fid: FeedId, activityFilter: ActivitiesFilter? = nil, activityLimit: Int? = nil, activitySelectorOptions: [String : RawJSON]? = nil, data: FeedInput? = nil, externalRanking: [String : RawJSON]? = nil, followerLimit: Int? = nil, followingLimit: Int? = nil, interestWeights: [String : Float]? = nil, memberLimit: Int? = nil, view: String? = nil, watch: Bool = true) {
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
            followerPagination: followerLimit.flatMap { PagerRequest(limit: $0) },
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
