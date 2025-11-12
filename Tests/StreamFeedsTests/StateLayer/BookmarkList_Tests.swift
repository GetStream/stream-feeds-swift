//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore
@testable import StreamFeeds
import Testing

struct BookmarkList_Tests {
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
        // The bookmarks should be sorted by createdAt in ascending order (oldest first)
        #expect(updatedState.map(\.id) == ["user-1-activity-3", "user-1-activity-4", "user-1-activity-1", "user-1-activity-2"])
        await #expect(bookmarkList.state.canLoadMore == true)
        await #expect(bookmarkList.state.pagination?.next == "next-cursor-2")
    }

    @Test func queryMoreBookmarksWhenNoMoreBookmarksReturnsEmpty() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                QueryBookmarksResponse.dummy(
                    bookmarks: [
                        .dummy(activity: .dummy(id: "activity-1"), user: .dummy(id: "user-1")),
                        .dummy(activity: .dummy(id: "activity-2"), user: .dummy(id: "user-1"))
                    ],
                    next: nil
                )
            ])
        )
        let bookmarkList = client.bookmarkList(for: BookmarksQuery())

        // Initial load
        _ = try await bookmarkList.get()

        // Check pagination state
        let pagination = await bookmarkList.state.pagination
        #expect(pagination?.next == nil)

        // Try to load more when no more available - should return empty array
        let moreBookmarks = try await bookmarkList.queryMoreBookmarks()
        #expect(moreBookmarks.isEmpty)
    }

    @Test func getWithEmptyResponseUpdatesState() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads([
                QueryBookmarksResponse.dummy(
                    bookmarks: [],
                    next: nil
                )
            ])
        )
        let bookmarkList = client.bookmarkList(for: BookmarksQuery())
        let bookmarks = try await bookmarkList.get()
        let stateBookmarks = await bookmarkList.state.bookmarks
        #expect(bookmarks.isEmpty)
        #expect(stateBookmarks.isEmpty)
        await #expect(bookmarkList.state.canLoadMore == false)
        await #expect(bookmarkList.state.pagination?.next == nil)
    }

    @Test func queryMoreBookmarksWithCustomLimit() async throws {
        let client = defaultClientWithBookmarkResponses([
            QueryBookmarksResponse.dummy(
                bookmarks: [
                    .dummy(activity: .dummy(id: "activity-3"), user: .dummy(id: "user-1"))
                ],
                next: "next-cursor-2"
            )
        ])
        let bookmarkList = client.bookmarkList(for: BookmarksQuery())

        // Initial load
        _ = try await bookmarkList.get()

        // Load more with custom limit
        let moreBookmarks = try await bookmarkList.queryMoreBookmarks(limit: 1)
        #expect(moreBookmarks.count == 1)
        #expect(moreBookmarks.first?.id == "user-1-activity-3")
    }

    // MARK: - WebSocket Events

    @Test func bookmarkUpdatedEventUpdatesState() async throws {
        let client = defaultClientWithBookmarkResponses()
        let bookmarkList = client.bookmarkList(for: BookmarksQuery())
        try await bookmarkList.get()

        let initialState = await bookmarkList.state.bookmarks
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "user-1-activity-1" }?.activity.text == "Test activity content")

        // Send bookmark updated event
        await client.eventsMiddleware.sendEvent(
            BookmarkUpdatedEvent.dummy(
                bookmark: .dummy(
                    activity: .dummy(id: "activity-1", text: "Updated activity content"),
                    user: .dummy(id: "user-1")
                ),
                fid: "user:test"
            )
        )

        let updatedState = await bookmarkList.state.bookmarks
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "user-1-activity-1" }?.activity.text == "Updated activity content")
        #expect(updatedState.first { $0.id == "user-1-activity-2" }?.activity.text == "Test activity content")
    }

    @Test func bookmarkFolderUpdatedEventUpdatesState() async throws {
        let client = defaultClientWithBookmarkResponses()
        let bookmarkList = client.bookmarkList(for: BookmarksQuery())
        try await bookmarkList.get()

        let initialState = await bookmarkList.state.bookmarks
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "user-1-activity-1" }?.folder?.name == "Test Folder")

        // Send bookmark folder updated event
        await client.eventsMiddleware.sendEvent(
            BookmarkFolderUpdatedEvent.dummy(
                bookmarkFolder: .dummy(id: "folder-1", name: "Updated Folder Name")
            )
        )

        let updatedState = await bookmarkList.state.bookmarks
        #expect(updatedState.count == 2)
        #expect(updatedState.map(\.folder?.name) == ["Updated Folder Name", "Updated Folder Name"], "Same folder")
    }

    @Test func bookmarkFolderDeletedEventUpdatesState() async throws {
        let client = defaultClientWithBookmarkResponses()
        let bookmarkList = client.bookmarkList(for: BookmarksQuery())
        try await bookmarkList.get()

        let initialState = await bookmarkList.state.bookmarks
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "user-1-activity-1" }?.folder?.name == "Test Folder")

        // Send bookmark folder deleted event
        await client.eventsMiddleware.sendEvent(
            BookmarkFolderDeletedEvent.dummy(
                bookmarkFolder: .dummy(id: "folder-1", name: "Test Folder")
            )
        )

        let updatedState = await bookmarkList.state.bookmarks
        #expect(updatedState.count == 2)
        #expect(updatedState.map(\.folder) == [nil, nil], "Same folder")
    }

    @Test func bookmarkUpdatedEventForUnrelatedUserDoesNotUpdateState() async throws {
        let client = defaultClientWithBookmarkResponses()
        let bookmarkList = client.bookmarkList(for: BookmarksQuery())
        try await bookmarkList.get()

        let initialState = await bookmarkList.state.bookmarks
        #expect(initialState.count == 2)
        #expect(initialState.first { $0.id == "user-1-activity-1" }?.activity.text == "Test activity content")

        // Send bookmark updated event for unrelated user
        await client.eventsMiddleware.sendEvent(
            BookmarkUpdatedEvent.dummy(
                bookmark: .dummy(
                    activity: .dummy(id: "activity-1", text: "Updated activity content"),
                    user: .dummy(id: "user-other")
                ),
                fid: "user:other"
            )
        )

        let updatedState = await bookmarkList.state.bookmarks
        #expect(updatedState.count == 2)
        #expect(updatedState.first { $0.id == "user-1-activity-1" }?.activity.text == "Test activity content")
        #expect(updatedState.first { $0.id == "user-1-activity-2" }?.activity.text == "Test activity content")
    }

    @Test func bookmarkUpdatedEventRemovesBookmarkWhenNoLongerMatchingQuery() async throws {
        let client = FeedsClient.mock(
            apiTransport: .withPayloads(
                [
                    QueryBookmarksResponse.dummy(
                        bookmarks: [
                            .dummy(
                                activity: .dummy(id: "activity-1"),
                                folder: .dummy(id: "folder-1", name: "Test Folder"),
                                updatedAt: .fixed(offset: 0),
                                user: .dummy(id: "user-1")
                            )
                        ],
                        next: nil
                    )
                ]
            )
        )
        let bookmarkList = client.bookmarkList(
            for: BookmarksQuery(
                filter: .less(.updatedAt, Date.fixed(offset: 1))
            )
        )
        try await bookmarkList.get()

        // Verify initial state has the bookmark that matches the filter
        let initialBookmarks = await bookmarkList.state.bookmarks
        #expect(initialBookmarks.count == 1)
        #expect(initialBookmarks.first?.id == "user-1-activity-1")
        #expect(initialBookmarks.first?.updatedAt == .fixed(offset: 0))

        // Send bookmark updated event where the updatedAt changes to a later time
        // This should cause the bookmark to no longer match the query filter
        await client.eventsMiddleware.sendEvent(
            BookmarkUpdatedEvent.dummy(
                bookmark: .dummy(
                    activity: .dummy(id: "activity-1", text: "Updated activity content"),
                    folder: .dummy(id: "folder-1", name: "Test Folder"),
                    updatedAt: .fixed(offset: 2),
                    user: .dummy(id: "user-1")
                ),
                fid: "user:test"
            )
        )

        // Bookmark should be removed since it no longer matches the updatedAt filter
        let bookmarksAfterUpdate = await bookmarkList.state.bookmarks
        #expect(bookmarksAfterUpdate.isEmpty)
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
