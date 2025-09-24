//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct CommentList_Tests {
    static let activityId = "activity-123"
    
    @Test func initialGetUpdatesState() async throws {
        let client = defaultClient()
        let commentList = client.commentList(
            for: CommentsQuery(
                filter: .and([
                    .equal(.objectId, Self.activityId),
                    .equal(.objectType, "activity")
                ])
            )
        )
        let comments = try await commentList.get()
        let stateComments = await commentList.state.comments
        #expect(comments.map(\.id) == ["comment-1"])
        #expect(stateComments.map(\.id) == ["comment-1"])
    }
    
    @Test func paginationLoadsMoreComments() async throws {
        // Sort by newest first
        let client = defaultClient(
            additionalPayloads:
            [
                GetCommentsResponse.dummy(
                    comments: [
                        .dummy(
                            createdAt: .fixed(offset: -1),
                            id: "comment-2",
                            objectId: Self.activityId
                        )
                    ],
                    next: nil
                )
            ]
        )

        let commentList = client.commentList(
            for: CommentsQuery(
                filter: .and([
                    .equal(.objectId, Self.activityId),
                    .equal(.objectType, "activity")
                ])
            )
        )
        
        // Initial load
        #expect(try await commentList.get().map(\.id) == ["comment-1"])
        #expect(await commentList.state.canLoadMore == true)
        
        // Load more
        let moreComments = try await commentList.queryMoreComments()
        #expect(moreComments.map(\.id) == ["comment-2"])
        #expect(await commentList.state.canLoadMore == false)
        
        // Check final state
        let finalStateComments = await commentList.state.comments
        #expect(finalStateComments.map(\.id) == ["comment-1", "comment-2"], "Newest first")
    }
    
    @Test func commentAddedEventUpdatesState() async throws {
        let client = defaultClient()
        let commentList = client.commentList(
            for: CommentsQuery(
                filter: .and([
                    .equal(.objectId, Self.activityId),
                    .equal(.objectType, "activity")
                ])
            )
        )
        try await commentList.get()
        
        // Unrelated event
        await client.eventsMiddleware.sendEvent(
            CommentAddedEvent.dummy(
                activity: .dummy(id: "unrelated"),
                comment: .dummy(id: "should-not-be-added", objectId: "unrelated"),
                fid: "user:test"
            )
        )
        
        await client.eventsMiddleware.sendEvent(
            CommentAddedEvent.dummy(
                activity: .dummy(id: Self.activityId),
                comment: .dummy(createdAt: .fixed(offset: 1), id: "comment-2", objectId: Self.activityId),
                fid: "user:test"
            )
        )
        
        let result = await commentList.state.comments.map(\.id)
        #expect(result == ["comment-2", "comment-1"], "Newest first")
    }
    
    @Test func commentsAddedBatchEventUpdatesState() async throws {
        let client = defaultClient()
        let commentList = client.commentList(
            for: CommentsQuery(
                filter: .and([
                    .equal(.objectId, Self.activityId),
                    .equal(.objectType, "activity")
                ])
            )
        )
        try await commentList.get()
        
        // Verify initial state
        let initialComments = await commentList.state.comments
        #expect(initialComments.map(\.id) == ["comment-1"])
        
        // Send batch of new comments
        let newComments = [
            CommentResponse.dummy(
                createdAt: .fixed(offset: 1),
                id: "comment-2",
                objectId: Self.activityId,
                text: "Second comment"
            ).toModel(),
            CommentResponse.dummy(
                createdAt: .fixed(offset: 2),
                id: "comment-3",
                objectId: Self.activityId,
                text: "Third comment"
            ).toModel()
        ]
        
        await client.stateLayerEventPublisher.sendEvent(
            .commentsAddedBatch(newComments, Self.activityId, FeedId(group: "user", id: "test"))
        )
        
        // Verify all comments are added and sorted by newest first
        let finalComments = await commentList.state.comments
        #expect(finalComments.map(\.id) == ["comment-3", "comment-2", "comment-1"])
        #expect(finalComments.map(\.text) == ["Third comment", "Second comment", "Test comment"])
    }
    
    @Test func commentUpdatedEventUpdatesState() async throws {
        let client = defaultClient()
        let commentList = client.commentList(
            for: CommentsQuery(
                filter: .and([
                    .equal(.objectId, Self.activityId),
                    .equal(.objectType, "activity")
                ])
            )
        )
        try await commentList.get()
        
        await client.eventsMiddleware.sendEvent(
            CommentUpdatedEvent.dummy(
                comment: .dummy(id: "comment-1", objectId: Self.activityId, text: "Updated text"),
                fid: "user:test"
            )
        )
        
        let comments = await commentList.state.comments
        #expect(comments.count == 1)
        #expect(comments.first?.text == "Updated text")
    }
    
    @Test func commentDeletedEventRemovesFromState() async throws {
        let client = defaultClient()
        let commentList = client.commentList(
            for: CommentsQuery(
                filter: .and([
                    .equal(.objectId, Self.activityId),
                    .equal(.objectType, "activity")
                ])
            )
        )
        try await commentList.get()
        
        await client.eventsMiddleware.sendEvent(
            CommentDeletedEvent.dummy(
                comment: .dummy(id: "comment-1", objectId: Self.activityId),
                fid: "user:test"
            )
        )
        
        let result = await commentList.state.comments
        #expect(result.isEmpty)
    }
    
    @Test func commentReactionAddedEventUpdatesState() async throws {
        let client = defaultClient()
        let commentList = client.commentList(
            for: CommentsQuery(
                filter: .and([
                    .equal(.objectId, Self.activityId),
                    .equal(.objectType, "activity")
                ])
            )
        )
        try await commentList.get()
        
        await client.eventsMiddleware.sendEvent(
            CommentReactionAddedEvent.dummy(
                comment: .dummy(
                    id: "comment-1",
                    objectId: Self.activityId,
                    ownReactions: [], // always empty
                    reactionCount: 1,
                    reactionGroups: ["like": .dummy(count: 1)]
                ),
                fid: "user:test",
                reaction: .dummy(type: "like", user: .dummy(id: "current-user-id"))
            )
        )
        
        let comments = await commentList.state.comments
        #expect(comments.count == 1)
        let comment = try #require(comments.first)
        #expect(comment.ownReactions.map(\.type) == ["like"])
        #expect(comment.reactionCount == 1)
        #expect(comment.reactionGroups.count == 1)
        #expect(comment.reactionGroups["like"]?.count == 1)
    }
    
    @Test func commentReactionDeletedEventUpdatesState() async throws {
        let client = defaultClient(
            comments: [
                .dummy(
                    id: "comment-1",
                    objectId: Self.activityId,
                    ownReactions: [.dummy(type: "like", user: .dummy(id: "current-user-id"))],
                    reactionCount: 1,
                    reactionGroups: ["like": .dummy(count: 1)]
                )
            ]
        )
        let commentList = client.commentList(
            for: CommentsQuery(
                filter: .and([
                    .equal(.objectId, Self.activityId),
                    .equal(.objectType, "activity")
                ])
            )
        )
        try await commentList.get()
        
        await client.eventsMiddleware.sendEvent(
            CommentReactionDeletedEvent.dummy(
                comment: .dummy(id: "comment-1", objectId: Self.activityId),
                fid: "user:test",
                reaction: .dummy(type: "like", user: .dummy(id: "current-user-id"))
            )
        )
        
        let comments = await commentList.state.comments
        #expect(comments.count == 1)
        let comment = try #require(comments.first)
        #expect(comment.ownReactions.isEmpty)
        #expect(comment.reactionCount == 0)
        #expect(comment.reactionGroups.isEmpty)
    }
    
    @Test func commentReactionUpdatedEventUpdatesState() async throws {
        let client = defaultClient(
            comments: [
                .dummy(
                    id: "comment-1",
                    objectId: Self.activityId,
                    ownReactions: [.dummy(type: "like", user: .dummy(id: "current-user-id"))],
                    reactionCount: 1,
                    reactionGroups: ["like": .dummy(count: 1)]
                )
            ]
        )
        let commentList = client.commentList(
            for: CommentsQuery(
                filter: .and([
                    .equal(.objectId, Self.activityId),
                    .equal(.objectType, "activity")
                ])
            )
        )
        try await commentList.get()
        
        await client.eventsMiddleware.sendEvent(
            CommentReactionUpdatedEvent.dummy(
                comment: .dummy(
                    id: "comment-1",
                    objectId: Self.activityId,
                    ownReactions: [], // always empty
                    reactionCount: 1,
                    reactionGroups: ["like": .dummy(count: 1)]
                ),
                fid: "user:test",
                reaction: .dummy(
                    custom: ["key": .string("UPDATED")],
                    type: "like",
                    user: .dummy(id: "current-user-id")
                )
            )
        )
        
        let comments = await commentList.state.comments
        #expect(comments.count == 1)
        let comment = try #require(comments.first)
        #expect(comment.ownReactions.first?.custom == ["key": StreamCore.RawJSON.string("UPDATED")])
        #expect(comment.ownReactions.map(\.type) == ["like"])
        #expect(comment.reactionCount == 1)
        #expect(comment.reactionGroups.count == 1)
        #expect(comment.reactionGroups["like"]?.count == 1)
    }
    
    @Test func eventsOnlyAffectMatchingObject() async throws {
        let client = defaultClient(
            comments: [.dummy(id: "comment-1", objectId: Self.activityId)]
        )
        let commentList = client.commentList(
            for: CommentsQuery(
                filter: .and([
                    .equal(.objectId, Self.activityId),
                    .equal(.objectType, "activity")
                ])
            )
        )
        try await commentList.get()
        
        // Send event for different activity
        await client.eventsMiddleware.sendEvent(
            CommentAddedEvent.dummy(
                activity: .dummy(id: "activity-456"),
                comment: .dummy(id: "comment-2", objectId: "activity-456"),
                fid: "user:test"
            )
        )
        
        let result = await commentList.state.comments.map(\.id)
        #expect(result == ["comment-1"]) // Should not include comment-2
    }
    
    @Test func eventsOnlyAffectMatchingObjectType() async throws {
        let client = defaultClient(
            comments: [.dummy(id: "comment-1", objectId: Self.activityId, objectType: "activity")]
        )
        let commentList = client.commentList(
            for: CommentsQuery(
                filter: .and([
                    .equal(.objectId, Self.activityId),
                    .equal(.objectType, "activity")
                ])
            )
        )
        try await commentList.get()
        
        // Send event for different object type
        await client.eventsMiddleware.sendEvent(
            CommentAddedEvent.dummy(
                activity: .dummy(id: Self.activityId),
                comment: .dummy(id: "comment-2", objectId: Self.activityId, objectType: "post"),
                fid: "user:test"
            )
        )
        
        let result = await commentList.state.comments.map(\.id)
        #expect(result == ["comment-1"]) // Should not include comment-2
    }
    
    @Test func userUpdatedEventUpdatesUserInComments() async throws {
        let client = defaultClient(
            comments: [.dummy(id: "comment-1", objectId: Self.activityId, user: .dummy(id: "user-123", name: "Old Name"))]
        )
        let commentList = client.commentList(
            for: CommentsQuery(
                filter: .and([
                    .equal(.objectId, Self.activityId),
                    .equal(.objectType, "activity")
                ])
            )
        )
        try await commentList.get()
        
        await client.eventsMiddleware.sendEvent(
            UserUpdatedEvent.dummy(
                user: .dummy(id: "user-123", name: "New Name")
            )
        )
        
        let comments = await commentList.state.comments
        #expect(comments.count == 1)
        let comment = try #require(comments.first)
        #expect(comment.user.name == "New Name")
    }
    
    // MARK: -
    
    private func defaultClient(
        comments: [ThreadedCommentResponse] = [.dummy(id: "comment-1", objectId: Self.activityId, objectType: "activity")],
        additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    GetCommentsResponse.dummy(
                        comments: comments,
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
