//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_06_07_Collections {
    var client: FeedsClient!
    var feed: Feed!

    func creatingCollections() async throws {
        let collections = try await client.createCollections(
            request: CreateCollectionsRequest(
                collections: [
                    CollectionRequest(
                        custom: [
                            "genre": "fantasy",
                            "rating": 9,
                            "title": "Lord of the Rings"
                        ],
                        id: "lord_of_the_rings",
                        name: "movies"
                    )
                ]
            )
        )

        suppressUnusedWarning(collections)
    }

    func updatingCollections() async throws {
        let collections = try await client.updateCollections(
            request: UpdateCollectionsRequest(
                collections: [
                    UpdateCollectionRequest(
                        custom: [
                            "genre": "fantasy",
                            "rating": 9.5,
                            "title": "Lord of the Rings"
                        ],
                        id: "lord_of_the_rings",
                        name: "movies"
                    )
                ]
            )
        )

        suppressUnusedWarning(collections)
    }

    func deletingCollections() async throws {
        try await client.deleteCollections(references: ["movies:lord_of_the_rings"])
    }

    func readingCollections() async throws {
        let collections = try await client.readCollections(references: ["movies:lord_of_the_rings"])

        suppressUnusedWarning(collections)
    }

    func queryingCollections() async throws {
        let query = CollectionsQuery(
            filter: .equal(.name, "movies"),
            sort: [Sort(field: .createdAt, direction: .reverse)],
            limit: 10
        )
        let collectionList = client.collectionList(for: query)
        let collections = try await collectionList.get()
        // collectionList.state.canLoadMore tells whether there is a next page

        suppressUnusedWarning(collections)
    }

    func paginatingCollections() async throws {
        let collectionList = client.collectionList(for: CollectionsQuery(filter: .equal(.name, "movies"), limit: 100))
        try await collectionList.get()
        while collectionList.state.canLoadMore {
            try await collectionList.queryMoreCollections(limit: 100)
        }
        let allCollections = collectionList.state.collections

        suppressUnusedWarning(allCollections)
    }

    func addingCollectionsToAnActivity() async throws {
        let activity = try await feed.addActivity(
            request: FeedAddActivityRequest(
                collectionReferences: ["movies:lord_of_the_rings"],
                text: "I love this movie!",
                type: "post"
            )
        )

        suppressUnusedWarning(activity)
    }

    func enrichment() async throws {
        // Create a collection
        try await client.createCollections(
            request: CreateCollectionsRequest(
                collections: [
                    CollectionRequest(
                        custom: [
                            "genre": "fantasy",
                            "rating": 9,
                            "title": "Lord of the Rings"
                        ],
                        id: "lord_of_the_rings",
                        name: "movies"
                    )
                ]
            )
        )

        // Add the reference to an activity
        let feed = client.feed(group: "user", id: "jack")
        try await feed.addActivity(
            request: FeedAddActivityRequest(
                collectionReferences: ["movies:lord_of_the_rings"],
                text: "I love this movie!",
                type: "post"
            )
        )

        // Read the feed and see the enriched collection data
        try await feed.getOrCreate()
        let movie = feed.state.activities[0].collections["movies:lord_of_the_rings"]
        print(movie?.custom ?? [:])
        // ["genre": "fantasy", "rating": 9, "title": "Lord of the Rings"]
    }
}
