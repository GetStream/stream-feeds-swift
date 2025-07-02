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
                objectType: "activity",
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
        try await feed.removeComment(
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
        // All comments for an activity
        let activityCommentList = client.commentList(
            for: .init(
                filter: [.activityIds: ["activity_123"]]
            )
        )
        let activityComments = try await activityCommentList.get()
        

        // All replies to a parent comment
        let replyList = client.commentList(
            for: .init(
                filter: [.parentIds: ["comment_456"]]
            )
        )
        let replies = try await replyList.get()

        // All comments by a certain user
        let userCommentList = client.commentList(
            for: .init(
                filter: [.userIds: ["john"]],
                limit: 100
            )
        )
        let userComments = try await userCommentList.get()
        
        suppressUnusedWarning(activityComments, replies, userComments)
    }
    
    func commentReactions() async throws {
        // Add a reaction to a comment
        try await feed.addCommentReaction(
            commentId: "comment_123",
            request: .init(type: "like")
        )

        // Remove a reaction from a comment
        try await feed.removeCommentReaction(
            commentId: "comment_123",
            type: "like"
        )
    }
    
    func commentThreading() async throws {
        let comments = try await feed.getComments(
            objectId: "activity_123",
            objectType: "activity",
            // Depth of the threaded comments
            depth: 3,
            limit: 20,
        )
        
        // Get replies of a specific parent comment
        let replies = try await feed.getCommentReplies(
            commentId: "parent_123"
        )
        
        suppressUnusedWarning(comments, replies)
    }
}
