//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct CommentReactionList_Tests {
    static let commentId = "comment-123"
    
    @Test func initialGetUpdatesState() async throws {
        let client = defaultClient()
        let reactionList = client.commentReactionList(
            for: CommentReactionsQuery(commentId: Self.commentId)
        )
        let reactions = try await reactionList.get()
        let stateReactions = await reactionList.state.reactions
        #expect(reactions.map(\.id) == ["current-user-id-like-comment-123-activity-123"])
        #expect(stateReactions.map(\.id) == ["current-user-id-like-comment-123-activity-123"])
    }
    
    @Test func paginationLoadsMoreReactions() async throws {
        let client = defaultClient(
            additionalPayloads: [
                QueryCommentReactionsResponse.dummy(
                    reactions: [
                        .dummy(
                            commentId: Self.commentId,
                            createdAt: .fixed(offset: -1),
                            type: "heart",
                            user: .dummy(id: "other-user")
                        )
                    ],
                    next: nil
                )
            ]
        )

        let reactionList = client.commentReactionList(
            for: CommentReactionsQuery(commentId: Self.commentId)
        )
        
        // Initial load
        #expect(try await reactionList.get().map(\.id) == ["current-user-id-like-comment-123-activity-123"])
        #expect(await reactionList.state.canLoadMore == true)
        
        // Load more
        let moreReactions = try await reactionList.queryMoreReactions()
        #expect(moreReactions.map(\.id) == ["other-user-heart-comment-123-activity-123"])
        #expect(await reactionList.state.canLoadMore == false)
        
        // Check final state
        let finalStateReactions = await reactionList.state.reactions
        #expect(finalStateReactions.map(\.id) == ["current-user-id-like-comment-123-activity-123", "other-user-heart-comment-123-activity-123"], "Newest first")
    }
    
    @Test func commentReactionAddedEventUpdatesState() async throws {
        let client = defaultClient()
        let reactionList = client.commentReactionList(
            for: CommentReactionsQuery(commentId: Self.commentId)
        )
        try await reactionList.get()
        
        // Send reaction added event
        await client.eventsMiddleware.sendEvent(
            CommentReactionAddedEvent.dummy(
                comment: .dummy(
                    id: Self.commentId,
                    objectId: "activity-123"
                ),
                fid: "user:test",
                reaction: .dummy(commentId: Self.commentId, createdAt: .fixed(offset: 1), type: "heart", user: .dummy(id: "other-user"))
            )
        )
        
        let result = await reactionList.state.reactions.map(\.id)
        #expect(result == ["other-user-heart-comment-123-activity-123", "current-user-id-like-comment-123-activity-123"])
        let reactions = await reactionList.state.reactions
        #expect(reactions.map(\.type) == ["heart", "like"])
        #expect(reactions.map(\.user.id) == ["other-user", "current-user-id"])
    }
    
    @Test func commentReactionUpdatedEventUpdatesState() async throws {
        let client = defaultClient()
        let reactionList = client.commentReactionList(
            for: CommentReactionsQuery(commentId: Self.commentId)
        )
        try await reactionList.get()
        
        // Send reaction updated event
        await client.eventsMiddleware.sendEvent(
            CommentReactionUpdatedEvent.dummy(
                comment: .dummy(id: Self.commentId, objectId: "activity-123"),
                fid: "user:test", reaction: .dummy(commentId: Self.commentId, custom: ["key": .string("UPDATED")], type: "like", user: .dummy(id: "current-user-id"))
            )
        )
        
        let result = await reactionList.state.reactions.map(\.id)
        #expect(result == ["current-user-id-like-comment-123-activity-123"])
        let updatedReaction = await reactionList.state.reactions.first
        #expect(updatedReaction?.custom == ["key": RawJSON.string("UPDATED")])
    }
    
    @Test func commentReactionDeletedEventUpdatesState() async throws {
        let client = defaultClient()
        let reactionList = client.commentReactionList(
            for: CommentReactionsQuery(commentId: Self.commentId)
        )
        try await reactionList.get()
        
        // Send reaction deleted event
        await client.eventsMiddleware.sendEvent(
            CommentReactionDeletedEvent.dummy(
                comment: .dummy(id: Self.commentId, objectId: "activity-123"),
                fid: "user:test", reaction: .dummy(commentId: Self.commentId, type: "like", user: .dummy(id: "current-user-id"))
            )
        )
        
        let result = await reactionList.state.reactions.map(\.id)
        #expect(result == []) // Reaction should be removed
    }
    
    @Test func eventsOnlyAffectMatchingComment() async throws {
        let client = defaultClient()
        let reactionList = client.commentReactionList(
            for: CommentReactionsQuery(commentId: Self.commentId)
        )
        try await reactionList.get()
        
        // Send event for different comment
        await client.eventsMiddleware.sendEvent(
            CommentReactionDeletedEvent.dummy(
                comment: .dummy(id: "comment-456", objectId: "activity-123"),
                fid: "user:test", reaction: .dummy(commentId: "comment-456", type: "like", user: .dummy(id: "current-user-id"))
            )
        )
        
        let result = await reactionList.state.reactions.map(\.id)
        #expect(result == ["current-user-id-like-comment-123-activity-123"]) // Should not be affected
    }
    
    @Test func addedEventsOnlyAffectMatchingComment() async throws {
        let client = defaultClient()
        let reactionList = client.commentReactionList(
            for: CommentReactionsQuery(commentId: Self.commentId)
        )
        try await reactionList.get()
        
        // Send added event for different comment
        await client.eventsMiddleware.sendEvent(
            CommentReactionAddedEvent.dummy(
                comment: .dummy(id: "comment-456", objectId: "activity-123"),
                fid: "user:test", reaction: .dummy(commentId: "comment-456", type: "heart", user: .dummy(id: "other-user"))
            )
        )
        
        let result = await reactionList.state.reactions.map(\.id)
        #expect(result == ["current-user-id-like-comment-123-activity-123"])
        let reaction = await reactionList.state.reactions.first
        #expect(reaction?.type == "like") // Should remain unchanged
    }
    
    @Test func updatedEventsOnlyAffectMatchingComment() async throws {
        let client = defaultClient()
        let reactionList = client.commentReactionList(
            for: CommentReactionsQuery(commentId: Self.commentId)
        )
        try await reactionList.get()
        
        // Send updated event for different comment
        await client.eventsMiddleware.sendEvent(
            CommentReactionUpdatedEvent.dummy(
                comment: .dummy(id: "comment-456", objectId: "activity-123"),
                fid: "user:test", reaction: .dummy(commentId: "comment-456", type: "heart", user: .dummy(id: "current-user-id"))
            )
        )
        
        let result = await reactionList.state.reactions.map(\.id)
        #expect(result == ["current-user-id-like-comment-123-activity-123"])
        let reaction = await reactionList.state.reactions.first
        #expect(reaction?.type == "like")
    }
    
    // MARK: -
    
    private func defaultClient(
        reactions: [FeedsReactionResponse] = [.dummy(commentId: Self.commentId, type: "like", user: .dummy(id: "current-user-id"))],
        additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryCommentReactionsResponse.dummy(
                        reactions: reactions,
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
