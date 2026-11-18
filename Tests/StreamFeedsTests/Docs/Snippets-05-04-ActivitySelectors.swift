//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import CoreLocation
import Foundation
import StreamCore
import StreamFeeds

@MainActor struct Snippets_05_04_ActivitySelectors {
    var client: FeedsClient!

    func popularActivitySelector() async throws {
        // Note: This is typically configured server-side
        let popularSelector: [String: Any] = [
            "min_popularity": 10,
            "type": "popular"
        ]

        let feedGroupConfig: [String: Any] = [
            "id": "foryou",
            "activity_selectors": [popularSelector]
        ]

        suppressUnusedWarning(feedGroupConfig)
    }

    func proximityActivitySelector() async throws {
        // Provide the filter when reading the feed. `withinBounds` takes the corners
        // of the box to search in.
        let boundsFeed = client.feed(
            for: FeedQuery(
                group: "user",
                id: "john",
                activityFilter: .and([
                    .equal(
                        .withinBounds,
                        BoundingBox(
                            northeast: CLLocationCoordinate2D(latitude: 52.43017, longitude: 4.924821),
                            southwest: CLLocationCoordinate2D(latitude: 52.334272, longitude: 4.822116)
                        )
                    ),
                    // Optionally provide other filter properties, just like when querying
                    // activities
                    .equal(.activityType, "hike")
                ])
            )
        )
        try await boundsFeed.getOrCreate()

        // Use either withinBounds or near. `near` takes a point and a radius.
        let nearFeed = client.feed(
            for: FeedQuery(
                group: "user",
                id: "john",
                activityFilter: .equal(
                    .near,
                    CircularRegion(
                        center: CLLocationCoordinate2D(latitude: 52.373558, longitude: 4.885261),
                        radiusInKM: 10
                    )
                )
            )
        )
        try await nearFeed.getOrCreate()
    }

    func filterTags() {
        // Get all the activities where filter tags contain both "green" and "orange"
        let filter: ActivitiesFilter = .and([
            .in(.filterTags, ["green"]),
            .in(.filterTags, ["orange"])
        ])

        suppressUnusedWarning(filter)
    }
}
