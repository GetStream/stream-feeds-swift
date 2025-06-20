//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import Testing

struct Snippets_01_Quickstart {
    var client: FeedsClient!
    
    func gettingStarted() async throws {
        // Initialize the client
        let client = FeedsClient(
            apiKey: APIKey("<your_api_key>"),
            user: User(id: "john"),
            token: "<user_token>"
        )

        // Create a feed (or get its data if exists)
        let feed = client.feed(group: "user", id: "john")
        try await feed.getOrCreate()

        // Add activity
        let activity = try await feed.addActivity(
            request: .init(
                text: "Hello, Stream Feeds!",
                type: "post"
            )
        )
    }
    
    func socialMediaFeed() async throws {
        // Create a timeline feed
        let timeline = client.feed(group: "timeline", id: "john")
        try await timeline.getOrCreate()

        // Add a reaction to activity
        _ = try await timeline.addReaction(
            activityId: "activity_123",
            request: .init(type: "like")
        )
        // Add a comment to activity
        _ = try await timeline.addComment(
            request: .init(
                comment: "Great post!",
                objectId: "activity_123",
                objectType: "activity"
            )
        )
        // Add a reaction to comment
        let activity = client.activity(for: "activity_123", in: FeedId(groupId: "timeline", id: "john"))
        try await activity.addCommentReaction(
            commentId: "comment_123",
            request: .init(type: "love")
        )
    }
    
    func notificationFeed() async throws {
        // Create a notification feed
        let notifications = client.feed(group: "notification", id: "john")
        try await notifications.getOrCreate()

        // Mark notifications as read
        try await notifications.markActivity(request: .init(markAllRead: true))
    }
    
    func polls() async throws {
        // Create a poll
        let feedId = FeedId(groupId: "user", id: "john")
        let feed = client.feed(for: feedId)
        let activityData = try await feed.createPoll(
            request: .init(
                name: "What's your favorite color?",
                options: [
                    PollOptionInput(text: "Red"),
                    PollOptionInput(text: "Blue"),
                    PollOptionInput(text: "Green")
                ]
            ),
            activityType: "poll"
        )

        // Vote on a poll
        let activity = client.activity(for: activityData.id, in: feedId)
        _ = try await activity.castPollVote(
            request: .init(
                vote: .init(
                    optionId: "option_456"
                )
            )
        )
    }
}

