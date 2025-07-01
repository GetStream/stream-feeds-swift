//
// Copyright © 2025 Stream.io Inc. All rights reserved.
//

import Foundation
import StreamCore

final class BookmarksRepository: Sendable {
    private let apiClient: DefaultAPI
    
    init(apiClient: DefaultAPI) {
        self.apiClient = apiClient
    }
    
    // MARK: - Bookmarks
    
    func queryBookmarks(with query: BookmarksQuery) async throws -> PaginationResult<BookmarkData> {
        let response = try await apiClient.queryBookmarks(queryBookmarksRequest: query.toRequest())
        return PaginationResult(
            models: response.bookmarks.map { $0.toModel() },
            pagination: PaginationData(next: response.next, previous: response.prev))
    }
    
    func addBookmark(activityId: String, request: AddBookmarkRequest) async throws -> BookmarkData {
        let response = try await apiClient.addBookmark(activityId: activityId, addBookmarkRequest: request)
        return response.bookmark.toModel()
    }
    
    func removeBookmark(activityId: String, folderId: String?) async throws -> BookmarkData {
        let response = try await apiClient.deleteBookmark(activityId: activityId, folderId: folderId)
        return response.bookmark.toModel()
    }
    
    func updateBookmark(activityId: String, request: UpdateBookmarkRequest) async throws -> BookmarkData {
        let response = try await apiClient.updateBookmark(activityId: activityId, updateBookmarkRequest: request)
        return response.bookmark.toModel()
    }
    
    // MARK: - Bookmark Folders
    
    func queryBookmarkFolders(with query: BookmarkFoldersQuery) async throws -> PaginationResult<BookmarkFolderData> {
        let response = try await apiClient.queryBookmarkFolders(queryBookmarkFoldersRequest: query.toRequest())
        return PaginationResult(
            models: response.bookmarkFolders.map { $0.toModel() },
            pagination: PaginationData(next: response.next, previous: response.prev))
    }
}
