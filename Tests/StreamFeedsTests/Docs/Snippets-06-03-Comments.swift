//
// Copyright © 2026 Stream.io Inc. All rights reserved.
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
                id: "comment_123", // id is optional, but must be unique. will be auto-generated if not provided
                objectId: "activity_123",
                objectType: "activity"
            )
        )
        
        // Adding a reply to a comment
        let reply = try await feed.addComment(
            request: .init(
                comment: "I agree!",
                parentId: "comment_456"
            )
        )

        // Adding a comment without triggering push notifications
        let silentComment = try await feed.addComment(
            request: .init(
                comment: "Silent comment",
                objectId: "activity_123",
                objectType: "activity",
                skipPush: true
            )
        )

        // Adding a comment with attachments
        let commentWithAttachment = try await feed.addComment(
            request: .init(
                attachments: [
                    Attachment(
                        custom: [:],
                        imageUrl: "https://example.com/image.jpg",
                        type: "image"
                    )
                ],
                comment: "Check out this image!",
                objectId: "activity_123",
                objectType: "activity"
            )
        )
        
        suppressUnusedWarning(comment, reply, silentComment, commentWithAttachment)
    }
    
    func updatingComments() async throws {
        let comment = try await feed.updateComment(
            commentId: "comment_123",
            request: .init(comment: "Not so great")
        )
        print("Comment edited at: \(comment.editedAt.map { "\($0)" } ?? "never")")
    }

    func addingCommentsBatch() async throws {
        let activity = client.activity(for: "activity_123", in: feed.feed)
        let comments = try await activity.addCommentsBatch(
            requests: [
                ActivityAddCommentRequest(
                    comment: "So great!",
                    custom: ["sentiment": "positive"],
                    id: "comment_123" // id is optional, but must be unique. will be auto-generated if not provided
                )
            ]
        )

        suppressUnusedWarning(comments)
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

        // Reading a single comment
        let comment = try await feed.getComment(commentId: "123")

        suppressUnusedWarning(comment)
    }
    
    func queryingComments() async throws {
        // Search in comment texts
        let list1 = client.commentList(
            for: .init(
                filter: .query(.commentText, "oat")
            )
        )
        let comments1 = try await list1.get()
        
        // Comments from an user
        let list2 = client.commentList(
            for: .init(
                filter: .equal(.userId, "jane")
            )
        )
        let comments2 = try await list2.get()
        
        suppressUnusedWarning(comments1, comments2)
    }
    
    func commentReactions() async throws {
        // Add a reaction to a comment
        try await feed.addCommentReaction(
            commentId: "comment_123",
            request: .init(
                // Optionally override existing reaction
                enforceUnique: true,
                type: "like"
            )
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

    func showHideCommentInput() async throws {
        try await feed.getOrCreate()
        guard let activity = feed.state.activities.first else { return }

        switch activity.restrictReplies {
        case .everyone:
            print("Anyone can comment")
        case .nobody:
            print("Comments are disabled")
        case .peopleIFollow:
            // ownFollowings lists follows from the activity author's feeds to the current user's feeds.
            // A non-empty list means the activity author follows the current user, so they may comment.
            let ownFollowings = activity.currentFeed?.ownFollowings ?? []
            print("Can current user comment? \(!ownFollowings.isEmpty)")
        default: // Values added to the API later
            print("Unknown restriction: \(activity.restrictReplies.rawValue)")
        }
    }

    func showHideCommentInputFeed() async throws {
        // ownFollowings is set by default when fetching a single activity.
        // When reading a feed you have to ask for it.
        let enrichedFeed = client.feed(
            for: FeedQuery(
                group: "user",
                id: "john",
                enrichmentOptions: EnrichmentOptions(enrichOwnFollowings: true)
            )
        )
        try await enrichedFeed.getOrCreate()
    }

    func commentCounts() async throws {
        // Top-level count on a single activity
        let activity = client.activity(
            for: "activity_123",
            in: FeedId(group: "user", id: "john")
        )
        let activityData = try await activity.get()
        print(activityData.commentCount, activityData.topLevelCommentCount ?? 0)
    }
}
