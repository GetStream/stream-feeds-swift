//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_03_04_ActivityMetrics {
    var client: FeedsClient!

    func readingMetrics() async throws {
        let activity = client.activity(
            for: "activity_123",
            in: FeedId(group: "user", id: "john")
        )
        let activityData = try await activity.get()

        // `metrics` carries the counters the server tracks for the activity, such as
        // impressions and clicks. It is nil until a metric is tracked.
        let metrics = activityData.metrics ?? [:]
        print(metrics)
        print("\(metrics["views"] ?? 0) views")
    }
}
