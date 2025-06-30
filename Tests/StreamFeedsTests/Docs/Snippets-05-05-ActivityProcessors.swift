//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamFeeds

struct Snippets_05_04_ActivityProcessors {
    var client: FeedsClient!
    var feed: Feed!
    
    func activityProcessors() {
        // Note: This is typically configured server-side
        let imageProcessor = ["type": "image_topic"]
        let textProcessor = ["type": "text_topic"]

        // Run image and text activity processors on any new activity
        // Adds the topics found to the activity.interest_tags
        let feedGroupConfig: [String: Any] = [
            "id": "foryou",
            "activity_processors": [imageProcessor, textProcessor]
        ]
        
        suppressUnusedWarning(feedGroupConfig)
    }
    
    func topicAnalyzer() {
        // Note: This is typically configured server-side
        let feedGroupConfig: [String: Any] = [
            "id": "myid",
            "activity_processors": [["type": "topic"]]
        ]
        
        suppressUnusedWarning(feedGroupConfig)
    }
    
    func topicAnalyzer2() async throws {
        let activity = try await feed.addActivity(
            request: .init(
                text: "check out my 10 fitness tips for reducing lower back pain",
                type: "post"
            )
        )
        // The activity will now have topics automatically added
        print(activity.interestTags) // ["fitness", "health", "tips"]
    }
}
