//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct ActivityList_Tests {
    static let feedId = FeedId(group: "user", id: "test")
    
    @Test func initialGetUpdatesState() async throws {
        let client = defaultClient()
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        let activities = try await activityList.get()
        let stateActivities = await activityList.state.activities
        #expect(activities.map(\.id) == ["activity-1"])
        #expect(stateActivities.map(\.id) == ["activity-1"])
    }
    
    @Test func paginationLoadsMoreActivities() async throws {
        let client = defaultClient(
            additionalPayloads: [
                QueryActivitiesResponse.dummy(
                    activities: [
                        .dummy(
                            createdAt: .fixed(offset: -1),
                            id: "activity-2",
                            user: .dummy(id: "current-user-id")
                        )
                    ],
                    next: nil
                )
            ]
        )

        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        
        // Initial load
        #expect(try await activityList.get().map(\.id) == ["activity-1"])
        #expect(await activityList.state.canLoadMore == true)
        
        // Load more
        let moreActivities = try await activityList.queryMoreActivities()
        #expect(moreActivities.map(\.id) == ["activity-2"])
        #expect(await activityList.state.canLoadMore == false)
        
        // Check final state
        let finalStateActivities = await activityList.state.activities
        #expect(finalStateActivities.map(\.id) == ["activity-1", "activity-2"], "Newest first")
    }
    
    @Test func activityAddedEventUpdatesState() async throws {
        let client = defaultClient()
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        
        // Unrelated event
        await client.eventsMiddleware.sendEvent(
            ActivityAddedEvent.dummy(
                activity: .dummy(id: "should-not-be-added", user: .dummy(id: "other-user")),
                fid: "user:other"
            )
        )
        
        await client.eventsMiddleware.sendEvent(
            ActivityAddedEvent.dummy(
                activity: .dummy(
                    createdAt: .fixed(offset: 1),
                    id: "activity-2",
                    user: .dummy(id: "current-user-id")
                ),
                fid: Self.feedId.rawValue
            )
        )
        
        let result = await activityList.state.activities.map(\.id)
        #expect(result == ["activity-2", "activity-1"], "Newest first")
    }
    
    @Test func activityUpdatedEventUpdatesState() async throws {
        let client = defaultClient()
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        
        await client.eventsMiddleware.sendEvent(
            ActivityUpdatedEvent.dummy(
                activity: .dummy(id: "activity-1", text: "Updated text", user: .dummy(id: "current-user-id")),
                fid: Self.feedId.rawValue
            )
        )
        
        let activities = await activityList.state.activities
        #expect(activities.count == 1)
        #expect(activities.first?.text == "Updated text")
    }
    
    @Test func activityUpdatedEventRemovesActivityWhenNoLongerMatchingQuery() async throws {
        let client = defaultClient()
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        
        // Verify initial state has the activity
        let initialActivities = await activityList.state.activities
        #expect(initialActivities.count == 1)
        #expect(initialActivities.first?.id == "activity-1")
        #expect(initialActivities.first?.user.id == "current-user-id")
        
        // Send activity updated event where the user changes to someone else
        // This should cause the activity to no longer match the query filter
        await client.eventsMiddleware.sendEvent(
            ActivityUpdatedEvent.dummy(
                activity: .dummy(id: "activity-1", text: "Updated text", user: .dummy(id: "other-user")),
                fid: Self.feedId.rawValue
            )
        )
        
        // Activity should be removed since it no longer matches the userId filter
        let activitiesAfterUpdate = await activityList.state.activities
        #expect(activitiesAfterUpdate.isEmpty)
    }
    
    @Test func activityDeletedEventRemovesFromState() async throws {
        let client = defaultClient()
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        
        await client.eventsMiddleware.sendEvent(
            ActivityDeletedEvent.dummy(
                activityId: "activity-1",
                fid: Self.feedId.rawValue
            )
        )
        
        let result = await activityList.state.activities
        #expect(result.isEmpty)
    }
    
    @Test func activityReactionAddedEventUpdatesState() async throws {
        let client = defaultClient()
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        
        await client.eventsMiddleware.sendEvent(
            ActivityReactionAddedEvent.dummy(
                activity: .dummy(id: "activity-1", reactionCount: 1, reactionGroups: ["like": .dummy()], user: .dummy(id: "current-user-id")),
                fid: Self.feedId.rawValue,
                reaction: .dummy(type: "like", user: .dummy(id: "current-user-id"))
            )
        )
        
        let activities = await activityList.state.activities
        #expect(activities.count == 1)
        let activity = try #require(activities.first)
        #expect(activity.ownReactions.first?.type == "like")
        #expect(activity.reactionCount == 1)
        #expect(activity.reactionGroups.count == 1)
        #expect(activity.reactionGroups["like"]?.count == 1)
    }
    
    @Test func activityReactionDeletedEventUpdatesState() async throws {
        let client = defaultClient(
            activities: [
                .dummy(
                    id: "activity-1",
                    ownReactions: [.dummy(type: "like", user: .dummy(id: "current-user-id"))],
                    reactionCount: 1,
                    reactionGroups: ["like": .dummy(count: 1)],
                    user: .dummy(id: "current-user-id")
                )
            ]
        )
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        
        await client.eventsMiddleware.sendEvent(
            ActivityReactionDeletedEvent.dummy(
                activity: .dummy(id: "activity-1", user: .dummy(id: "current-user-id")),
                fid: Self.feedId.rawValue,
                reaction: .dummy(type: "like", user: .dummy(id: "current-user-id"))
            )
        )
        
        let activities = await activityList.state.activities
        #expect(activities.count == 1)
        let activity = try #require(activities.first)
        #expect(activity.ownReactions.isEmpty)
        #expect(activity.reactionCount == 0)
        #expect(activity.reactionGroups.isEmpty)
    }
    
    @Test func activityReactionUpdatedEventUpdatesState() async throws {
        let client = defaultClient(
            activities: [
                .dummy(
                    id: "activity-1",
                    ownReactions: [.dummy(type: "like", user: .dummy(id: "current-user-id"))],
                    reactionCount: 1,
                    reactionGroups: ["like": .dummy(count: 1)],
                    user: .dummy(id: "current-user-id")
                )
            ]
        )
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        
        await client.eventsMiddleware.sendEvent(
            ActivityReactionUpdatedEvent.dummy(
                activity: .dummy(id: "activity-1", reactionCount: 1, reactionGroups: ["like": .dummy()], user: .dummy(id: "current-user-id")),
                fid: Self.feedId.rawValue,
                reaction: .dummy(
                    custom: ["key": .string("UPDATED")],
                    type: "like",
                    user: .dummy(id: "current-user-id")
                )
            )
        )
        
        let activities = await activityList.state.activities
        #expect(activities.count == 1)
        let activity = try #require(activities.first)
        #expect(activity.ownReactions.first?.custom == ["key": .string("UPDATED")])
        #expect(activity.ownReactions.map(\.type) == ["like"])
        #expect(activity.reactionCount == 1)
        #expect(activity.reactionGroups.count == 1)
        #expect(activity.reactionGroups["like"]?.count == 1)
    }
    
    @Test func bookmarkAddedEventUpdatesState() async throws {
        let client = defaultClient()
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        
        await client.eventsMiddleware.sendEvent(
            BookmarkAddedEvent.dummy(
                bookmark: .dummy(
                    activity: .dummy(bookmarkCount: 1, id: "activity-1", user: .dummy(id: "current-user-id")),
                    user: .dummy(id: "current-user-id")
                )
            )
        )
        
        let activities = await activityList.state.activities
        #expect(activities.count == 1)
        let activity = try #require(activities.first)
        #expect(activity.ownBookmarks.count == 1)
        #expect(activity.bookmarkCount == 1)
    }
    
    @Test func bookmarkDeletedEventUpdatesState() async throws {
        let client = defaultClient(
            activities: [
                .dummy(
                    bookmarkCount: 1,
                    id: "activity-1",
                    ownBookmarks: [.dummy(
                        activity: .dummy(id: "activity-1"),
                        user: .dummy(id: "current-user-id")
                    )],
                    user: .dummy(id: "current-user-id")
                )
            ]
        )
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        
        await client.eventsMiddleware.sendEvent(
            BookmarkDeletedEvent.dummy(
                bookmark: .dummy(
                    activity: .dummy(id: "activity-1", user: .dummy(id: "current-user-id")),
                    user: .dummy(id: "current-user-id")
                )
            )
        )
        
        let activities = await activityList.state.activities
        #expect(activities.count == 1)
        let activity = try #require(activities.first)
        #expect(activity.ownBookmarks.isEmpty)
        #expect(activity.bookmarkCount == 0)
    }
    
    @Test func commentAddedEventUpdatesState() async throws {
        let client = defaultClient()
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        
        await client.eventsMiddleware.sendEvent(
            CommentAddedEvent.dummy(
                activity: .dummy(id: "activity-1", user: .dummy(id: "current-user-id")),
                comment: .dummy(id: "comment-2", objectId: "activity-1"),
                fid: Self.feedId.rawValue
            )
        )
        
        let activities = await activityList.state.activities
        #expect(activities.count == 1)
        let activity = try #require(activities.first)
        #expect(activity.commentCount == 2) // Original + new comment
    }
    
    @Test func commentDeletedEventUpdatesState() async throws {
        let client = defaultClient(
            activities: [.dummy(
                comments: [.dummy(id: "comment-1", objectId: "activity-1")],
                id: "activity-1",
                user: .dummy(id: "current-user-id")
            )]
        )
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        
        await client.eventsMiddleware.sendEvent(
            CommentDeletedEvent.dummy(
                comment: .dummy(id: "comment-1", objectId: "activity-1"),
                fid: Self.feedId.rawValue,
                user: .dummy(id: "current-user-id")
            )
        )
        
        let activities = await activityList.state.activities
        #expect(activities.count == 1)
        let activity = try #require(activities.first)
        #expect(activity.commentCount == 0)
    }
    
    @Test func pollUpdatedEventUpdatesState() async throws {
        let client = defaultClient(
            activities: [
                .dummy(
                    id: "activity-1",
                    poll: .dummy(id: "poll-1", name: "Original Poll"),
                    user: .dummy(id: "current-user-id")
                )
            ]
        )
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        
        await client.eventsMiddleware.sendEvent(
            PollUpdatedFeedEvent.dummy(
                fid: Self.feedId.rawValue,
                poll: .dummy(id: "poll-1", name: "Updated Poll")
            )
        )
        
        let activities = await activityList.state.activities
        #expect(activities.count == 1)
        let activity = try #require(activities.first)
        #expect(activity.poll?.name == "Updated Poll")
    }
    
    @Test func pollDeletedEventUpdatesState() async throws {
        let client = defaultClient(
            activities: [
                .dummy(
                    id: "activity-1",
                    poll: .dummy(id: "poll-1", name: "Test Poll"),
                    user: .dummy(id: "current-user-id")
                )
            ]
        )
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        
        await client.eventsMiddleware.sendEvent(
            PollDeletedFeedEvent.dummy(
                fid: Self.feedId.rawValue,
                poll: .dummy(id: "poll-1")
            )
        )
        
        let activities = await activityList.state.activities
        #expect(activities.count == 1)
        let activity = try #require(activities.first)
        #expect(activity.poll == nil)
    }
    
    @Test func eventsOnlyAffectMatchingUser() async throws {
        let client = defaultClient(
            activities: [.dummy(id: "activity-1", user: .dummy(id: "current-user-id"))]
        )
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        
        // Send event for different user
        await client.eventsMiddleware.sendEvent(
            ActivityAddedEvent.dummy(
                activity: .dummy(id: "activity-2", user: .dummy(id: "other-user")),
                fid: "user:other"
            )
        )
        
        let result = await activityList.state.activities.map(\.id)
        #expect(result == ["activity-1"]) // Should not include activity-2
    }
    
    @Test func eventsOnlyAffectMatchingFilter() async throws {
        let client = defaultClient(
            activities: [.dummy(id: "activity-1", type: "post", user: .dummy(id: "current-user-id"))]
        )
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .and([
                    .equal(.userId, "current-user-id"),
                    .equal(.type, "post")
                ])
            )
        )
        try await activityList.get()
        
        // Send event for different activity type
        await client.eventsMiddleware.sendEvent(
            ActivityAddedEvent.dummy(
                activity: .dummy(id: "activity-2", type: "comment", user: .dummy(id: "current-user-id")),
                fid: Self.feedId.rawValue
            )
        )
        
        let result = await activityList.state.activities.map(\.id)
        #expect(result == ["activity-1"]) // Should not include activity-2
    }
    
    // MARK: - Own Capabilities
    
    @Test func getCachesCapabilities() async throws {
        let feed1Id = FeedId(rawValue: "user:feed-1")
        let feed2Id = FeedId(rawValue: "user:feed-2")
        let feed3Id = FeedId(rawValue: "user:feed-3")
        
        let client = FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryActivitiesResponse.dummy(
                        activities: [
                            .dummy(
                                currentFeed: .dummy(feed: feed1Id.rawValue, ownCapabilities: [.readFeed, .addActivity]),
                                id: "activity-1",
                                user: .dummy(id: "current-user-id")
                            ),
                            .dummy(
                                currentFeed: .dummy(feed: feed2Id.rawValue, ownCapabilities: [.readFeed, .readActivities]),
                                id: "activity-2",
                                user: .dummy(id: "current-user-id")
                            ),
                            .dummy(
                                currentFeed: .dummy(feed: feed3Id.rawValue, ownCapabilities: [.readFeed, .addComment]),
                                id: "activity-3",
                                user: .dummy(id: "current-user-id")
                            )
                        ],
                        next: nil
                    )
                ]
            )
        )
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        _ = try await activityList.get()
        
        let expectedCapabilitiesMap: [FeedId: Set<FeedOwnCapability>] = [
            feed1Id: [.readFeed, .addActivity],
            feed2Id: [.readFeed, .readActivities],
            feed3Id: [.readFeed, .addComment]
        ]
        
        let cached = try #require(client.ownCapabilitiesRepository.capabilities(for: Set(expectedCapabilitiesMap.keys)))
        #expect(cached.keys.map(\.rawValue).sorted() == expectedCapabilitiesMap.keys.map(\.rawValue).sorted())
        
        for (feedId, expectedCapabilities) in expectedCapabilitiesMap {
            #expect(cached[feedId] == expectedCapabilities)
        }
    }
    
    @Test func feedOwnCapabilitiesUpdatedEventUpdatesState() async throws {
        let activityListCapabilities: (ActivityList) async -> [FeedId: Set<FeedOwnCapability>] = { activityList in
            let pairs = await activityList.state.activities.compactMap { activity -> (FeedId, Set<FeedOwnCapability>)? in
                guard let feedData = activity.currentFeed, let capabilities = feedData.ownCapabilities else { return nil }
                return (feedData.feed, capabilities)
            }
            return Dictionary(pairs, uniquingKeysWith: { $1 })
        }
        let feed1Id = FeedId(group: "user", id: "feed-1")
        let feed2Id = FeedId(group: "user", id: "feed-2")
        let initialFeed1Capabilities: Set<FeedOwnCapability> = [.readFeed, .addActivity]
        let initialFeed2Capabilities: Set<FeedOwnCapability> = [.readFeed, .readActivities]
        let initialCapabilities = [feed1Id: initialFeed1Capabilities, feed2Id: initialFeed2Capabilities]
        
        let client = FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryActivitiesResponse.dummy(
                        activities: [
                            .dummy(
                                currentFeed: .dummy(feed: feed1Id.rawValue, ownCapabilities: Array(initialFeed1Capabilities)),
                                id: "activity-1",
                                user: .dummy(id: "current-user-id")
                            ),
                            .dummy(
                                currentFeed: .dummy(feed: feed2Id.rawValue, ownCapabilities: Array(initialFeed2Capabilities)),
                                id: "activity-2",
                                user: .dummy(id: "current-user-id")
                            )
                        ],
                        next: nil
                    )
                ]
            )
        )
        let activityList = client.activityList(
            for: ActivitiesQuery(
                filter: .equal(.userId, "current-user-id")
            )
        )
        try await activityList.get()
        await #expect(activityListCapabilities(activityList) == initialCapabilities)
        
        // Send unmatching event first - should be ignored
        await client.stateLayerEventPublisher.sendEvent(
            .feedOwnCapabilitiesUpdated([
                FeedId(rawValue: "user:someoneelse"): [.readFeed, .addActivity, .deleteOwnActivity]
            ])
        )
        await #expect(activityListCapabilities(activityList) == initialCapabilities)
        
        // Send matching event with updated capabilities for feed1
        let newFeed1Capabilities: Set<FeedOwnCapability> = [.readFeed, .addActivity, .updateOwnActivity]
        await client.stateLayerEventPublisher.sendEvent(
            .feedOwnCapabilitiesUpdated([feed1Id: newFeed1Capabilities])
        )
        await #expect(activityListCapabilities(activityList)[feed1Id] == newFeed1Capabilities)
        await #expect(activityListCapabilities(activityList)[feed2Id] == initialFeed2Capabilities)
        
        // Send matching event with updated capabilities for feed2
        let newFeed2Capabilities: Set<FeedOwnCapability> = [.readFeed, .readActivities, .addComment]
        await client.stateLayerEventPublisher.sendEvent(
            .feedOwnCapabilitiesUpdated([feed2Id: newFeed2Capabilities])
        )
        await #expect(activityListCapabilities(activityList)[feed1Id] == newFeed1Capabilities)
        await #expect(activityListCapabilities(activityList)[feed2Id] == newFeed2Capabilities)
    }
    
    // MARK: -
    
    private func defaultClient(
        activities: [ActivityResponse] = [.dummy(id: "activity-1", user: .dummy(id: "current-user-id"))],
        additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryActivitiesResponse.dummy(
                        activities: activities,
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
