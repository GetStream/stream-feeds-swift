//
// Copyright © 2025 Stream.io Inc. All rights reserved.
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
                    Attachment(imageUrl: "https://example.com/image.jpg", type: "image")
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
                    Attachment(imageUrl: "https://example.com/image1.jpg", type: "image"),
                    Attachment(assetUrl: "https://example.com/video1.mp4", type: "video")
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
}
