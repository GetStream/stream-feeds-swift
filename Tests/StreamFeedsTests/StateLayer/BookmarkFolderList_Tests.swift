//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct BookmarkFolderList_Tests {
    // MARK: - Actions

    @Test func getUpdatesState() async throws {
        let client = defaultClientWithBookmarkFolderResponses()
        let bookmarkFolderList = client.bookmarkFolderList(for: BookmarkFoldersQuery())
        let folders = try await bookmarkFolderList.get()
        let stateFolders = await bookmarkFolderList.state.folders
        #expect(folders.count == 2)
        #expect(stateFolders.count == 2)
        #expect(stateFolders.map(\.id) == ["folder-1", "folder-2"])
        #expect(folders.map(\.id) == stateFolders.map(\.id))
        await #expect(bookmarkFolderList.state.canLoadMore == true)
        await #expect(bookmarkFolderList.state.pagination?.next == "next-cursor")
    }

    @Test func queryMoreBookmarkFoldersUpdatesState() async throws {
        let client = defaultClientWithBookmarkFolderResponses([
            QueryBookmarkFoldersResponse.dummy(
                bookmarkFolders: [
                    .dummy(id: "folder-3", name: "Third Folder"),
                    .dummy(id: "folder-4", name: "Fourth Folder")
                ],
                next: "next-cursor-2"
            )
        ])
        let bookmarkFolderList = client.bookmarkFolderList(for: BookmarkFoldersQuery())

        // Initial load
        _ = try await bookmarkFolderList.get()
        let initialState = await bookmarkFolderList.state.folders
        #expect(initialState.count == 2)
        #expect(initialState.map(\.id) == ["folder-1", "folder-2"])

        // Load more
        let moreFolders = try await bookmarkFolderList.queryMoreBookmarkFolders()
        let updatedState = await bookmarkFolderList.state.folders
        #expect(moreFolders.count == 2)
        #expect(moreFolders.map(\.id) == ["folder-3", "folder-4"])
        #expect(updatedState.count == 4)
        // The folders should be sorted by createdAt in descending order (newest first)
        #expect(updatedState.map(\.id) == ["folder-3", "folder-4", "folder-1", "folder-2"])
        await #expect(bookmarkFolderList.state.canLoadMore == true)
        await #expect(bookmarkFolderList.state.pagination?.next == "next-cursor-2")
    }

    @Test func queryMoreBookmarkFoldersWhenNoMoreFoldersReturnsEmpty() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                QueryBookmarkFoldersResponse.dummy(
                    bookmarkFolders: [
                        .dummy(id: "folder-1", name: "First Folder"),
                        .dummy(id: "folder-2", name: "Second Folder")
                    ],
                    next: nil
                )
            ])
        )
        let bookmarkFolderList = client.bookmarkFolderList(for: BookmarkFoldersQuery())

        // Initial load
        _ = try await bookmarkFolderList.get()

        // Check pagination state
        let pagination = await bookmarkFolderList.state.pagination
        #expect(pagination?.next == nil)

        // Try to load more when no more available - should return empty array
        let moreFolders = try await bookmarkFolderList.queryMoreBookmarkFolders()
        #expect(moreFolders.isEmpty)
    }

    @Test func getWithEmptyResponseUpdatesState() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                QueryBookmarkFoldersResponse.dummy(
                    bookmarkFolders: [],
                    next: nil
                )
            ])
        )
        let bookmarkFolderList = client.bookmarkFolderList(for: BookmarkFoldersQuery())
        let folders = try await bookmarkFolderList.get()
        let stateFolders = await bookmarkFolderList.state.folders
        #expect(folders.isEmpty)
        #expect(stateFolders.isEmpty)
        await #expect(bookmarkFolderList.state.canLoadMore == false)
        await #expect(bookmarkFolderList.state.pagination?.next == nil)
    }

    @Test func queryMoreBookmarkFoldersWithCustomLimit() async throws {
        let client = defaultClientWithBookmarkFolderResponses([
            QueryBookmarkFoldersResponse.dummy(
                bookmarkFolders: [
                    .dummy(id: "folder-3", name: "Third Folder")
                ],
                next: "next-cursor-2"
            )
        ])
        let bookmarkFolderList = client.bookmarkFolderList(for: BookmarkFoldersQuery())

        // Initial load
        _ = try await bookmarkFolderList.get()

        // Load more with custom limit
        let moreFolders = try await bookmarkFolderList.queryMoreBookmarkFolders(limit: 1)
        #expect(moreFolders.count == 1)
        #expect(moreFolders.first?.id == "folder-3")
    }

    // MARK: - WebSocket Events

    @Test func bookmarkFolderUpdatedEventUpdatesState() async throws {
        let client = defaultClientWithBookmarkFolderResponses()
        let bookmarkFolderList = client.bookmarkFolderList(for: BookmarkFoldersQuery())
        try await bookmarkFolderList.get()

        let initialState = await bookmarkFolderList.state.folders
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "folder-1" }?.name == "First Folder")

        // Send bookmark folder updated event
        await client.eventsMiddleware.sendEvent(
            BookmarkFolderUpdatedEvent.dummy(
                bookmarkFolder: .dummy(id: "folder-1", name: "Updated First Folder")
            )
        )

        let updatedState = await bookmarkFolderList.state.folders
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "folder-1" }?.name == "Updated First Folder")
        #expect(updatedState.first { $0.id == "folder-2" }?.name == "Second Folder")
    }

    @Test func bookmarkFolderDeletedEventUpdatesState() async throws {
        let client = defaultClientWithBookmarkFolderResponses()
        let bookmarkFolderList = client.bookmarkFolderList(for: BookmarkFoldersQuery())
        try await bookmarkFolderList.get()

        let initialState = await bookmarkFolderList.state.folders
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "folder-1" }?.name == "First Folder")

        // Send bookmark folder deleted event
        await client.eventsMiddleware.sendEvent(
            BookmarkFolderDeletedEvent.dummy(
                bookmarkFolder: .dummy(id: "folder-1", name: "First Folder")
            )
        )

        let updatedState = await bookmarkFolderList.state.folders
        #expect(updatedState.count == 1)
        #expect(updatedState.first?.id == "folder-2")
        #expect(updatedState.first?.name == "Second Folder")
    }

    @Test func bookmarkFolderUpdatedEventForUnrelatedFolderDoesNotUpdateState() async throws {
        let client = defaultClientWithBookmarkFolderResponses()
        let bookmarkFolderList = client.bookmarkFolderList(for: BookmarkFoldersQuery())
        try await bookmarkFolderList.get()

        let initialState = await bookmarkFolderList.state.folders
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "folder-1" }?.name == "First Folder")

        // Send bookmark folder updated event for unrelated folder
        await client.eventsMiddleware.sendEvent(
            BookmarkFolderUpdatedEvent.dummy(
                bookmarkFolder: .dummy(id: "folder-other", name: "Other Folder")
            )
        )

        let updatedState = await bookmarkFolderList.state.folders
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "folder-1" }?.name == "First Folder")
        #expect(updatedState.first { $0.id == "folder-2" }?.name == "Second Folder")
    }

    @Test func bookmarkFolderDeletedEventForUnrelatedFolderDoesNotUpdateState() async throws {
        let client = defaultClientWithBookmarkFolderResponses()
        let bookmarkFolderList = client.bookmarkFolderList(for: BookmarkFoldersQuery())
        try await bookmarkFolderList.get()

        let initialState = await bookmarkFolderList.state.folders
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "folder-1" }?.name == "First Folder")

        // Send bookmark folder deleted event for unrelated folder
        await client.eventsMiddleware.sendEvent(
            BookmarkFolderDeletedEvent.dummy(
                bookmarkFolder: .dummy(id: "folder-other", name: "Other Folder")
            )
        )

        let updatedState = await bookmarkFolderList.state.folders
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "folder-1" }?.name == "First Folder")
        #expect(updatedState.first { $0.id == "folder-2" }?.name == "Second Folder")
    }

    // MARK: - Helper Methods

    private func defaultClientWithBookmarkFolderResponses(
        _ additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryBookmarkFoldersResponse.dummy(
                        bookmarkFolders: [
                            .dummy(id: "folder-1", name: "First Folder"),
                            .dummy(id: "folder-2", name: "Second Folder")
                        ],
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
