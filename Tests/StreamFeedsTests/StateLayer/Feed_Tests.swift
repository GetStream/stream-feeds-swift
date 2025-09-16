//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct Feed_Tests {
    @Test func getOrCreateUpdatesState() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetOrCreateFeedResponse.dummy(activities: [.dummy(id: "1")])
            ])
        )
        let feed = client.feed(group: "user", id: "jane")
        let feedData = try await feed.getOrCreate()
        let stateActivities = await feed.state.activities
        let stateFeedData = await feed.state.feedData
        #expect(stateActivities.map(\.id) == ["1"])
        #expect(stateFeedData == feedData)
    }
    
    @Test func activityAddedEventWithoutActivitiesFilterIsInserted() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetOrCreateFeedResponse.dummy(activities: [])
            ])
        )
        let feed = client.feed(group: "user", id: "jane")
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.isEmpty)
        
        await client.eventsMiddleware.sendEvent(
            ActivityAddedEvent.dummy(
                activity: .dummy(id: "new-activity", text: "New activity content"),
                fid: feed.feed.rawValue
            )
        )
        
        let finalActivities = await feed.state.activities
        #expect(finalActivities.count == 1)
        #expect(finalActivities.first?.id == "new-activity")
        #expect(finalActivities.first?.text == "New activity content")
    }
    
    @Test func activityAddedEventWithMatchingActivitiesFilterIsInserted() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetOrCreateFeedResponse.dummy(activities: [])
            ])
        )
        let feed = client.feed(
            for: FeedQuery(
                group: "user",
                id: "jane",
                activityFilter: .exists(.expiresAt, true)
            )
        )
        try await feed.getOrCreate()
                
        // Send activity with expiresAt - should be inserted
        await client.eventsMiddleware.sendEvent(
            ActivityAddedEvent.dummy(
                activity: .dummy(
                    expiresAt: Date.fixed().addingTimeInterval(3600),
                    id: "expiring-activity",
                    text: "This activity expires"
                ),
                fid: feed.feed.rawValue
            )
        )
        
        // Send activity without expiresAt - should be ignored
        await client.eventsMiddleware.sendEvent(
            ActivityAddedEvent.dummy(
                activity: .dummy(
                    expiresAt: nil,
                    id: "non-expiring-activity",
                    text: "This activity doesn't expire"
                ),
                fid: feed.feed.rawValue
            )
        )
        
        // Verify only the activity with expiresAt was inserted
        let finalActivities = await feed.state.activities
        #expect(finalActivities.count == 1)
        #expect(finalActivities.first?.id == "expiring-activity")
        #expect(finalActivities.first?.text == "This activity expires")
    }
    
    @Test func activityAddedEventWithoutMatchingActivitiesFilterIsIgnored() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetOrCreateFeedResponse.dummy(activities: [])
            ])
        )
        let feed = client.feed(
            for: FeedQuery(
                group: "user",
                id: "jane",
                activityFilter: .exists(.expiresAt, true)
            )
        )
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.isEmpty)
        
        // Send activity without expiresAt - should be ignored due to filter
        await client.eventsMiddleware.sendEvent(
            ActivityAddedEvent.dummy(
                activity: .dummy(
                    expiresAt: nil,
                    id: "non-expiring-activity",
                    text: "This activity doesn't expire"
                ),
                fid: feed.feed.rawValue
            )
        )
        
        // Verify the activity was ignored and not inserted
        let finalActivities = await feed.state.activities
        #expect(finalActivities.isEmpty)
    }
    
    @Test func activityUpdatedEventChangesText() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetOrCreateFeedResponse.dummy(activities: [.dummy(id: "1")])
            ])
        )
        let feed = client.feed(group: "user", id: "jane")
        try await feed.getOrCreate()
        
        await client.eventsMiddleware.sendEvent(
            ActivityUpdatedEvent.dummy(
                activity: .dummy(id: "1", text: "NEW TEXT"),
                fid: feed.feed.rawValue
            )
        )
        let result = await feed.state.activities.first?.text
        #expect(result == "NEW TEXT")
    }
    
    @Test func activityUpdatedEventIsNotInsertedToFeedIfItWasNotPaginated() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetOrCreateFeedResponse.dummy(activities: [.dummy(id: "1")])
            ])
        )
        let feed = client.feed(group: "user", id: "jane")
        try await feed.getOrCreate()
        
        await #expect(feed.state.activities.map(\.id) == ["1"])
        
        await client.eventsMiddleware.sendEvent(
            ActivityUpdatedEvent.dummy(
                activity: .dummy(id: "2"),
                fid: feed.feed.rawValue
            )
        )
        await #expect(feed.state.activities.map(\.id) == ["1"])
    }
}
