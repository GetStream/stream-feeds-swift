//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
import StreamFeeds

@MainActor struct Snippets_05_06_Stories {
    var client: FeedsClient!
    var saraClient: FeedsClient!

    func postingStories() async throws {
        let johnStoryFeed = client.feed(group: "story", id: "john")
        try await johnStoryFeed.getOrCreate()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        try await johnStoryFeed.addActivity(
            request: FeedAddActivityRequest(
                attachments: [Attachment(custom: [:], imageUrl: "https://example.com/image.jpg", type: "image")],
                expiresAt: ISO8601DateFormatter().string(from: tomorrow),
                type: "post"
            )
        )
    }

    func followingStoryFeeds() async throws {
        let saraStoryTimeline = client.feed(group: "stories", id: "sara")
        try await saraStoryTimeline.getOrCreate()
        try await saraStoryTimeline.follow(FeedId(group: "story", id: "john"))
    }

    func readingStoryTimeline() async throws {
        let saraStoryTimeline = client.feed(group: "stories", id: "sara")
        try await saraStoryTimeline.getOrCreate()

        // Since story timeline is aggregated by user id, we read aggregated activities
        let johnStories = saraStoryTimeline.state.aggregatedActivities[0]
        // Display all of John's active stories
        for activity in johnStories.activities {
            // True if we watched a given story
            print(activity.isWatched == true)
        }

        // Mark a story as watched
        try await saraStoryTimeline.markActivity(
            request: MarkActivityRequest(markWatched: [johnStories.activities[0].id])
        )
    }

    func readingStoryFeed() async throws {
        // Sara reads John's story feed
        let johnStoryFeed = saraClient.feed(for: FeedQuery(group: "story", id: "john", activityLimit: 100))
        try await johnStoryFeed.getOrCreate()

        let johnStories = johnStoryFeed.state.activities
        // Display all of John's active stories
        for activity in johnStories {
            // True if we watched a given story
            print(activity.isWatched == true)
        }

        // Mark a story as watched
        try await johnStoryFeed.markActivity(
            request: MarkActivityRequest(markWatched: [johnStories[0].id])
        )
    }

    func readingExpiredStories() async throws {
        let query = ActivitiesQuery(
            filter: .and([
                .lessOrEqual(.expiresAt, Date()),
                .equal(.userId, "john")
            ]),
            sort: [Sort(field: .createdAt, direction: .reverse)]
        )
        let activityList = client.activityList(for: query)
        let expiredStories = try await activityList.get()

        suppressUnusedWarning(expiredStories)
    }
}
