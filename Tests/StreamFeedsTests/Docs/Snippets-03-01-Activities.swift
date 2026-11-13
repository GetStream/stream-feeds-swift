//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Combine
import Foundation
import StreamCore
import StreamFeeds

struct Snippets_03_01_Activities {
    private var client: FeedsClient!
    private var feed: Feed!
    
    func creatingActivities() async throws {
        // Add an activity to 1 feed
        let activity = try await feed.addActivity(
            request: .init(
                text: "hello world",
                type: "post"
            )
        )
        // Add an activity to multiple feeds
        let multiFeedActivity = try await client.addActivity(
            request: .init(
                feeds: ["user:1", "stock:apple"],
                text: "apple stock will go up",
                type: "post"
            )
        )
        
        suppressUnusedWarning(activity)
        suppressUnusedWarning(multiFeedActivity)
    }
    
    func imageAndVideo() async throws {
        let imageActivity = try await feed.addActivity(
            request: .init(
                attachments: [
                    Attachment(custom: [:], imageUrl: "https://example.com/image.jpg", type: "image")
                ],
                text: "look at NYC",
                type: "post"
            )
        )
        
        suppressUnusedWarning(imageActivity)
    }
    
    func stories() async throws {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let storyActivity = try await feed.addActivity(
            request: .init(
                attachments: [
                    Attachment(custom: [:], imageUrl: "https://example.com/image1.jpg", type: "image"),
                    Attachment(assetUrl: "https://example.com/video1.mp4", custom: [:], type: "video")
                ],
                expiresAt: ISO8601DateFormatter().string(from: tomorrow),
                text: "My story",
                type: "story"
            )
        )
        
        suppressUnusedWarning(storyActivity)
    }
    
    func restrictedVisibility() async throws {
        let privateActivity = try await feed.addActivity(
            request: .init(
                text: "Premium content",
                type: "post",
                visibility: .tag,
                visibilityTag: "premium"
            )
        )
        // Only users with the permission to read premium activities can read this
        
        suppressUnusedWarning(privateActivity)
    }
    
    func addingManyActivities() async throws {
        let activities = [
            ActivityRequest(
                feeds: ["user:123"],
                id: "1",
                text: "hi",
                type: "post"
            ),
            ActivityRequest(
                feeds: ["user:456"],
                id: "2",
                text: "hi",
                type: "post"
            )
        ]
        let upsertedActivities = try await client.upsertActivities(activities)
        
        suppressUnusedWarning(upsertedActivities)
    }
    
    func updatingDeletingActivities() async throws {
        // Update an activity
        let updatedActivity = try await feed.updateActivity(
            id: "123",
            request: .init(
                custom: ["custom": "custom"],
                text: "Updated text"
            )
        )

        // Delete an activity
        let hardDelete = false // Soft delete sets deleted at but retains the data, hard delete fully removes it
        try await feed.deleteActivity(id: "123", hardDelete: hardDelete)

        // Batch delete activities
        try await client.deleteActivities(
            request: .init(
                hardDelete: false,
                ids: ["123", "456"]
            )
        )
        
        suppressUnusedWarning(updatedActivity)
    }

    func restrictingCommentReplies() async throws {
        // Post an activity that restricts who can reply or comment.
        // Options: .everyone (default), .nobody, .peopleIFollow.
        // The activity author can always comment regardless of this setting.
        let activity = try await feed.addActivity(
            request: FeedAddActivityRequest(
                restrictReplies: .peopleIFollow,
                text: "Only my followers can reply to this.",
                type: "post"
            )
        )

        // And change it on an activity that already exists
        try await feed.updateActivity(
            id: activity.id,
            request: UpdateActivityRequest(restrictReplies: .nobody)
        )
    }

    @MainActor func getActivity() async throws {
        // Create an activity instance
        let activity = client.activity(
            for: "activity123",
            in: FeedId(group: "user", id: "john")
        )

        // Get the latest data
        let activityData = try await activity.get()

        // Optionally query comments
        try await activity.queryComments()

        // Access the state for reactive updates
        let activityState = activity.state

        suppressUnusedWarning(activityData, activityState)
    }

    func partialActivityUpdates() async throws {
        // Partially set some fields
        var activity = try await feed.updateActivityPartial(
            id: "123",
            request: UpdateActivityPartialRequest(
                set: ["text": "Japan has over 6,800 islands."]
            )
        )
        print("Activity edited at: \(activity.editedAt.map { "\($0)" } ?? "never")")

        // Partially unset some fields
        activity = try await feed.updateActivityPartial(
            id: "123",
            request: UpdateActivityPartialRequest(
                unset: ["custom.color"]
            )
        )
        print("Activity edited at: \(activity.editedAt.map { "\($0)" } ?? "never")")
    }

    func restoreActivity() async throws {
        // Restore a soft-deleted activity
        let restoredActivity = try await feed.restoreActivity(id: "123")

        suppressUnusedWarning(restoredActivity)
    }
}
