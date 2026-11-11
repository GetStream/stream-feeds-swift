//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_04_02_Follows {
    var client: FeedsClient!
    var adamClient: FeedsClient!
    var saraClient: FeedsClient!
    var feed: Feed!
    
    func followUnfollow() async throws {
        // Follow a user
        let timeline = client.feed(group: "timeline", id: "john")
        _ = try await timeline.follow(FeedId(group: "user", id: "tom"))
        
        // Follow a stock
        _ = try await timeline.follow(FeedId(group: "stock", id: "apple"))

        // Follow with more fields
        _ = try await timeline.follow(
            FeedId(group: "stock", id: "apple"),
            custom: ["reason": "investment"]
        )
    }
    
    func queryingFollows() async throws {
        // Do I follow a list of feeds
        // My feed is timeline:john
        let followQuery = FollowsQuery(
            filter: .and([
                .equal(.sourceFeed, "timeline:john"),
                .in(.targetFeed, ["user:sara", "user:adam"])
            ])
        )
        let followList = client.followList(for: followQuery)
        let page1 = try await followList.get()
        let page2 = try await followList.queryMoreFollows()
        let page1And2 = followList.state.follows

        // Paginating through followers for a feed
        // My feed is timeline:john
        let followerQuery = FollowsQuery(
            filter: .equal(.targetFeed, "timeline:john")
        )
        let followerList = client.followList(for: followerQuery)
        let followerPage1 = try await followerList.get()
        
        suppressUnusedWarning(page1, page2, page1And2, followerPage1)
    }
    
    func followRequests() async throws {
        // Sara needs to configure the feed with visibility = followers for enabling follow requests
        let saraFeed = saraClient.feed(
            for: .init(
                group: "user",
                id: "sara",
                data: .init(visibility: .followers)
            )
        )
        try await saraFeed.getOrCreate()
        
        // Adam requesting to follow the feed
        let adamTimeline = adamClient.feed(group: "timeline", id: "adam")
        try await adamTimeline.getOrCreate()
        
        let followRequest = try await adamTimeline.follow(saraFeed.feed) // user:sara
        print(followRequest.status) // .pending
        
        // Sara loading pending follow requests
        try await saraFeed.queryFollowRequests()
        print(saraFeed.state.followRequests.count) // 1
        
        // Sara accepting
        try await saraFeed.acceptFollow(adamTimeline.feed) // timeline:adam
        // or rejecting the request
        try await saraFeed.rejectFollow(adamTimeline.feed) // timeline:adam
    }

    func limitingCopiedActivities() async throws {
        let timeline = client.feed(group: "timeline", id: "alice")

        // Follow without adding existing activities
        try await timeline.follow(FeedId(group: "user", id: "bob"), activityCopyLimit: 0)

        // Add only the 20 most recent activities
        try await timeline.follow(FeedId(group: "user", id: "charlie"), activityCopyLimit: 20)
    }

    func pushPreferencesOnFollow() async throws {
        let timeline = client.feed(group: "timeline", id: "john")

        // Scenario 1: Follow a user and receive notifications for their future activities
        try await timeline.follow(FeedId(group: "user", id: "alice"), pushPreference: .all)

        // Scenario 2: Follow a user but don't get notifications for their activities
        try await timeline.follow(FeedId(group: "user", id: "bob"), pushPreference: FollowPushPreference.none)

        // Scenario 3: Follow a user silently
        try await timeline.follow(
            FeedId(group: "user", id: "charlie"),
            pushPreference: .all, // But you'll still get notifications for Charlie's future posts
            skipPush: true // Charlie won't get a "you have a new follower" notification
        )
    }

    func followSuggestions() async throws {
        // Get follow suggestions for a user
        let feed = client.feed(group: "user", id: "john")
        let suggestions = try await feed.queryFollowSuggestions(limit: 10)

        for suggestion in suggestions {
            print("Suggested feed: \(suggestion.feed.feed)")
            print("Recommendation score: \(suggestion.recommendationScore ?? 0)")
            print("Reason: \(suggestion.reason ?? "")")
        }
    }
}
