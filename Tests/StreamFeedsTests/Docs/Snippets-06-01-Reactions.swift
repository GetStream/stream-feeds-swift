//
// Copyright © 2026 Stream.io Inc. All rights reserved.
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

    func overviewWithFriendReactions() async throws {
        let feed = client.feed(
            for: FeedQuery(
                group: "user",
                id: "sara",
                friendReactionsOptions: FriendReactionsOptions(enabled: true)
            )
        )
        try await feed.getOrCreate()
        // Last 15 reactions on the first activity
        print(feed.state.activities[0].latestReactions)
        // Count of reactions by type
        print(feed.state.activities[0].reactionGroups)
        // Reactions from people the current user follows, and their total
        print(feed.state.activities[0].friendReactionCount ?? 0)
        print(feed.state.activities[0].friendReactions ?? [])
    }

    func queryingReactions() async throws {
        // Query reactions to a specific activity
        let activityReactionList = client.activityReactionList(
            for: ActivityReactionsQuery(
                activityId: "activity-123",
                filter: .equal(.reactionType, "like")
            )
        )
        let activityReactions = try await activityReactionList.get()

        // Query reactions to a specific comment
        let commentReactionList = client.commentReactionList(
            for: CommentReactionsQuery(
                commentId: "comment-456",
                filter: .equal(.reactionType, "like")
            )
        )
        let commentReactions = try await commentReactionList.get()

        suppressUnusedWarning(activityReactions, commentReactions)
    }
}
