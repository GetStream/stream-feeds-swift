//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_05_01_FeedGroups {
    var client: FeedsClient!
    var feed: Feed!
    var notificationFeed: Feed!
    var countAggregation: [String: Any]!
    
    func creatingFeedGroupsDefaults() async throws {
        // Note: Feed group management is typically done server-side
        // This is an example of the configuration structure
        let feedGroupConfig: [String: Any] = [
            "id": "myid",
            "activity_processors": [["type": "topic"]], // activity processors do post processing on activities. AI topic analysis, etc.
            "activity_selectors": [["type": "following"]], // control how activities end up in this feed. direct, following, search, querying etc.
            "ranking": ["type": "time"], // how activities are ranked
            "aggregation": ["type": "count"], // group activities together
            "notification": ["type": "count"], // keep track of seen and read state on notification feeds
            "custom": ["description": "My custom feed group"] // anything else to store on the feed group
        ]
        
        suppressUnusedWarning(feedGroupConfig)
    }
    
    func activityRanking() async throws {
        // Note: This is typically configured server-side
        let rankingConfig = [
            "type": "time",
            "score": "decay_linear(time) * popularity"
        ]

        let feedGroupConfig: [String: Any] = [
            "id": "timeline",
            "ranking": rankingConfig
        ]
        
        suppressUnusedWarning(feedGroupConfig)
    }
    
    func interestBasedForYouStyleFeed() async throws {
        // Note: This is typically configured server-side

        // Run the activity processors to analyse topics for text & images
        let imageProcessor = ["type": "image_topic"]
        let textProcessor = ["type": "text_topic"]
        let userFeedConfig: [String: Any] = [
            "id": "user",
            "activity_processors": [imageProcessor, textProcessor]
        ]

        // Activity selectors change which activities are included in the feed
        // The default "following" selectors gets activities from the feeds you follow
        // The "popular" activity selectors includes the popular activities
        // And "interest" activities similar to activities you've engaged with in the past
        // You can use multiple selectors in 1 feed
        let activitySelectors = [
            ["type": "popular"],
            ["type": "following"],
            ["type": "interest"]
        ]

        // Rank for a user based on interest score
        // This calculates a score 0-1.0 of how well the activity matches the user's prior interest
        let rankingConfig = [
            "type": "interest",
            "score": "decay_linear(time) * interest * decay_linear(popularity)"
        ]

        let timelineConfig: [String: Any] = [
            "id": "timeline",
            "ranking": rankingConfig,
            "activity_selectors": activitySelectors
        ]

        // Read the feed
        // Activities will include following, popular and similar (via interest) activities
        // Sorted by time decay, interest and popularity
        let forYouFeed = client.feed(group: "timeline", id: "thierry")
        let response = try await forYouFeed.getOrCreate()
        
        suppressUnusedWarning(timelineConfig, userFeedConfig, response)
    }
    
    func additionalRanking() async throws {
        // Pass external ranking data when reading the feed
        let query = FeedQuery(
            group: "timeline",
            id: "thierry",
            externalRanking: [
                "user_engagement_score": 0.8,
                "content_preference": 0.9,
                "time_of_day_bonus": 1.2
            ]
        )
        let feed = client.feed(for: query)
        let feedData = try await feed.getOrCreate()
        
        suppressUnusedWarning(feedData)
    }
    
    func additionalRanking2() async throws {
        let activity = try await feed.addActivity(
            request: .init(
                custom: [
                    "quality_score": 0.95,
                    "engagement_prediction": 0.8
                ],
                text: "Great content",
                type: "post"
            )
        )
        
        suppressUnusedWarning(activity)
    }
    
    func timeBasedRanking() {
        // Simple time-based ranking (newest first)
        let timeRanking = [
            "type": "time",
            "direction": "desc"
        ]
        
        suppressUnusedWarning(timeRanking)
    }
    
    func popularityBasedRanking() {
        // Rank by popularity (likes, comments, shares)
        let popularityRanking = [
            "type": "popularity",
            "score": "likes + comments * 2 + shares * 3"
        ]
        
        suppressUnusedWarning(popularityRanking)
    }
    
    func hybridRanking() {
        // Combine time decay with popularity
        let hybridRanking = [
            "type": "hybrid",
            "score": "decay_linear(time, 24h) * (likes + comments + shares)"
        ]
        
        suppressUnusedWarning(hybridRanking)
    }
    
    func interestBasedRanking() {
        // Rank based on user interests and engagement history
        let interestRanking = [
            "type": "interest",
            "score": "decay_linear(time) * interest_match * engagement_prediction"
        ]
        
        suppressUnusedWarning(interestRanking)
    }
    
    func aggregationTypes() {
        // Count aggregation - shows "John and 5 others liked your post"
        let countAggregation: [String: Any] = [
            "type": "count",
            "group_by": ["activity_id", "reaction_type"]
        ]
        // Time-based aggregation - groups activities within a time window
        let timeAggregation = [
            "type": "time",
            "window": "1h"
        ]
        // User-based aggregation - groups activities by user
        let userAggregation: [String: Any] = [
            "type": "user",
            "group_by": ["user_id"]
        ]
        
        suppressUnusedWarning(countAggregation, timeAggregation, userAggregation)
    }
    
    func notificationFeedExample() async throws {
        // Create a notification feed with aggregation
        let notificationFeed = client.feed(group: "notification", id: "john")

        // Configure it with aggregation
        let notificationConfig = [
            "aggregation": countAggregation,
            "ranking": ["type": "time", "direction": "desc"]
        ]
        // TODO: How?

        // Read notifications
        let notifications = try await notificationFeed.getOrCreate()
        
        suppressUnusedWarning(notifications, notificationConfig)
    }
    
    func markingNotificationsAsRead() async throws {
        // Mark specific notifications as read
        try await notificationFeed.markActivity(
            request: .init(
                markRead: ["notification_1", "notification_2"]
            )
        )
        // Mark all notifications as read
        try await notificationFeed.markActivity(
            request: .init(
                markAllRead: true
            )
        )
    }
}
