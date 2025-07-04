//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_06_01_Reactions {
    var client: FeedsClient!
    var feed: Feed!
    
    func overview() async throws {
        // Add a reaction to an activity
        let reaction = try await feed.addReaction(
            activityId: "activity_123",
            request: .init(
                custom: ["emoji": "❤️"],
                type: "like"
            )
        )
        // Remove a reaction
        _ = try await feed.deleteReaction(activityId: "activity_123", type: "like")
        
        suppressUnusedWarning(reaction)
    }
    
    func overview2() async throws {
        let feedData = try await feed.getOrCreate()
        // Last 15 reactions on the first activity
        print(feed.state.activities[0].latestReactions)
        // Count of reactions by type
        print(feed.state.activities[0].reactionGroups)
        
        suppressUnusedWarning(feedData)
    }
}
