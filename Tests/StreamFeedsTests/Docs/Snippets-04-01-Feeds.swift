//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_04_01_Feeds {
    var client: FeedsClient!
    var feed: Feed!
    
    func creatingAFeed() async throws {
        // Feed with no extra fields, of feed group "user"
        let feed = client.feed(group: "user", id: "john")
        try await feed.getOrCreate()

        // More options
        let query = FeedQuery(
            group: "user",
            id: "jack",
            data: .init(
                description: "My personal feed",
                name: "jack",
                visibility: .public
            )
        )
        let feed2 = client.feed(for: query)
        try await feed.getOrCreate()
        
        suppressUnusedWarning(feed2)
    }
    
    func readingAFeed() async throws {
        let feed = client.feed(group: "user", id: "john")
        try await feed.getOrCreate()
        let feedData = feed.state.feed
        let activities = feed.state.activities
        let members = feed.state.members
        
        suppressUnusedWarning(feedData, activities, members)
    }
    
    func readingAFeed2() async throws {
        let query = FeedQuery(
            group: "user",
            id: "john",
            activityFilter: .in(.filterTags, ["green"]), // filter activities with filter tag green
            activityLimit: 10,
            externalRanking: ["user_score": 0.8], // additional data used for ranking
            followerLimit: 10,
            followingLimit: 10,
            memberLimit: 10,
            view: "myview", // overwrite the default ranking or aggregation logic for this feed. good for split testing
            watch: true // receive web-socket events with real-time updates
        )
        let feed = client.feed(for: query)
        try await feed.getOrCreate()
        let activities = feed.state.activities
        let feedData = feed.state.feed
        
        suppressUnusedWarning(feedData, activities)
    }
    
    func feedPagination() async throws {
        let feed = client.feed(
            for: .init(
                group: "user",
                id: "john",
                activityLimit: 10
            )
        )
        // Page 1
        try await feed.getOrCreate()
        let activities = feed.state.activities // First 10 activities

        // Page 2
        let page2Activities = try await feed.queryMoreActivities(limit: 10)
        
        let page1And2Activities = feed.state.activities
        
        suppressUnusedWarning(activities, page2Activities, page1And2Activities)
    }
    
    func filteringExamples() async throws {
        // Add a few activities
        let feedId = FeedId(group: "user", id: "john")
        try await client.upsertActivities([
            ActivityRequest(feeds: [feedId.rawValue], filterTags: ["green", "blue"], text: "first", type: "post"),
            ActivityRequest(feeds: [feedId.rawValue], filterTags: ["yellow", "blue"], text: "second", type: "post"),
            ActivityRequest(feeds: [feedId.rawValue], filterTags: ["orange"], text: "third", type: "activity")
        ])
        // Now read the feed, this will fetch activity 1 and 2
        let query = FeedQuery(feed: feedId, activityFilter: .in(.filterTags, ["blue"]))
        let feed = client.feed(for: query)
        try await feed.getOrCreate()
        let activities = feed.state.activities // contains first and second
        
        suppressUnusedWarning(activities)
    }
    
    func filteringExamples2() async throws {
        // Get all the activities where tags contain "green" and type is "post" or tag contains "orange" and type is "activity"
        let query = FeedQuery(
            group: "user",
            id: "john",
            activityFilter: .or([
                .and([
                    .in(.filterTags, ["green"]),
                    .equal(.activityType, "post")
                ]),
                .and([
                    .in(.filterTags, ["orange"]),
                    .equal(.activityType, "activity")
                ])
            ])
        )
        let feed = client.feed(for: query)
        try await feed.getOrCreate()
        let activities = feed.state.activities
        
        suppressUnusedWarning(activities)
    }
    
    func feedMembers() async throws {
        // The following methods are available to edit the members of a feed
        try await feed.updateFeedMembers(
            request: .init(
                members: [.init(
                    custom: ["joined": "2024-01-01"],
                    role: "moderator",
                    userId: "john"
                )],
                operation: .upsert
            )
        )
        // Remove members
        try await feed.updateFeedMembers(
            request: .init(
                members: [.init(userId: "john"), .init(userId: "jane")],
                operation: .remove
            )
        )
        // Set members (overwrites the list)
        try await feed.updateFeedMembers(
            request: .init(
                members: [.init(role: "moderator", userId: "john")],
                operation: .set
            )
        )
    }
    
    func memberRequests() async throws {
        // Request to become a member
        try await feed.updateFeedMembers(
            request: .init(
                members: [.init(
                    custom: ["reason": "community builder"],
                    invite: true,
                    role: "moderator",
                    userId: "john"
                )],
                operation: .upsert
            )
        )
        // Accept and reject member requests
        _ = try await feed.acceptFeedMember()
        _ = try await feed.rejectFeedMember()
    }
    
    func queryingMyFeeds() async throws {
        let query = FeedsQuery(
            filter: .equal(.createdById, "john"),
            sort: [Sort(field: .createdAt, direction: .reverse)],
            limit: 10,
            watch: true
        )
        let feedList = client.feedList(for: query)
        // Page 1
        let page1 = try await feedList.get()
        
        // Page 2
        let page2 = try await feedList.queryMoreFeeds(limit: 10)
        
        let page1And2 = feedList.state.feeds
        
        suppressUnusedWarning(page1, page2, page1And2)
    }
    
    func queryingFeedsWhereIAmAMember() async throws {
        let query = FeedsQuery(
            filter: .contains(.members, "john")
        )
        let feedList = client.feedList(for: query)
        let feeds = try await feedList.get()
        
        suppressUnusedWarning(feeds)
    }
    
    func queryingFeedsByNameOrDescription() async throws {
        let sportsQuery = FeedsQuery(
            filter: .and([
                .equal(.visibility, "public"),
                .query(.name, "Sports")
            ])
        )
        let sportsFeedList = client.feedList(for: sportsQuery)
        let sportsFeeds = try await sportsFeedList.get()
        
        let techQuery = FeedsQuery(
            filter: .and([
                .equal(.visibility, "public"),
                .autocomplete(.description, "tech")
            ])
        )
        let techFeedList = client.feedList(for: techQuery)
        let techFeeds = try await techFeedList.get()
        
        suppressUnusedWarning(sportsFeeds, techFeeds)
    }
    
    func queryingFeedsByCreatorName() async throws {
        let query = FeedsQuery(
            filter: .and([
                .equal(.visibility, "public"),
                .query(.createdByName, "Thompson")
            ])
        )
        let feedList = client.feedList(for: query)
        let feeds = try await feedList.get()
        
        suppressUnusedWarning(feeds)
    }
}
