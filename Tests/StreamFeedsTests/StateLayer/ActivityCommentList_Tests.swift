//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct ActivityCommentList_Tests {
    @Test func initialGetUpdatesState() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetCommentsResponse.dummy(comments: [.dummy(id: "comment-1")])
            ])
        )
        let commentList = client.activityCommentList(
            for: .init(objectId: "activity-123", objectType: "activity")
        )
        let comments = try await commentList.get()
        let stateComments = await commentList.state.comments
        #expect(comments.map(\.id) == ["comment-1"])
        #expect(stateComments.map(\.id) == ["comment-1"])
    }
    
    @Test func paginationLoadsMoreComments() async throws {
        // Sort by newest first
        let client = FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    GetCommentsResponse.dummy(
                        comments: [.dummy(
                            createdAt: .fixed(offset: 0),
                            id: "comment-1"
                        )],
                        next: "next-cursor"
                    ),
                    GetCommentsResponse.dummy(
                        comments: [.dummy(
                            createdAt: .fixed(offset: -1),
                            id: "comment-2"
                        )],
                        next: nil
                    )
                ]
            )
        )
        let commentList = client.activityCommentList(
            for: .init(objectId: "activity-123", objectType: "activity")
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
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetCommentsResponse.dummy(comments: [.dummy(createdAt: .fixed(), id: "comment-1")])
            ])
        )
        let commentList = client.activityCommentList(
            for: .init(objectId: "activity-123", objectType: "activity")
        )
        try await commentList.get()
        
        await client.eventsMiddleware.sendEvent(
            CommentAddedEvent.dummy(
                comment: .dummy(createdAt: .fixed(offset: 1), id: "comment-2"),
                fid: "user:test"
            )
        )
        // Unrelated event
        await client.eventsMiddleware.sendEvent(
            CommentAddedEvent.dummy(
                comment: .dummy(id: "should-not-be-added", objectId: "unrelated"),
                fid: "user:test"
            )
        )
        
        let result = await commentList.state.comments.map(\.id)
        #expect(result == ["comment-2", "comment-1"], "Newest first")
    }
    
    @Test func commentUpdatedEventUpdatesState() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetCommentsResponse.dummy(comments: [.dummy(id: "comment-1", text: "Original text")])
            ])
        )
        let commentList = client.activityCommentList(
            for: .init(objectId: "activity-123", objectType: "activity")
        )
        try await commentList.get()
        
        await client.eventsMiddleware.sendEvent(
            CommentUpdatedEvent.dummy(
                comment: .dummy(id: "comment-1", text: "Updated text"),
                fid: "user:test"
            )
        )
        
        let comments = await commentList.state.comments
        #expect(comments.count == 1)
        #expect(comments.first?.text == "Updated text")
    }
    
    @Test func commentDeletedEventRemovesFromState() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetCommentsResponse.dummy(comments: [.dummy(id: "comment-1")])
            ])
        )
        let commentList = client.activityCommentList(
            for: .init(objectId: "activity-123", objectType: "activity")
        )
        try await commentList.get()
        
        await client.eventsMiddleware.sendEvent(
            CommentDeletedEvent.dummy(
                comment: .dummy(id: "comment-1"),
                fid: "user:test"
            )
        )
        
        let result = await commentList.state.comments
        #expect(result.isEmpty)
    }
    
    @Test func commentReactionAddedEventUpdatesState() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetCommentsResponse.dummy(comments: [.dummy(id: "comment-1")])
            ])
        )
        let commentList = client.activityCommentList(
            for: .init(objectId: "activity-123", objectType: "activity")
        )
        try await commentList.get()
        
        await client.eventsMiddleware.sendEvent(
            CommentReactionAddedEvent.dummy(
                comment: .dummy(id: "comment-1"),
                fid: "user:test",
                reaction: .dummy(type: "heart")
            )
        )
        
        let result = await commentList.state.comments.first?.reactionGroups["heart"]?.count
        #expect(result == 1)
    }
    
    @Test func commentReactionDeletedEventUpdatesState() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetCommentsResponse.dummy(comments: [.dummy(id: "comment-1")])
            ])
        )
        let commentList = client.activityCommentList(
            for: .init(objectId: "activity-123", objectType: "activity")
        )
        try await commentList.get()
        
        // Add reaction first
        await client.eventsMiddleware.sendEvent(
            CommentReactionAddedEvent.dummy(
                comment: .dummy(id: "comment-1"),
                fid: "user:test",
                reaction: .dummy(type: "heart")
            )
        )
        
        // Then remove it
        await client.eventsMiddleware.sendEvent(
            CommentReactionDeletedEvent.dummy(
                comment: .dummy(id: "comment-1"),
                fid: "user:test",
                reaction: .dummy(type: "heart")
            )
        )
        
        let comment = try #require(await commentList.state.comments.first)
        #expect(comment.reactionCount == 0)
        #expect(comment.reactionGroups["heart"] == nil)
        #expect(comment.ownReactions.isEmpty)
    }
    
    @Test func threadedCommentsHandleReplies() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetCommentsResponse.dummy(comments: [
                    .dummy(id: "comment-1", replies: [.dummy(id: "reply-1")])
                ])
            ])
        )
        let commentList = client.activityCommentList(
            for: .init(objectId: "activity-123", objectType: "activity")
        )
        try await commentList.get()
        
        // Add a reply to existing comment
        await client.eventsMiddleware.sendEvent(
            CommentAddedEvent.dummy(
                comment: .dummy(createdAt: .fixed(offset: 1), id: "reply-2", parentId: "comment-1"),
                fid: "user:test"
            )
        )
        
        let result = try #require(await commentList.state.comments.first?.replies?.map(\.id))
        #expect(result == ["reply-2", "reply-1"], "Newest first")
    }
    
    @Test func eventsOnlyAffectMatchingObject() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetCommentsResponse.dummy(comments: [.dummy(id: "comment-1")])
            ])
        )
        let commentList = client.activityCommentList(
            for: .init(objectId: "activity-123", objectType: "activity")
        )
        try await commentList.get()
        
        // Send event for different activity
        await client.eventsMiddleware.sendEvent(
            CommentAddedEvent.dummy(
                comment: .dummy(id: "comment-2", objectId: "activity-456"),
                fid: "user:test"
            )
        )
        
        let result = await commentList.state.comments.map(\.id)
        #expect(result == ["comment-1"]) // Should not include comment-2
    }
}
