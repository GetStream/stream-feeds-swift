//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
@testable import StreamFeeds
import Testing

struct BookmarkListState_Tests {
    // MARK: - Actions

    @Test func getUpdatesState() async throws {
        let client = defaultClientWithBookmarkResponses()
        let bookmarkList = client.bookmarkList(for: BookmarksQuery())
        let bookmarks = try await bookmarkList.get()
        let stateBookmarks = await bookmarkList.state.bookmarks
        #expect(bookmarks.count == 2)
        #expect(stateBookmarks.count == 2)
        #expect(stateBookmarks.map(\.id) == ["user-1-activity-1", "user-1-activity-2"])
        #expect(bookmarks.map(\.id) == stateBookmarks.map(\.id))
        await #expect(bookmarkList.state.canLoadMore == true)
        await #expect(bookmarkList.state.pagination?.next == "next-cursor")
    }

    @Test func queryMoreBookmarksUpdatesState() async throws {
        let client = defaultClientWithBookmarkResponses([
            QueryBookmarksResponse.dummy(
                bookmarks: [
                    .dummy(activity: .dummy(id: "activity-3"), user: .dummy(id: "user-1")),
                    .dummy(activity: .dummy(id: "activity-4"), user: .dummy(id: "user-1"))
                ],
                next: "next-cursor-2"
            )
        ])
        let bookmarkList = client.bookmarkList(for: BookmarksQuery())

        // Initial load
        _ = try await bookmarkList.get()
        let initialState = await bookmarkList.state.bookmarks
        #expect(initialState.count == 2)
        #expect(initialState.map(\.id) == ["user-1-activity-1", "user-1-activity-2"])

        // Load more
        let moreBookmarks = try await bookmarkList.queryMoreBookmarks()
        let updatedState = await bookmarkList.state.bookmarks
        #expect(moreBookmarks.count == 2)
        #expect(moreBookmarks.map(\.id) == ["user-1-activity-3", "user-1-activity-4"])
        #expect(updatedState.count == 4)
        await #expect(bookmarkList.state.canLoadMore == true)
        await #expect(bookmarkList.state.pagination?.next == "next-cursor-2")
    }

    // MARK: - WebSocket Events

    @Test func bookmarkUpdatedEventUpdatesState() async throws {
        let client = defaultClientWithBookmarkResponses()
        let bookmarkList = client.bookmarkList(for: BookmarksQuery())

        // Initial load
        _ = try await bookmarkList.get()
        let initialState = await bookmarkList.state.bookmarks
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "user-1-activity-1" }?.activity.text == "Test activity content")

        // Send bookmark updated event
        let updatedBookmark = BookmarkResponse.dummy(
            activity: .dummy(id: "activity-1", text: "Updated activity content"),
            folder: .dummy(id: "folder-1", name: "Test Folder"),
            user: .dummy(id: "user-1")
        ).toModel()
        await client.stateLayerEventPublisher.sendEvent(.bookmarkUpdated(updatedBookmark))

        // Wait a bit for the event to be processed
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        let updatedState = await bookmarkList.state.bookmarks
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "user-1-activity-1" }?.activity.text == "Updated activity content")
    }

    @Test func bookmarkFolderUpdatedEventUpdatesState() async throws {
        let client = defaultClientWithBookmarkResponses()
        let bookmarkList = client.bookmarkList(for: BookmarksQuery())

        // Initial load
        _ = try await bookmarkList.get()
        let initialState = await bookmarkList.state.bookmarks
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "user-1-activity-1" }?.folder?.name == "Test Folder")

        // Send bookmark folder updated event
        let updatedFolder = BookmarkFolderResponse.dummy(id: "folder-1", name: "Updated Folder Name").toModel()
        await client.stateLayerEventPublisher.sendEvent(.bookmarkFolderUpdated(updatedFolder))

        // Wait a bit for the event to be processed
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        let updatedState = await bookmarkList.state.bookmarks
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "user-1-activity-1" }?.folder?.name == "Updated Folder Name")
    }

    @Test func bookmarkFolderDeletedEventUpdatesState() async throws {
        let client = defaultClientWithBookmarkResponses()
        let bookmarkList = client.bookmarkList(for: BookmarksQuery())

        // Initial load
        _ = try await bookmarkList.get()
        let initialState = await bookmarkList.state.bookmarks
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "user-1-activity-1" }?.folder?.id == "folder-1")

        // Send bookmark folder deleted event
        let deletedFolder = BookmarkFolderResponse.dummy(id: "folder-1", name: "Test Folder").toModel()
        await client.stateLayerEventPublisher.sendEvent(.bookmarkFolderDeleted(deletedFolder))

        // Wait a bit for the event to be processed
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        let updatedState = await bookmarkList.state.bookmarks
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "user-1-activity-1" }?.folder == nil)
    }

    // MARK: - Helper Methods

    private func defaultClientWithBookmarkResponses(
        _ additionalPayloads: [any Encodable] = []
    ) -> FeedsClient {
        FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryBookmarksResponse.dummy(
                        bookmarks: [
                            .dummy(
                                activity: .dummy(id: "activity-1"),
                                folder: .dummy(id: "folder-1", name: "Test Folder"),
                                user: .dummy(id: "user-1")
                            ),
                            .dummy(
                                activity: .dummy(id: "activity-2"),
                                folder: .dummy(id: "folder-1", name: "Test Folder"),
                                user: .dummy(id: "user-1")
                            )
                        ],
                        next: "next-cursor"
                    )
                ] + additionalPayloads
            )
        )
    }
}
