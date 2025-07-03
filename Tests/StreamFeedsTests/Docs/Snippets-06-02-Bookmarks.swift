//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds

@MainActor struct Snippets_06_02_Bookmarks {
    var client: FeedsClient!
    var feed: Feed!
    
    func addingBookmark() async throws {
        // Adding a bookmark to a new folder
        let bookmark = try await feed.addBookmark(activityId: "activity_123")
        // Adding to an existing folder
        let bookmarkWithFolder = try await feed.addBookmark(
            activityId: "activity_123",
            request: .init(folderId: "folder_456")
        )
        // Update a bookmark (without a folder initially) - add custom data and move it to a new folder
        let updatedBookmark = try await feed.updateBookmark(
            activityId: "activity_123",
            request: .init(
                custom: ["color": "blue"],
                newFolder: .init(
                    custom: ["icon": "📁"],
                    name: "New folder name"
                )
            )
        )
        // Update a bookmark - move it from one existing folder to another existing folder
        let movedBookmark = try await feed.updateBookmark(
            activityId: "activity_123",
            request: .init(
                folderId: "folder_456",
                newFolderId: "folder_789"
            )
        )
        
        suppressUnusedWarning(bookmark, bookmarkWithFolder, updatedBookmark, movedBookmark)
    }
    
    func removingBookmarks() async throws {
        // Removing a bookmark
        try await feed.removeBookmark(activityId: "activity_123", folderId: "folder_456")

        // When you read a feed we include the bookmark
        try await feed.getOrCreate()
        print(feed.state.activities[0].ownBookmarks)
    }
    
    func queryingBookmarks() async throws {
        // Query bookmarks
        let query = BookmarksQuery(limit: 5)
        let bookmarkList = client.bookmarkList(for: query)
        let page1 = try await bookmarkList.get()

        // Get next page
        let page2 = try await bookmarkList.queryMoreBookmarks(limit: 3)

        // Query by activity ID
        let activityBookmarkList = client.bookmarkList(
            for: .init(
                filter: .equal(.activityId, "activity_123")
            )
        )
        let activityBookmarks = try await activityBookmarkList.get()
        
        // Query by folder ID
        let folderBookmarkList = client.bookmarkList(
            for: .init(
                filter: .equal(.folderId, "folder_456")
            )
        )
        let folderBookmarks = try await folderBookmarkList.get()
        
        suppressUnusedWarning(page1, page2, activityBookmarks, folderBookmarks)
    }
    
    func queryingBookmarkFolders() async throws {
        // Query bookmark folders
        let query = BookmarkFoldersQuery(limit: 5)
        let bookmarkFolderList = client.bookmarkFolderList(for: query)
        let page1 = try await bookmarkFolderList.get()
        
        // Get next page
        let page2 = try await bookmarkFolderList.queryMoreBookmarkFolders(limit: 3)

        // Query by folder name (partial matching)
        let projectFolderList = client.bookmarkFolderList(
            for: .init(
                filter: .contains(.folderName, "project")
            )
        )
        let projectFolders = try await projectFolderList.get()
        
        suppressUnusedWarning(page1, page2, projectFolders)
    }
}
