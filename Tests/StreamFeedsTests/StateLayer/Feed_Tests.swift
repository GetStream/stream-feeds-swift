//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct Feed_Tests {
    // MARK: - Actions
    
    @Test func getOrCreateUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue)
        let feed = client.feed(for: feedId)
        let feedData = try await feed.getOrCreate()
        let stateActivities = await feed.state.activities
        let stateFeedData = await feed.state.feedData
        #expect(stateActivities.map(\.id) == ["1"])
        #expect(stateFeedData == feedData)
    }
    
    @Test func updateFeedUpdatesState() async throws {
        let customData = ["test": RawJSON.string("value")]
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            UpdateFeedResponse.dummy(
                feed: .dummy(
                    custom: customData,
                    name: "Updated Feed Name"
                )
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let updateRequest = UpdateFeedRequest(custom: customData)
        let updatedFeedData = try await feed.updateFeed(request: updateRequest)
        let stateFeedData = await feed.state.feedData
        
        #expect(stateFeedData == updatedFeedData)
        #expect(stateFeedData?.name == "Updated Feed Name")
        #expect(stateFeedData?.custom == customData)
    }
    
    @Test func deleteFeedUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            DeleteFeedResponse.dummy()
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        // Verify initial state has data
        await #expect(!feed.state.activities.isEmpty)
        await #expect(!feed.state.aggregatedActivities.isEmpty)
        await #expect(feed.state.feedData != nil)
        await #expect(!feed.state.followers.isEmpty)
        await #expect(!feed.state.following.isEmpty)
        await #expect(!feed.state.followRequests.isEmpty)
        await #expect(!feed.state.members.isEmpty)
        await #expect(!feed.state.ownCapabilities.isEmpty)
        await #expect(!feed.state.pinnedActivities.isEmpty)
        await #expect(feed.state.notificationStatus != nil)
        
        // Delete the feed
        try await feed.deleteFeed()
        
        // Verify all @Published properties are cleared after deletion
        await #expect(feed.state.activities.isEmpty)
        await #expect(feed.state.aggregatedActivities.isEmpty)
        await #expect(feed.state.feedData == nil)
        await #expect(feed.state.followers.isEmpty)
        await #expect(feed.state.following.isEmpty)
        await #expect(feed.state.followRequests.isEmpty)
        await #expect(feed.state.members.isEmpty)
        await #expect(feed.state.ownCapabilities.isEmpty)
        await #expect(feed.state.pinnedActivities.isEmpty)
        await #expect(feed.state.notificationStatus == nil)
    }
    
    @Test func addActivityUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            AddActivityResponse.dummy(
                activity: .dummy(
                    feeds: [feedId.rawValue],
                    id: "new-activity",
                    text: "New activity content"
                )
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        let addRequest = FeedAddActivityRequest(
            text: "New activity content",
            type: "post"
        )
        let addedActivity = try await feed.addActivity(request: addRequest)
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.count == 2)
        #expect(finalActivities.map(\.id) == ["new-activity", "1"])
        #expect(finalActivities.map(\.text) == ["New activity content", "Test activity content"])
        #expect(addedActivity.id == "new-activity")
        #expect(addedActivity.text == "New activity content")
    }
    
    @Test func deleteActivityUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            DeleteActivityResponse.dummy()
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        try await feed.deleteActivity(id: "1")
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.isEmpty)
    }
    
    @Test func updateActivityUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            UpdateActivityResponse.dummy(
                activity: .dummy(
                    id: "1",
                    text: "Updated activity content"
                )
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        #expect(initialActivities.first?.text == "Test activity content")
        
        let updateRequest = UpdateActivityRequest(text: "Updated activity content")
        let updatedActivity = try await feed.updateActivity(id: "1", request: updateRequest)
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.count == 1)
        #expect(finalActivities.map(\.id) == ["1"])
        #expect(finalActivities.map(\.text) == ["Updated activity content"])
        #expect(updatedActivity.id == "1")
        #expect(updatedActivity.text == "Updated activity content")
    }
    
    @Test func markActivityUpdatesStateWhenMarkAllRead() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            Response.dummy()
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialNotificationStatus = await feed.state.notificationStatus
        #expect(initialNotificationStatus != nil)
        
        let markRequest = MarkActivityRequest(
            markAllRead: true,
            markAllSeen: nil,
            markRead: nil,
            markSeen: nil,
            markWatched: nil
        )
        try await feed.markActivity(request: markRequest)
        
        let finalNotificationStatus = await feed.state.notificationStatus
        let readIds = await Set(feed.state.aggregatedActivities.map(\.id))
        #expect(finalNotificationStatus?.readActivities == readIds)
    }
    
    @Test func stopWatching() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(
            feed: feedId.rawValue,
            [Response.dummy()]
        )
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        try await feed.stopWatching() // No state updates
    }
    
    @Test func repostUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(
            feed: feedId.rawValue,
            [
                AddActivityResponse.dummy(
                    activity: .dummy(feeds: [feedId.rawValue], id: "repost-1", text: "Reposted content")
                )
            ]
        )
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        let reposted = try await feed.repost(activityId: "1", text: "Reposted content")
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.count == 2)
        #expect(finalActivities.map(\.id) == ["repost-1", "1"])
        #expect(finalActivities.first?.text == "Reposted content")
        #expect(reposted.id == "repost-1")
        #expect(reposted.text == "Reposted content")
    }
    
    @Test func queryMoreActivitiesUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(
            feed: feedId.rawValue,
            [
                GetOrCreateFeedResponse.dummy(
                    activities: [
                        .dummy(createdAt: .fixed(offset: 1), id: "2", text: "Second"),
                        .dummy(createdAt: .fixed(offset: 2), id: "3", text: "Third")
                    ]
                )
            ]
        )
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()

        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])

        // Load more (next page) activities
        _ = try await feed.queryMoreActivities()

        let finalActivities = await feed.state.activities
        #expect(finalActivities.count == 3)
        #expect(finalActivities.map(\.id) == ["3", "2", "1"])
        #expect(finalActivities.map(\.text) == ["Third", "Second", "Test activity content"])
    }
    
    @Test func addBookmarkUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            AddBookmarkResponse.dummy(
                bookmark: .dummy(
                    activity: .dummy(id: "1", text: "Test activity content")
                )
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        let addRequest = AddBookmarkRequest()
        let addedBookmark = try await feed.addBookmark(activityId: "1", request: addRequest)
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.count == 1)
        #expect(finalActivities.map(\.id) == ["1"])
        #expect(addedBookmark.activity.id == "1")
        #expect(addedBookmark.activity.text == "Test activity content")
    }
    
    @Test func deleteBookmarkUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            DeleteBookmarkResponse.dummy(
                bookmark: .dummy(
                    activity: .dummy(id: "1", text: "Test activity content")
                )
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        let deletedBookmark = try await feed.deleteBookmark(activityId: "1")
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.count == 1)
        #expect(finalActivities.map(\.id) == ["1"])
        #expect(deletedBookmark.activity.id == "1")
        #expect(deletedBookmark.activity.text == "Test activity content")
    }
    
    @Test func updateBookmarkUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            UpdateBookmarkResponse.dummy(
                bookmark: .dummy(
                    activity: .dummy(id: "1", text: "Test activity content")
                )
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        let updateRequest = UpdateBookmarkRequest()
        let updatedBookmark = try await feed.updateBookmark(activityId: "1", request: updateRequest)
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.count == 1)
        #expect(finalActivities.map(\.id) == ["1"])
        #expect(updatedBookmark.activity.id == "1")
        #expect(updatedBookmark.activity.text == "Test activity content")
    }
    
    @Test func getCommentUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            GetCommentResponse.dummy(
                comment: .dummy(
                    id: "comment-1",
                    objectId: "1",
                    text: "Updated comment text"
                )
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        let comment = try await feed.getComment(commentId: "comment-1")
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.count == 1)
        #expect(finalActivities.map(\.id) == ["1"])
        #expect(comment.id == "comment-1")
        #expect(comment.text == "Updated comment text")
    }
    
    @Test func addCommentUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            AddCommentResponse.dummy(
                comment: .dummy(
                    id: "new-comment",
                    objectId: "1",
                    text: "New comment content"
                )
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        let addRequest = AddCommentRequest(
            comment: "New comment content",
            objectId: "1",
            objectType: "activity"
        )
        let addedComment = try await feed.addComment(request: addRequest)
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.count == 1)
        #expect(finalActivities.map(\.id) == ["1"])
        #expect(addedComment.id == "new-comment")
        #expect(addedComment.text == "New comment content")
    }
    
    @Test func deleteCommentUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            DeleteCommentResponse.dummy(
                activity: .dummy(id: "1"),
                comment: .dummy(
                    id: "comment-1",
                    objectId: "1",
                    text: "Comment to delete"
                )
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        try await feed.deleteComment(commentId: "comment-1")
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.count == 1)
        #expect(finalActivities.map(\.id) == ["1"])
    }
    
    @Test func updateCommentUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            UpdateCommentResponse.dummy(
                comment: .dummy(
                    id: "comment-1",
                    objectId: "1",
                    text: "Updated comment content"
                )
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        let updateRequest = UpdateCommentRequest(comment: "Updated comment content")
        let updatedComment = try await feed.updateComment(commentId: "comment-1", request: updateRequest)
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.count == 1)
        #expect(finalActivities.map(\.id) == ["1"])
        #expect(updatedComment.id == "comment-1")
        #expect(updatedComment.text == "Updated comment content")
    }
    
    @Test func queryFollowSuggestionsUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            GetFollowSuggestionsResponse.dummy(
                suggestions: [
                    .dummy(feed: "user:suggestion1"),
                    .dummy(feed: "user:suggestion2")
                ]
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        // queryFollowSuggestions doesn't update feed state, just returns suggestions
        let suggestions = try await feed.queryFollowSuggestions(limit: 10)
        
        #expect(suggestions.count == 2)
        #expect(suggestions.map(\.feed.rawValue) == ["user:suggestion1", "user:suggestion2"])
    }
    
    @Test func followUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let targetFeedId = FeedId(group: "user", id: "john")
        let client = defaultClientWithActivities(
            feed: feedId.rawValue,
            [
                SingleFollowResponse.dummy(
                    follow: .dummy(
                        sourceFeed: .dummy(feed: feedId.rawValue),
                        status: .accepted,
                        targetFeed: .dummy(feed: targetFeedId.rawValue)
                    )
                )
            ]
        )
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialFollowing = await feed.state.following
        #expect(initialFollowing.count == 1)
        
        let followData = try await feed.follow(targetFeedId)
        let finalFollowing = await feed.state.following
        
        #expect(finalFollowing.count == 2)
        #expect(finalFollowing.map(\.sourceFeed.feed.rawValue) == ["user:jane", "user:jane"])
        #expect(finalFollowing.map(\.targetFeed.feed.rawValue) == ["user:john", "user:bob"])
        #expect(followData.sourceFeed.feed.rawValue == feedId.rawValue)
        #expect(followData.targetFeed.feed.rawValue == targetFeedId.rawValue)
    }
    
    @Test func unfollowUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let targetFeedId = FeedId(group: "user", id: "bob")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            UnfollowResponse.dummy(
                follow: .dummy(
                    sourceFeed: .dummy(feed: feedId.rawValue),
                    status: .accepted,
                    targetFeed: .dummy(feed: targetFeedId.rawValue)
                )
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialFollowing = await feed.state.following
        #expect(initialFollowing.count == 1)
        
        let unfollowData = try await feed.unfollow(targetFeedId)
        let finalFollowing = await feed.state.following
        
        #expect(finalFollowing.isEmpty)
        #expect(unfollowData.sourceFeed.feed.rawValue == feedId.rawValue)
        #expect(unfollowData.targetFeed.feed.rawValue == targetFeedId.rawValue)
    }
    
    @Test func acceptFollowUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let sourceFeedId = FeedId(group: "user", id: "bob")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            AcceptFollowResponse.dummy(
                follow: .dummy(
                    sourceFeed: .dummy(feed: sourceFeedId.rawValue),
                    status: .accepted,
                    targetFeed: .dummy(feed: feedId.rawValue)
                )
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialFollowRequests = await feed.state.followRequests
        let initialFollowers = await feed.state.followers
        #expect(initialFollowRequests.count == 1)
        #expect(initialFollowers.count == 1)
        
        let acceptData = try await feed.acceptFollow(sourceFeedId)
        let finalFollowRequests = await feed.state.followRequests
        let finalFollowers = await feed.state.followers
        
        #expect(finalFollowRequests.isEmpty)
        #expect(finalFollowers.count == 1)
        #expect(finalFollowers.map(\.sourceFeed.feed.rawValue) == [sourceFeedId.rawValue])
        #expect(finalFollowers.map(\.targetFeed.feed.rawValue) == [feedId.rawValue])
        #expect(acceptData.sourceFeed.feed.rawValue == sourceFeedId.rawValue)
        #expect(acceptData.targetFeed.feed.rawValue == feedId.rawValue)
    }
    
    @Test func rejectFollowUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let sourceFeedId = FeedId(group: "user", id: "bob")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            RejectFollowResponse.dummy(
                follow: .dummy(
                    sourceFeed: .dummy(feed: sourceFeedId.rawValue),
                    status: .rejected,
                    targetFeed: .dummy(feed: feedId.rawValue)
                )
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialFollowRequests = await feed.state.followRequests
        #expect(initialFollowRequests.count == 1)
        
        let rejectData = try await feed.rejectFollow(sourceFeedId)
        let finalFollowRequests = await feed.state.followRequests
        
        #expect(finalFollowRequests.isEmpty)
        #expect(rejectData.sourceFeed.feed.rawValue == sourceFeedId.rawValue)
        #expect(rejectData.targetFeed.feed.rawValue == feedId.rawValue)
    }
    
    @Test func addReactionUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            AddReactionResponse.dummy(
                activity: .dummy(id: "1", text: "Test activity content"),
                reaction: .dummy(activityId: "1", type: "like")
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        let addRequest = AddReactionRequest(type: "like")
        let addedReaction = try await feed.addReaction(activityId: "1", request: addRequest)
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.count == 1)
        #expect(finalActivities.map(\.id) == ["1"])
        #expect(addedReaction.activityId == "1")
        #expect(addedReaction.type == "like")
    }
    
    @Test func deleteReactionUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            DeleteActivityReactionResponse.dummy(
                activity: .dummy(id: "1", text: "Test activity content"),
                reaction: .dummy(activityId: "1", type: "like")
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        let deletedReaction = try await feed.deleteReaction(activityId: "1", type: "like")
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.count == 1)
        #expect(finalActivities.map(\.id) == ["1"])
        #expect(deletedReaction.activityId == "1")
        #expect(deletedReaction.type == "like")
    }
    
    @Test func addCommentReactionUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            AddCommentReactionResponse.dummy(
                comment: .dummy(id: "comment-1", objectId: "1"),
                reaction: .dummy(activityId: "1", type: "like")
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        let addRequest = AddCommentReactionRequest(type: "like")
        let addedReaction = try await feed.addCommentReaction(commentId: "comment-1", request: addRequest)
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.count == 1)
        #expect(finalActivities.map(\.id) == ["1"])
        #expect(addedReaction.activityId == "1")
        #expect(addedReaction.type == "like")
    }
    
    @Test func deleteCommentReactionUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(feed: feedId.rawValue, [
            DeleteCommentReactionResponse.dummy(
                comment: .dummy(id: "comment-1", objectId: "1"),
                reaction: .dummy(activityId: "1", type: "like")
            )
        ])
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        let deletedReaction = try await feed.deleteCommentReaction(commentId: "comment-1", type: "like")
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.count == 1)
        #expect(finalActivities.map(\.id) == ["1"])
        #expect(deletedReaction.activityId == "1")
        #expect(deletedReaction.type == "like")
    }
    
    @Test func createPollUpdatesState() async throws {
        let feedId = FeedId(group: "user", id: "jane")
        let client = defaultClientWithActivities(
            feed: feedId.rawValue,
            [
                PollResponse.dummy(
                    poll: .dummy(id: "poll-1", name: "Test poll question")
                ),
                AddActivityResponse.dummy(
                    activity: .dummy(
                        id: "poll-activity-1",
                        poll: .dummy(id: "poll-1"),
                        text: "Poll activity"
                    )
                )
            ]
        )
        let feed = client.feed(for: feedId)
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.map(\.id) == ["1"])
        
        let createRequest = CreatePollRequest(
            name: "Test poll question",
            options: [
                PollOptionInput(text: "Option 1"),
                PollOptionInput(text: "Option 2")
            ]
        )
        
        let createdActivity = try await feed.createPoll(request: createRequest, activityType: "poll")
        let finalActivities = await feed.state.activities
        
        #expect(finalActivities.map(\.id) == ["poll-activity-1", "1"])
        #expect(createdActivity.id == "poll-activity-1")
        #expect(createdActivity.text == "Poll activity")
        #expect(createdActivity.poll?.id == "poll-1")
    }
    
    // MARK: - Web-Socket Events
    
    @Test func activityAddedEventWithoutActivitiesFilterIsInserted() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetOrCreateFeedResponse.dummy(activities: [])
            ])
        )
        let feed = client.feed(group: "user", id: "jane")
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.isEmpty)
        
        await client.eventsMiddleware.sendEvent(
            ActivityAddedEvent.dummy(
                activity: .dummy(id: "new-activity", text: "New activity content"),
                fid: feed.feed.rawValue
            )
        )
        
        let finalActivities = await feed.state.activities
        #expect(finalActivities.count == 1)
        #expect(finalActivities.first?.id == "new-activity")
        #expect(finalActivities.first?.text == "New activity content")
    }
    
    @Test func activityAddedEventWithMatchingActivitiesFilterIsInserted() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetOrCreateFeedResponse.dummy(activities: [])
            ])
        )
        let feed = client.feed(
            for: FeedQuery(
                group: "user",
                id: "jane",
                activityFilter: .exists(.expiresAt, true)
            )
        )
        try await feed.getOrCreate()
                
        // Send activity with expiresAt - should be inserted
        await client.eventsMiddleware.sendEvent(
            ActivityAddedEvent.dummy(
                activity: .dummy(
                    expiresAt: Date.fixed().addingTimeInterval(3600),
                    id: "expiring-activity",
                    text: "This activity expires"
                ),
                fid: feed.feed.rawValue
            )
        )
        
        // Send activity without expiresAt - should be ignored
        await client.eventsMiddleware.sendEvent(
            ActivityAddedEvent.dummy(
                activity: .dummy(
                    expiresAt: nil,
                    id: "non-expiring-activity",
                    text: "This activity doesn't expire"
                ),
                fid: feed.feed.rawValue
            )
        )
        
        // Verify only the activity with expiresAt was inserted
        let finalActivities = await feed.state.activities
        #expect(finalActivities.count == 1)
        #expect(finalActivities.first?.id == "expiring-activity")
        #expect(finalActivities.first?.text == "This activity expires")
    }
    
    @Test func activityAddedEventWithoutMatchingActivitiesFilterIsIgnored() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetOrCreateFeedResponse.dummy(activities: [])
            ])
        )
        let feed = client.feed(
            for: FeedQuery(
                group: "user",
                id: "jane",
                activityFilter: .exists(.expiresAt, true)
            )
        )
        try await feed.getOrCreate()
        
        let initialActivities = await feed.state.activities
        #expect(initialActivities.isEmpty)
        
        // Send activity without expiresAt - should be ignored due to filter
        await client.eventsMiddleware.sendEvent(
            ActivityAddedEvent.dummy(
                activity: .dummy(
                    expiresAt: nil,
                    id: "non-expiring-activity",
                    text: "This activity doesn't expire"
                ),
                fid: feed.feed.rawValue
            )
        )
        
        // Verify the activity was ignored and not inserted
        let finalActivities = await feed.state.activities
        #expect(finalActivities.isEmpty)
    }
    
    @Test func activityUpdatedEventChangesText() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetOrCreateFeedResponse.dummy(activities: [.dummy(id: "1")])
            ])
        )
        let feed = client.feed(group: "user", id: "jane")
        try await feed.getOrCreate()
        
        await client.eventsMiddleware.sendEvent(
            ActivityUpdatedEvent.dummy(
                activity: .dummy(id: "1", text: "NEW TEXT"),
                fid: feed.feed.rawValue
            )
        )
        let result = await feed.state.activities.first?.text
        #expect(result == "NEW TEXT")
    }
    
    @Test func activityUpdatedEventIsNotInsertedToFeedIfItWasNotPaginated() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                GetOrCreateFeedResponse.dummy(activities: [.dummy(id: "1")])
            ])
        )
        let feed = client.feed(group: "user", id: "jane")
        try await feed.getOrCreate()
        
        await #expect(feed.state.activities.map(\.id) == ["1"])
        
        await client.eventsMiddleware.sendEvent(
            ActivityUpdatedEvent.dummy(
                activity: .dummy(id: "2"),
                fid: feed.feed.rawValue
            )
        )
        await #expect(feed.state.activities.map(\.id) == ["1"])
    }
    
    // MARK: -
    
    private func defaultClientWithActivities(
        feed: String,
        _ additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    GetOrCreateFeedResponse.dummy(
                        activities: [.dummy(id: "1")],
                        feed: .dummy(feed: feed),
                        followers: [
                            FollowResponse.dummy(
                                sourceFeed: .dummy(feed: "user:bob"),
                                status: .pending,
                                targetFeed: .dummy(feed: feed)
                            ),
                            FollowResponse.dummy(
                                sourceFeed: .dummy(feed: "user:bob"),
                                targetFeed: .dummy(feed: feed)
                            )
                        ],
                        following: [
                            FollowResponse.dummy(
                                sourceFeed: .dummy(feed: feed),
                                targetFeed: .dummy(feed: "user:bob")
                            )
                        ],
                        members: [.dummy(user: .dummy(id: "feed-member-1"))]
                    )
                ] + additionalPayloads
            )
        )
    }
}
