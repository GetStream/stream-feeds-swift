//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation

extension FeedsClient {
    
    // MARK: - Activities
    
    public func activity(for activityId: String, feed feedsId: String) -> Activity {
        let activity = Activity(
            id: activityId,
            feedsId: feedsId,
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
