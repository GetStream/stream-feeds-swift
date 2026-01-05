//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct CommentReplyList_Tests {
    static let activityId = "activity-123"
    static let commentId = "comment-123"
    
    @Test func initialGetUpdatesState() async throws {
        let client = defaultClient()
        let replyList = client.commentReplyList(
            for: CommentRepliesQuery(commentId: Self.commentId)
        )
        let replies = try await replyList.get()
        let stateReplies = await replyList.state.replies
        #expect(replies.map(\.id) == ["reply-1"])
        #expect(stateReplies.map(\.id) == ["reply-1"])
    }
    
    @Test func paginationLoadsMoreReplies() async throws {
        let client = defaultClient(
            additionalPayloads: [
                GetCommentRepliesResponse.dummy(
                    comments: [
                        .dummy(
                            createdAt: .fixed(offset: -1),
                            id: "reply-2",
                            objectId: Self.commentId,
                            parentId: Self.commentId
                        )
                    ],
                    next: nil
                )
            ]
        )

        let replyList = client.commentReplyList(
            for: CommentRepliesQuery(commentId: Self.commentId)
        )
        
        // Initial load
        #expect(try await replyList.get().map(\.id) == ["reply-1"])
        #expect(await replyList.state.canLoadMore == true)
        
        // Load more
        let moreReplies = try await replyList.queryMoreReplies()
        #expect(moreReplies.map(\.id) == ["reply-2"])
        #expect(await replyList.state.canLoadMore == false)
        
        // Check final state
        let finalStateReplies = await replyList.state.replies
        #expect(finalStateReplies.map(\.id) == ["reply-1", "reply-2"], "Newest first")
    }
    
    @Test func commentAddedEventUpdatesState() async throws {
        let client = defaultClient()
        let replyList = client.commentReplyList(
            for: CommentRepliesQuery(commentId: Self.commentId)
        )
        try await replyList.get()
        
        // Send comment added event
        await client.eventsMiddleware.sendEvent(
            CommentAddedEvent.dummy(
                activity: .dummy(id: Self.activityId),
                comment: .dummy(createdAt: .fixed(offset: 1), id: "reply-2", objectId: Self.activityId, parentId: Self.commentId),
                fid: "user:test"
            )
        )
        
        let result = await replyList.state.replies.map(\.id)
        #expect(result == ["reply-2", "reply-1"]) // New reply should be added
    }
    
    @Test func commentDeletedEventUpdatesState() async throws {
        let client = defaultClient()
        let replyList = client.commentReplyList(
            for: CommentRepliesQuery(commentId: Self.commentId)
        )
        try await replyList.get()
        
        // Send comment deleted event
        await client.eventsMiddleware.sendEvent(
            CommentDeletedEvent.dummy(
                comment: .dummy(id: "reply-1", objectId: Self.activityId, parentId: Self.commentId),
                fid: "user:test"
            )
        )
        
        let result = await replyList.state.replies.map(\.id)
        #expect(result == []) // Reply should be removed
    }
    
    @Test func commentUpdatedEventUpdatesState() async throws {
        let client = defaultClient()
        let replyList = client.commentReplyList(
            for: CommentRepliesQuery(commentId: Self.commentId)
        )
        try await replyList.get()
        
        // Send comment updated event
        await client.eventsMiddleware.sendEvent(
            CommentUpdatedEvent.dummy(
                comment: .dummy(id: "reply-1", objectId: Self.activityId, parentId: Self.commentId, text: "Updated text"),
                fid: "user:test"
            )
        )
        
        let result = await replyList.state.replies.map(\.id)
        #expect(result == ["reply-1"]) // Reply should still be there but updated
        let updatedReply = await replyList.state.replies.first
        #expect(updatedReply?.text == "Updated text")
    }
    
    @Test func commentReactionAddedEventUpdatesState() async throws {
        let client = defaultClient()
        let replyList = client.commentReplyList(
            for: CommentRepliesQuery(commentId: Self.commentId)
        )
        try await replyList.get()
        
        // Send reaction added event
        await client.eventsMiddleware.sendEvent(
            CommentReactionAddedEvent.dummy(
                comment: .dummy(id: "reply-1", objectId: Self.activityId, parentId: Self.commentId),
                fid: "user:test",
                reaction: .dummy(commentId: "reply-1", type: "like", user: .dummy(id: "current-user-id"))
            )
        )
        
        let result = await replyList.state.replies.map(\.id)
        #expect(result == ["reply-1"]) // Reply should still be there
        let updatedReply = await replyList.state.replies.first
        #expect(updatedReply?.ownReactions.count == 1)
    }
    
    @Test func commentReactionDeletedEventUpdatesState() async throws {
        let client = defaultClient()
        let replyList = client.commentReplyList(
            for: CommentRepliesQuery(commentId: Self.commentId)
        )
        try await replyList.get()
        
        // Send reaction deleted event
        await client.eventsMiddleware.sendEvent(
            CommentReactionDeletedEvent.dummy(
                comment: .dummy(id: "reply-1", objectId: Self.activityId, parentId: Self.commentId),
                fid: "user:test",
                reaction: .dummy(commentId: "reply-1", type: "like", user: .dummy(id: "current-user-id"))
            )
        )
        
        let result = await replyList.state.replies.map(\.id)
        #expect(result == ["reply-1"]) // Reply should still be there
        let updatedReply = await replyList.state.replies.first
        #expect(updatedReply?.ownReactions.isEmpty == true)
    }
    
    @Test func eventsOnlyAffectMatchingParentComment() async throws {
        let client = defaultClient()
        let replyList = client.commentReplyList(
            for: CommentRepliesQuery(commentId: Self.commentId)
        )
        try await replyList.get()
        
        // Send event for different parent comment
        await client.eventsMiddleware.sendEvent(
            CommentAddedEvent.dummy(
                activity: .dummy(id: Self.activityId),
                comment: .dummy(id: "reply-2", objectId: Self.activityId, parentId: "comment-456"),
                fid: "user:test"
            )
        )
        
        let result = await replyList.state.replies.map(\.id)
        #expect(result == ["reply-1"]) // Should not include reply-2
    }
    
    // MARK: -
    
    private func defaultClient(
        replies: [ThreadedCommentResponse] = [.dummy(id: "reply-1", objectId: Self.commentId, parentId: Self.commentId)],
        additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    GetCommentRepliesResponse.dummy(
                        comments: replies,
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
