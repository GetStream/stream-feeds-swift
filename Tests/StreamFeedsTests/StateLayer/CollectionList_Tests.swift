//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds
import Testing

struct CollectionList_Tests {
    // MARK: - Paginating

    @Test func getUpdatesState() async throws {
        let client = clientWithFirstPage()
        let collectionList = client.collectionList(for: CollectionsQuery(filter: .equal(.name, "movies")))

        let collections = try await collectionList.get()

        #expect(collections.map(\.reference) == ["movies:item-2", "movies:item-1"])
        await #expect(collectionList.state.collections.map(\.reference) == ["movies:item-2", "movies:item-1"])
        await #expect(collectionList.state.canLoadMore == true)
    }

    @Test func queryMoreCollectionsAppendsNextPage() async throws {
        let client = clientWithFirstPage([
            QueryCollectionsResponse(collections: [Self.collection("item-0", createdAt: 0)], next: nil)
        ])
        let collectionList = client.collectionList(for: CollectionsQuery(filter: .equal(.name, "movies")))
        try await collectionList.get()

        let more = try await collectionList.queryMoreCollections()

        #expect(more.map(\.reference) == ["movies:item-0"])
        await #expect(collectionList.state.collections.map(\.reference) == ["movies:item-2", "movies:item-1", "movies:item-0"])
        await #expect(collectionList.state.canLoadMore == false)
        #expect(try await collectionList.queryMoreCollections().isEmpty)
    }

    @Test func reconnectionRefetchesLoadedCollections() async throws {
        let client = clientWithFirstPage([
            QueryCollectionsResponse(collections: [Self.collection("item-3", createdAt: 3)], next: nil)
        ])
        let collectionList = client.collectionList(for: CollectionsQuery(filter: .equal(.name, "movies")))
        try await collectionList.get()

        client.simulateReconnection()

        try await waitUntil { collectionList.state.collections.map(\.reference) == ["movies:item-3"] }
        #expect(await collectionList.state.canLoadMore == false)
    }

    // MARK: - Local Updates

    @Test func createCollectionsInsertsMatchingCollections() async throws {
        let client = clientWithFirstPage([
            CreateCollectionsResponse(
                collections: [Self.collection("item-3", createdAt: 3), Self.collection("item-3", name: "books", createdAt: 3)]
            )
        ])
        let collectionList = client.collectionList(for: CollectionsQuery(filter: .equal(.name, "movies")))
        try await collectionList.get()

        try await client.createCollections(request: CreateCollectionsRequest(collections: [
            CollectionRequest(custom: [:], id: "item-3", name: "movies"),
            CollectionRequest(custom: [:], id: "item-3", name: "books")
        ]))

        try await waitUntil { collectionList.state.collections.map(\.reference) == ["movies:item-3", "movies:item-2", "movies:item-1"] }
    }

    @Test func updateCollectionsReplacesLoadedCollectionsAndKeepsCreatedAt() async throws {
        // Update responses don't carry the creation date
        let client = clientWithFirstPage([
            UpdateCollectionsResponse(
                collections: [CollectionResponse(custom: ["title": .string("Updated")], id: "item-2", name: "movies", userId: "user-1")]
            )
        ])
        let collectionList = client.collectionList(for: CollectionsQuery(filter: .equal(.name, "movies")))
        try await collectionList.get()

        try await client.updateCollections(request: UpdateCollectionsRequest(collections: [
            UpdateCollectionRequest(custom: ["title": .string("Updated")], id: "item-2", name: "movies")
        ]))

        try await waitUntil { collectionList.state.collections.first?.custom == ["title": .string("Updated")] }
        #expect(await collectionList.state.collections.map(\.reference) == ["movies:item-2", "movies:item-1"])
        #expect(await collectionList.state.collections.first?.createdAt == Date(timeIntervalSince1970: 2))
    }

    @Test func deleteCollectionsRemovesLoadedCollections() async throws {
        let client = clientWithFirstPage([DeleteCollectionsResponse()])
        let collectionList = client.collectionList(for: CollectionsQuery(filter: .equal(.name, "movies")))
        try await collectionList.get()

        try await client.deleteCollections(references: ["movies:item-1", "books:item-2"])

        try await waitUntil { collectionList.state.collections.map(\.reference) == ["movies:item-2"] }
    }

    // MARK: - Test Data

    private func clientWithFirstPage(_ additionalPayloads: [any Sendable] = []) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryCollectionsResponse(
                        collections: [Self.collection("item-2", createdAt: 2), Self.collection("item-1", createdAt: 1)],
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }

    private static func collection(
        _ id: String,
        name: String = "movies",
        createdAt: TimeInterval,
        custom: [String: RawJSON] = [:]
    ) -> CollectionResponse {
        CollectionResponse(createdAt: Date(timeIntervalSince1970: createdAt), custom: custom, id: id, name: name, userId: "user-1")
    }
}
