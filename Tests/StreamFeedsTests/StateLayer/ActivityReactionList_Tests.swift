//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct ActivityReactionList_Tests {
    static let activityId = "activity-123"
    
    @Test func initialGetUpdatesState() async throws {
        let client = defaultClient()
        let reactionList = client.activityReactionList(
            for: ActivityReactionsQuery(activityId: Self.activityId)
        )
        let reactions = try await reactionList.get()
        let stateReactions = await reactionList.state.reactions
        #expect(reactions.map(\.id) == ["current-user-id-like-\(Self.activityId)"])
        #expect(stateReactions.map(\.id) == ["current-user-id-like-\(Self.activityId)"])
    }
    
    @Test func paginationLoadsMoreReactions() async throws {
        let client = defaultClient(
            additionalPayloads: [
                QueryActivityReactionsResponse.dummy(
                    reactions: [
                        .dummy(
                            activityId: Self.activityId,
                            createdAt: .fixed(offset: -1),
                            type: "heart",
                            user: .dummy(id: "other-user")
                        )
                    ],
                    next: nil
                )
            ]
        )

        let reactionList = client.activityReactionList(
            for: ActivityReactionsQuery(activityId: Self.activityId)
        )
        
        // Initial load
        #expect(try await reactionList.get().map(\.id) == ["current-user-id-like-\(Self.activityId)"])
        #expect(await reactionList.state.canLoadMore == true)
        
        // Load more
        let moreReactions = try await reactionList.queryMoreReactions()
        #expect(moreReactions.map(\.id) == ["other-user-heart-\(Self.activityId)"])
        #expect(await reactionList.state.canLoadMore == false)
        
        // Check final state
        let finalStateReactions = await reactionList.state.reactions
        #expect(finalStateReactions.map(\.id) == ["current-user-id-like-\(Self.activityId)", "other-user-heart-\(Self.activityId)"])
    }
    
    @Test func activityReactionAddedEventUpdatesState() async throws {
        let client = defaultClient()
        let reactionList = client.activityReactionList(
            for: ActivityReactionsQuery(activityId: Self.activityId)
        )
        try await reactionList.get()
        
        // Unrelated event
        await client.eventsMiddleware.sendEvent(
            ActivityReactionAddedEvent.dummy(
                activity: .dummy(id: "unrelated-activity"),
                fid: "user:test",
                reaction: .dummy(activityId: "unrelated-activity", type: "like")
            )
        )
        
        await client.eventsMiddleware.sendEvent(
            ActivityReactionAddedEvent.dummy(
                activity: .dummy(id: Self.activityId),
                fid: "user:test",
                reaction: .dummy(
                    activityId: Self.activityId,
                    createdAt: .fixed(offset: 1),
                    type: "heart",
                    user: .dummy(id: "other-user")
                )
            )
        )
        
        let result = await reactionList.state.reactions.map(\.id)
        #expect(result == ["other-user-heart-\(Self.activityId)", "current-user-id-like-\(Self.activityId)"], "Newest first")
    }
    
    @Test func activityReactionDeletedEventRemovesFromState() async throws {
        let client = defaultClient()
        let reactionList = client.activityReactionList(
            for: ActivityReactionsQuery(activityId: Self.activityId)
        )
        try await reactionList.get()
        
        await client.eventsMiddleware.sendEvent(
            ActivityReactionDeletedEvent.dummy(
                activity: .dummy(id: Self.activityId),
                fid: "user:test",
                reaction: .dummy(activityId: Self.activityId, type: "like", user: .dummy(id: "current-user-id"))
            )
        )
        
        let result = await reactionList.state.reactions
        #expect(result.isEmpty)
    }
    
    @Test func activityReactionUpdatedEventUpdatesState() async throws {
        let client = defaultClient()
        let reactionList = client.activityReactionList(
            for: ActivityReactionsQuery(activityId: Self.activityId)
        )
        try await reactionList.get()
        
        await client.eventsMiddleware.sendEvent(
            ActivityReactionUpdatedEvent.dummy(
                activity: .dummy(id: Self.activityId),
                fid: "user:test",
                reaction: .dummy(
                    activityId: Self.activityId,
                    custom: ["key": .string("UPDATED")],
                    type: "like",
                    user: .dummy(id: "current-user-id")
                )
            )
        )
        
        let reactions = await reactionList.state.reactions
        #expect(reactions.count == 1)
        #expect(reactions.first?.custom == ["key": .string("UPDATED")])
    }
    
    @Test func userUpdatedEventUpdatesUserInReactions() async throws {
        let client = defaultClient()
        let reactionList = client.activityReactionList(
            for: ActivityReactionsQuery(activityId: Self.activityId)
        )
        try await reactionList.get()
        
        await client.eventsMiddleware.sendEvent(
            UserUpdatedEvent.dummy(
                user: .dummy(id: "current-user-id", name: "Updated Name")
            )
        )
        
        let reactions = await reactionList.state.reactions
        #expect(reactions.count == 1)
        #expect(reactions.first?.user.name == "Updated Name")
    }
    
    @Test func eventsOnlyAffectMatchingActivity() async throws {
        let client = defaultClient()
        let reactionList = client.activityReactionList(
            for: ActivityReactionsQuery(activityId: Self.activityId)
        )
        try await reactionList.get()
        
        // Send event for different activity
        await client.eventsMiddleware.sendEvent(
            ActivityReactionAddedEvent.dummy(
                activity: .dummy(id: "other-activity"),
                fid: "user:test",
                reaction: .dummy(activityId: "other-activity", type: "heart")
            )
        )
        
        let result = await reactionList.state.reactions.map(\.id)
        #expect(result == ["current-user-id-like-\(Self.activityId)"]) // Should not include other activity's reaction
    }
    
    @Test func eventsOnlyAffectMatchingFilter() async throws {
        let client = defaultClient()
        let reactionList = client.activityReactionList(
            for: ActivityReactionsQuery(
                activityId: Self.activityId,
                filter: .equal(.reactionType, "like")
            )
        )
        try await reactionList.get()
        
        // Send event for different reaction type
        await client.eventsMiddleware.sendEvent(
            ActivityReactionAddedEvent.dummy(
                activity: .dummy(id: Self.activityId),
                fid: "user:test",
                reaction: .dummy(activityId: Self.activityId, type: "heart")
            )
        )
        
        let result = await reactionList.state.reactions.map(\.id)
        #expect(result == ["current-user-id-like-\(Self.activityId)"]) // Should not include heart reaction
    }
    
    // MARK: -
    
    private func defaultClient(
        reactions: [FeedsReactionResponse] = [.dummy(activityId: Self.activityId, type: "like", user: .dummy(id: "current-user-id"))],
        additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryActivityReactionsResponse.dummy(
                        reactions: reactions,
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
