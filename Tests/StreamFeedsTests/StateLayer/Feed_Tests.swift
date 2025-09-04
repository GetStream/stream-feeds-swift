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
                fid: feed.feed.rawValue,
                activity: .dummy(id: "new-activity", text: "New activity content")
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
                fid: feed.feed.rawValue,
                activity: .dummy(
                    id: "expiring-activity",
                    text: "This activity expires",
                    expiresAt: Date.fixed().addingTimeInterval(3600)
                )
            )
        )
        
        // Send activity without expiresAt - should be ignored
        await client.eventsMiddleware.sendEvent(
            ActivityAddedEvent.dummy(
                fid: feed.feed.rawValue,
                activity: .dummy(
                    id: "non-expiring-activity",
                    text: "This activity doesn't expire",
                    expiresAt: nil
                )
            )
        )
        
        // Verify only the activity with expiresAt was inserted
        let finalActivities = await feed.state.activities
        #expect(finalActivities.count == 1)
        #expect(finalActivities.first?.id == "expiring-activity")
        #expect(finalActivities.first?.text == "This activity expires")
    }
    
    @Test func activityAddedEventWithoutMatchingActivitiesFilterIsIgnored() async throws {}
    
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
                fid: feed.feed.rawValue,
                activity: .dummy(id: "1", text: "NEW TEXT")
            )
        )
        let result = await feed.state.activities.first?.text
        #expect(result == "NEW TEXT")
    }
}
