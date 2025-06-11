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
    
    public func feed(group: String, id: String) -> Feed {
        Feed(
            group: group,
            id: id,
            user: user,
            activitiesRepository: activitiesRepository,
            feedsRepository: feedsRepository,
            pollsRepository: pollsRepository,
            events: eventsMiddleware
        )
    }
}
