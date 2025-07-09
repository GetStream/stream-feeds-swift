//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_06_03_Comments {
    var client: FeedsClient!
    var feed: Feed!
    var activity: Activity!
    
    func addingComments() async throws {
        // Adding a comment to an activity
        let comment = try await feed.addComment(
            request: .init(
                comment: "So great!",
                custom: ["sentiment": "positive"],
                objectId: "activity_123",
                objectType: "activity"
            )
        )
        
        // Adding a reply to a comment
        let reply = try await feed.addComment(
            request: .init(
                comment: "I agree!",
                objectId: "activity_123",
                objectType: "activity",
                parentId: "comment_456"
            )
        )
        
        suppressUnusedWarning(comment, reply)
    }
    
    func updatingComments() async throws {
        try await feed.updateComment(
            commentId: "comment_123",
            request: .init(
                comment: "Not so great",
                custom: ["edited": true]
            )
        )
    }
    
    func removingComments() async throws {
        try await feed.deleteComment(
            commentId: "comment_123"
        )
    }
    
    func readingComments() async throws {
        try await feed.getOrCreate()
        print(feed.state.activities[0].comments)
        // or
        let activity = client.activity(
            for: "activity_123",
            in: FeedId(group: "user", id: "john")
        )
        try await activity.get()
        print(activity.state.comments)
    }
    
    func queryingComments() async throws {
        // Search in comment texts
        let list1 = client.commentList(
            for: .init(
                filter: .query(.commentText, "oat")
            )
        )
        let comments1 = try await list1.get()
        
        // All comments for an activity
        let list2 = client.commentList(
            for: .init(
                filter: .and([
                    .equal(.objectId, "activity_123"),
                    .equal(.objectType, "activity")
                ])
            )
        )
        let comments2 = try await list2.get()
        
        // Replies to a parent activity
        let list3 = client.commentList(
            for: .init(
                filter: .equal(.parentId, "parent_id")
            )
        )
        let comments3 = try await list3.get()
        
        // Comments from an user
        let list4 = client.commentList(
            for: .init(
                filter: .equal(.userId, "jane")
            )
        )
        let comments4 = try await list4.get()
        
        suppressUnusedWarning(comments1, comments2, comments3, comments4)
    }
    
    func commentReactions() async throws {
        // Add a reaction to a comment
        try await feed.addCommentReaction(
            commentId: "comment_123",
            request: .init(type: "like")
        )

        // Remove a reaction from a comment
        try await feed.deleteCommentReaction(
            commentId: "comment_123",
            type: "like"
        )
    }
    
    func commentThreading() async throws {
        let commentList = client.activityCommentList(
            for: .init(
                objectId: "activity_123",
                objectType: "activity",
                depth: 3,
                limit: 20
            )
        )
        let comments = try await commentList.get()
        
        // Get replies of a specific parent comment
        let replyList = client.commentReplyList(
            for: .init(
                commentId: "parent_123"
            )
        )
        let replies = try await replyList.get()
        
        suppressUnusedWarning(comments, replies)
    }
}
