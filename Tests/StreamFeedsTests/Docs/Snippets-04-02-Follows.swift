//
// Copyright © 2025 Stream.io Inc. All rights reserved.
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
        
        // Sara accepting
        try await saraFeed.acceptFollow(
            adamTimeline.feed, // timeline:adam
            role: "feed_member" // optional
        )
        // or rejecting the request
        try await saraFeed.rejectFollow(adamTimeline.feed) // timeline:adam
    }
}
