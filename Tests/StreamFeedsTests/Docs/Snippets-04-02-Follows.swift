//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_04_02_Follows {
    var client: FeedsClient!
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
        // All my follows
        let allQuery = FollowsQuery(
            filter: .equal(.userId, "me"),
            limit: 20
        )
        let allFollowList = client.followList(for: allQuery)
        let allFollowsPage1 = try await allFollowList.get()

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
        
        suppressUnusedWarning(allFollowsPage1, page1, page2, page1And2, followerPage1)
    }
    
    func followRequests() async throws {
        // See if a feed needs a request for follow
        let feed = client.feed(group: "user", id: "amber")
        let feedData = try await feed.getOrCreate()
        if feedData.visibility == "followers" {
            // We need to request a follow
        }

        // Request to follow this feed
        let timeline = client.feed(group: "timeline", id: "john")
        try await timeline.follow(FeedId(group: "user", id: "amber"))

        // Accept
        try await feed.acceptFollow(.init(group: "timeline", id: "john"))
        // or reject the follow
        try await feed.rejectFollow(.init(group: "timeline", id: "john"))
    }
}
