//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct BookmarkFolderListState_Tests {
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
                    .dummy(id: "folder-3", name: "Test Folder 3"),
                    .dummy(id: "folder-4", name: "Test Folder 4")
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
        await #expect(bookmarkFolderList.state.canLoadMore == true)
        await #expect(bookmarkFolderList.state.pagination?.next == "next-cursor-2")
    }

    // MARK: - WebSocket Events

    @Test func bookmarkFolderUpdatedEventUpdatesState() async throws {
        let client = defaultClientWithBookmarkFolderResponses()
        let bookmarkFolderList = client.bookmarkFolderList(for: BookmarkFoldersQuery())

        // Initial load
        _ = try await bookmarkFolderList.get()
        let initialState = await bookmarkFolderList.state.folders
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "folder-1" }?.name == "Test Folder 1")

        // Send bookmark folder updated event
        let updatedFolder = BookmarkFolderResponse.dummy(id: "folder-1", name: "Updated Folder Name").toModel()
        await client.stateLayerEventPublisher.sendEvent(.bookmarkFolderUpdated(updatedFolder))

        // Wait a bit for the event to be processed
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        let updatedState = await bookmarkFolderList.state.folders
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "folder-1" }?.name == "Updated Folder Name")
    }

    @Test func bookmarkFolderDeletedEventUpdatesState() async throws {
        let client = defaultClientWithBookmarkFolderResponses()
        let bookmarkFolderList = client.bookmarkFolderList(for: BookmarkFoldersQuery())

        // Initial load
        _ = try await bookmarkFolderList.get()
        let initialState = await bookmarkFolderList.state.folders
        #expect(initialState.count == 2)
        #expect(initialState.map(\.id) == ["folder-1", "folder-2"])

        // Send bookmark folder deleted event
        let deletedFolder = BookmarkFolderResponse.dummy(id: "folder-1", name: "Test Folder 1").toModel()
        await client.stateLayerEventPublisher.sendEvent(.bookmarkFolderDeleted(deletedFolder))

        // Wait a bit for the event to be processed
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        let updatedState = await bookmarkFolderList.state.folders
        #expect(updatedState.count == 1)
        #expect(updatedState.map(\.id) == ["folder-2"])
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
                            .dummy(id: "folder-1", name: "Test Folder 1"),
                            .dummy(id: "folder-2", name: "Test Folder 2")
                        ],
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
