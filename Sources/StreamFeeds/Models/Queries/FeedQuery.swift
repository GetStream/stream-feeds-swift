//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

public struct FeedQuery: Sendable {
    public let fid: FeedId
    public let activityFilter: ActivityFilter?
    public let activityLimit: Int?
    public let data: FeedInput?
    
    public init(fid: FeedId, activityFilter: ActivityFilter? = nil, activityLimit: Int? = nil, data: FeedInput? = nil) {
        self.fid = fid
        self.activityFilter = activityFilter
        self.activityLimit = activityLimit
        self.data = data
    }
}

// MARK: -

extension FeedQuery {
    func toRequest() -> GetOrCreateFeedRequest {
        GetOrCreateFeedRequest(
            commentLimit: 10,
            commentSort: nil,
            data: data,
            externalRanking: nil,
            filter: activityFilter?.toRawJSON(),
            followerPagination: .init(limit: 10),
            followingPagination: .init(limit: 10),
            limit: activityLimit,
            memberPagination: .init(limit: 10),
            next: nil,
            prev: nil,
            view: nil,
            watch: true
        )
    }
}
