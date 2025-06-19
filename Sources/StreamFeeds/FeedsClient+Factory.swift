//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

extension FeedsClient {
    
    // MARK: - Activities
    
    public func activity(for activityId: String, fid: FeedId) -> Activity {
        let activity = Activity(
            id: activityId,
            fid: fid,
            activitiesRepository: activitiesRepository,
            commentsRepository: commentsRepository,
            pollsRepository: pollsRepository,
            events: eventsMiddleware
        )
        return activity
    }
    
    // MARK: - Feeds
    
    public func feed(for query: FeedQuery) -> Feed {
        Feed(query: query, user: user, client: self)
    }
}
